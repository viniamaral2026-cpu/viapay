/*
 * Payment Service - Core payment functionality
 * Handles payment intents, state management, and ledger integration
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

enum PaymentStatus {
  CREATED = 'CREATED',
  PENDING = 'PENDING',
  AUTHORIZED = 'AUTHORIZED',
  PROCESSING = 'PROCESSING',
  SETTLEMENT_PENDING = 'SETTLEMENT_PENDING',
  SETTLED = 'SETTLED',
  FAILED = 'FAILED',
  CANCELLED = 'CANCELLED',
  EXPIRED = 'EXPIRED',
  REFUNDED = 'REFUNDED',
}

interface PaymentIntentData {
  id: string;
  merchantId: string;
  customerId?: string;
  amount: number;
  currency: string;
  paymentMethod?: string;
  provider?: string;
  providerReference?: string;
  metadata?: Record<string, any>;
  expiresAt?: Date;
}

interface PaymentResult {
  paymentId: string;
  status: PaymentStatus;
  ledgerEntryId?: string;
  message: string;
}

/**
 * Cria um PaymentIntent com validação de estados
 */
export async function createPaymentIntent(data: PaymentIntentData): Promise<PaymentResult> {
  // Validate amount is positive
  if (data.amount <= 0) {
    throw new Error('Payment amount must be greater than zero');
  }

  // Validate currency format (ISO 4217)
  if (data.currency.length !== 3) {
    throw new Error('Currency must be a 3-letter ISO code');
  }

  // Check for duplicate payment intent (idempotency)
  const existingIntent = await prisma.paymentIntent.findFirst({
    where: {
      paymentId: data.merchantId, // Using merchantId as a simple idempotency key
    },
  });

  if (existingIntent) {
    // Return existing payment intent
    return {
      paymentId: existingIntent,
      status: existingIntent.status,
      ledgerEntryId: existingIntent.ledgerEntryId,
      message: 'Payment intent already exists (idempotent)',
    };
  }

  // Create the PaymentIntent with pending status
  const paymentIntent = await prisma.paymentIntent.create({
    data: {
      paymentId: data.merchantId, // Using merchantId as paymentId for simplicity
      merchantId: data.merchantId,
      customerId: data.customerId,
      amount: data.amount,
      currency: data.currency,
      status: PaymentStatus.PENDING,
      paymentMethod: data.paymentMethod,
      provider: data.provider,
      providerReference: data.providerReference,
      metadata: data.metadata,
      expiresAt: data.expiresAt,
    },
  });

  // Create ledger entry for the payment creation
  const ledgerEntry = await prisma.ledgerEntry.create({
    data: {
      debit: 0,
      credit: data.amount,
      currency: data.currency,
      amount: data.amount,
      reference: `payment_${data.merchantId}`,
      transactionId: paymentIntent.paymentId,
      type: 'payment',
      status: 'pending',
    },
  });

  return {
    paymentId: paymentIntent.paymentId,
    status: PaymentStatus.PENDING,
    ledgerEntryId: ledgerEntry.id,
    message: 'Payment intent created successfully',
  };
}

/**
 * Obtém o status de um PaymentIntent
 */
export async function getPaymentIntent(paymentId: string) {
  const intent = await prisma.paymentIntent.findUnique({
    where: { paymentId },
    include: {
      payment: true,
    },
  });

  if (!intent) {
    return null;
  }

  return {
    id: intent.paymentId,
    merchantId: intent.merchantId,
    amount: intent.amount,
    currency: intent.currency,
    status: intent.status,
    createdAt: intent.createdAt,
    expiredAt: intent.expiresAt,
    metadata: intent.metadata,
  };
}

/**
 * Atualiza o estado de um PaymentIntent
 * Estados válidas transições:
 * CREATED -> PENDING -> AUTHORIZED -> PROCESSING -> SETTLEMENT_PENDING -> SETTLED
 * Cualquer estado -> FAILED, CANCELLED, EXPIRED, REFUNDED
 */
export async function updatePaymentStatus(
  paymentId: string,
  newStatus: PaymentStatus,
  reason?: string
): Promise<{ paymentId: string; status: PaymentStatus; ledgerEntryId?: string }> {
  const validTransitions: Record<PaymentStatus, PaymentStatus[]> = {
    [PaymentStatus.CREATED]: [PaymentStatus.PENDING],
    [PaymentStatus.PENDING]: [PaymentStatus.AUTHORIZED, PaymentStatus.FAILED, PaymentStatus.CANCELLED, PaymentStatus.EXPIRED],
    [PaymentStatus.AUTHORIZED]: [PaymentStatus.PROCESSING, PaymentStatus.FAILED, PaymentStatus.CANCELLED],
    [PaymentStatus.PROCESSING]: [PaymentStatus.SETTLEMENT_PENDING, PaymentStatus.FAILED, PaymentStatus.CANCELLED],
    [PaymentStatus.SETTLEMENT_PENDING]: [PaymentStatus.SETTLED, PaymentStatus.FAILED],
    [PaymentStatus.SETTLED]: [], // Terminal state
    [PaymentStatus.FAILED]: [PaymentStatus.REFUNDED], // Can refund from failed if partially processed
    [PaymentStatus.CANCELLED]: [], // Terminal state
    [PaymentStatus.EXPIRED]: [], // Terminal state
    [PaymentStatus.REFUNDED]: [], // Terminal state
  };

  // Check if transition is valid
  const allowedTransitions = validTransitions[PaymentStatus.PENDING]; // Simplified for example
  // In a full implementation, would need to track current state from DB

  // Update the payment intent
  const intent = await prisma.paymentIntent.update({
    where: { paymentId },
    data: { status: newStatus },
  });

  // Create or update ledger entry based on status
  let ledgerEntryId: string | undefined;

  switch (newStatus) {
    case PaymentStatus.SETTLED:
      // Ledger: Credit to merchant, Debit to clearing
      const settledLedger = await prisma.ledgerEntry.create({
        data: {
          debit: 0,
          credit: 0, // Will be calculated based on fees
          currency: 'BRL',
          amount: 0, // Will be recalculated
          reference: `settlement_${intent.paymentId}`,
          transactionId: intent.paymentId,
          type: 'settlement',
          status: 'pending',
        },
      });
      ledgerEntryId = settledLedger.id;
      break;

    case PaymentStatus.REFUNDED:
      // Ledger: Reverse the original entry
      const refundLedger = await prisma.ledgerEntry.create({
        data: {
          debit: 0,
          credit: 0, // Will be calculated based on original entry
          currency: 'BRL',
          amount: 0,
          reference: `refund_${intent.paymentId}`,
          transactionId: intent.paymentId,
          type: 'refund',
          status: 'pending',
        },
      });
      ledgerEntryId = refundLedger.id;
      break;

    case PaymentStatus.FAILED:
      // Ledger: Mark as failed, no financial movement
      const failedLedger = await prisma.ledgerEntry.create({
        data: {
          debit: 0,
          credit: 0,
          currency: 'BRL',
          amount: 0,
          reference: `failure_${intent.paymentId}`,
          transactionId: intent.paymentId,
          type: 'failure',
          status: 'pending',
        },
      });
      ledgerEntryId = failedLedger.id;
      break;

    default:
      // For other states, just update the intent status
      break;
  }

  return {
    paymentId: intent.paymentId,
    status: intent.status,
    ledgerEntryId,
  };
}

/**
 * Processa um pagamento (do PENDING para PROCESSING/Settlement)
 */
export async function processPayment(paymentId: string) {
  const intent = await prisma.paymentIntent.findUnique({
    where: { paymentId },
  });

  if (!intent) {
    throw new Error('Payment intent not found');
  }

  if (intent.status !== PaymentStatus.PENDING) {
    throw new Error(`Cannot process payment in ${intent.status} status`);
  }

  // Update status to PROCESSING
  await prisma.paymentIntent.update({
    where: { paymentId },
    data: { status: PaymentStatus.PROCESSING },
  });

  // TODO: Integrate with Payment Router, FX Engine, Settlement Engine
  // TODO: Connect with external providers (Stripe, Efí, Solana, Thunes, etc.)

  // After successful processing, move to SETTLEMENT_PENDING
  await prisma.paymentIntent.update({
    where: { paymentId },
    data: { status: PaymentStatus.SETTLEMENT_PENDING },
  });

  // Create ledger entry for processing
  const ledgerEntry = await prisma.ledgerEntry.create({
    data: {
      debit: 0,
      credit: intent.amount,
      currency: intent.currency,
      amount: intent.amount,
      reference: `processing_${intent.paymentId}`,
      transactionId: intent.paymentId,
      type: 'processing',
      status: 'pending',
    },
  });

  return {
    paymentId: intent.paymentId,
    status: PaymentStatus.SETTLEMENT_PENDING,
    ledgerEntryId: ledgerEntry.id,
    message: 'Payment processed successfully',
  };
}

/**
 * Cancela um pagamento
 */
export async function cancelPayment(paymentId: string, reason: string) {
  const intent = await prisma.paymentIntent.findUnique({
    where: { paymentId },
  });

  if (!intent) {
    throw new Error('Payment intent not found');
  }

  if (['SETTLED', 'REFUNDED'].includes(intent.status)) {
    throw new Error(`Cannot cancel payment in ${intent.status} status`);
  }

  await prisma.paymentIntent.update({
    where: { paymentId },
    data: { status: PaymentStatus.CANCELLED },
  });

  // Create ledger entry for cancellation
  const ledgerEntry = await prisma.ledgerEntry.create({
    data: {
      debit: 0,
      credit: 0,
      currency: intent.currency,
      amount: 0,
      reference: `cancellation_${intent.paymentId}`,
      transactionId: intent.paymentId,
      type: 'cancellation',
      status: 'pending',
    },
  });

  return {
    paymentId: intent.paymentId,
    status: PaymentStatus.CANCELLED,
    ledgerEntryId: ledgerEntry.id,
    message: 'Payment cancelled successfully',
  };
}

/**
 * Refund um pagamento
 */
export async function refundPayment(paymentId: string, amount?: number) {
  const intent = await prisma.paymentIntent.findUnique({
    where: { paymentId },
  });

  if (!intent) {
    throw new Error('Payment intent not found');
  }

  if (intent.status !== PaymentStatus.SETTLED && intent.status !== PaymentStatus.PROCESSING) {
    throw new Error(`Cannot refund payment in ${intent.status} status`);
  }

  // Determine refund amount
  const refundAmount = amount || intent.amount;

  await prisma.paymentIntent.update({
    where: { paymentId },
    data: { status: PaymentStatus.REFUNDED },
  });

  // Create ledger entry for refund
  const ledgerEntry = await prisma.ledgerEntry.create({
    data: {
      debit: 0,
      credit: refundAmount,
      currency: intent.currency,
      amount: refundAmount,
      reference: `refund_${intent.paymentId}`,
      transactionId: intent.paymentId,
      type: 'refund',
      status: 'pending',
    },
  });

  return {
    paymentId: intent.paymentId,
    status: PaymentStatus.REFUNDED,
    ledgerEntryId: ledgerEntry.id,
    message: 'Payment refunded successfully',
  };
}

export { PaymentStatus };

export type { PaymentIntentData, PaymentResult };