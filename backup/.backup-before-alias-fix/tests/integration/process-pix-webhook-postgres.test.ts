import "dotenv/config";

import { Merchant } from "@/domain/entities/merchant.js";
import { Payment } from "@/domain/entities/payment.js";
import { PixCharge } from "@/domain/entities/pix-charge.js";
import { MoneyBRL } from "@/domain/value-objects/money-brl.js";

import { PrismaMerchantRepository } from "@/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "@/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaPixChargeRepository } from "@/infrastructure/repositories/prisma-pix-charge-repository.js";
import { PrismaPaymentEventRepository } from "@/infrastructure/repositories/prisma-payment-event-repository.js";

import { ProcessPixWebhook } from "@/application/use-cases/webhook/process-pix-webhook.js";

import { db } from "@/prisma/db.js";

const merchantId = "integration-webhook-merchant-001";
const paymentId = "integration-webhook-payment-001";
const pixChargeId = "integration-webhook-pix-001";

const externalId = "integration-webhook-provider-event-001";

async function cleanup(): Promise<void> {
  await db.paymentEvent.deleteMany({
    where: {
      paymentId,
    },
  });

  await db.pixCharge.deleteMany({
    where: {
      id: pixChargeId,
    },
  });

  await db.payment.deleteMany({
    where: {
      id: paymentId,
    },
  });

  await db.merchant.deleteMany({
    where: {
      id: merchantId,
    },
  });
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — PIX WEBHOOK POSTGRES INTEGRATION TEST");
  console.log("==============================================");

  await cleanup();

  const merchantRepository =
    new PrismaMerchantRepository();

  const paymentRepository =
    new PrismaPaymentRepository();

  const pixChargeRepository =
    new PrismaPixChargeRepository();

  const paymentEventRepository =
    new PrismaPaymentEventRepository();

  const merchant = Merchant.create({
    id: merchantId,
    name: "ViaPay Webhook Integration",
    document: "00000000000666",
    wallet: "webhook-integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: merchant.wallet ?? "webhook-integration-wallet",
  });

  await paymentRepository.create(payment);

  console.log("✓ Payment criado no PostgreSQL");

  const pixCharge = PixCharge.create({
    id: pixChargeId,
    paymentId,
    provider: "integration-provider",
    providerId: "integration-provider-charge-001",
    qrCode: "000201010212WEBHOOK",
    amountBRLMinor: 4990n,
    expiresAt: new Date(
      Date.now() + 15 * 60 * 1000,
    ),
    status: "ACTIVE",
  });

  await pixChargeRepository.create(pixCharge);

  console.log("✓ PixCharge criada no PostgreSQL");
  console.log("  Status:", pixCharge.status);

  const useCase = new ProcessPixWebhook(
    paymentRepository,
    pixChargeRepository,
    paymentEventRepository,
  );

  const paidAt = new Date(
    "2026-10-03T10:30:00.000Z",
  );

  const first = await useCase.execute({
    externalId,
    provider: "integration-provider",
    providerId: "integration-provider-charge-001",
    paymentId,
    amountBRLMinor: 4990n,
    paidAt,
    payload: {
      provider: "integration-provider",
      transaction: "integration-tx-001",
      source: "postgres-integration-test",
    },
  });

  if (!first.processed) {
    throw new Error(
      "First webhook should be processed.",
    );
  }

  console.log("✓ Primeiro webhook processado");
  console.log("  Event ID:", first.eventId);

  const chargeAfterFirst =
    await pixChargeRepository.findByPaymentId(
      paymentId,
    );

  if (!chargeAfterFirst) {
    throw new Error(
      "PIX charge should exist after webhook.",
    );
  }

  if (chargeAfterFirst.status !== "PAID") {
    throw new Error(
      `Expected PAID, received ${chargeAfterFirst.status}.`,
    );
  }

  if (
    chargeAfterFirst.paidAt?.getTime() !==
    paidAt.getTime()
  ) {
    throw new Error(
      "paidAt was not persisted correctly.",
    );
  }

  console.log("✓ PixCharge persistida como PAID");
  console.log("✓ paidAt confirmado no PostgreSQL");

  const eventsAfterFirst =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  if (eventsAfterFirst.length !== 1) {
    throw new Error(
      `Expected 1 event, received ${eventsAfterFirst.length}.`,
    );
  }

  if (eventsAfterFirst[0].type !== "PIX_PAID") {
    throw new Error(
      "Expected PIX_PAID event.",
    );
  }

  console.log("✓ PaymentEvent PIX_PAID persistido");

  const duplicate = await useCase.execute({
    externalId,
    provider: "integration-provider",
    providerId: "integration-provider-charge-001",
    paymentId,
    amountBRLMinor: 4990n,
    paidAt,
    payload: {
      duplicate: true,
    },
  });

  if (duplicate.processed) {
    throw new Error(
      "Duplicate webhook must not be processed.",
    );
  }

  if (duplicate.eventId !== first.eventId) {
    throw new Error(
      "Duplicate webhook must return original event ID.",
    );
  }

  console.log("✓ Webhook duplicado tratado de forma idempotente");
  console.log("✓ Event ID original preservado");

  const eventsAfterDuplicate =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  if (eventsAfterDuplicate.length !== 1) {
    throw new Error(
      "Duplicate webhook created another event.",
    );
  }

  console.log("✓ Nenhum evento duplicado criado");

  let amountRejected = false;

  try {
    await useCase.execute({
      externalId:
        "integration-webhook-invalid-amount-001",
      provider: "integration-provider",
      providerId: "integration-provider-charge-001",
      paymentId,
      amountBRLMinor: 5000n,
      paidAt,
    });
  } catch {
    amountRejected = true;
  }

  if (!amountRejected) {
    throw new Error(
      "Invalid webhook amount should be rejected.",
    );
  }

  console.log("✓ Valor divergente rejeitado");

  const persistedEvent =
    await paymentEventRepository.findByExternalId(
      externalId,
    );

  if (!persistedEvent) {
    throw new Error(
      "Webhook event should be recoverable by externalId.",
    );
  }

  if (persistedEvent.id !== first.eventId) {
    throw new Error(
      "externalId returned wrong event.",
    );
  }

  console.log("✓ Evento recuperado por externalId");

  await cleanup();

  console.log("✓ Dados de integração removidos");

  console.log();
  console.log(
    "✓ PIX WEBHOOK POSTGRES TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ PIX WEBHOOK POSTGRES TEST FALHOU",
  );
  console.error(error);

  try {
    await cleanup();
  } catch (cleanupError) {
    console.error(
      "Erro durante cleanup:",
      cleanupError,
    );
  }

  process.exitCode = 1;
});
