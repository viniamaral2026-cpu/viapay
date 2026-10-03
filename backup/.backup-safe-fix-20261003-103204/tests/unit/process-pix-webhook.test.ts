import { Merchant } from "@/domain/entities/merchant.js";
import { Payment } from "@/domain/entities/payment.js";
import { PaymentEvent } from "@/domain/entities/payment-event.js";
import { PixCharge } from "@/domain/entities/pix-charge.js";
import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { PaymentEventRepository } from "@/domain/repositories/payment-event-repository.js";
import type { PixChargeRepository } from "@/domain/repositories/pix-charge-repository.js";
import { MoneyBRL } from "@/domain/value-objects/money-brl.js";
import { ProcessPixWebhook } from "@/application/use-cases/webhook/process-pix-webhook.js";

function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(message);
  }
}

class FakePaymentRepository implements PaymentRepository {
  private payments = new Map<string, Payment>();

  constructor(payment: Payment) {
    this.payments.set(payment.id, payment);
  }

  async create(payment: Payment): Promise<Payment> {
    this.payments.set(payment.id, payment);
    return payment;
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }

  async save(payment: Payment): Promise<Payment> {
    this.payments.set(payment.id, payment);
    return payment;
  }
}

class FakePixChargeRepository implements PixChargeRepository {
  private charges = new Map<string, PixCharge>();

  constructor(charge: PixCharge) {
    this.charges.set(charge.id, charge);
  }

  async create(charge: PixCharge): Promise<PixCharge> {
    this.charges.set(charge.id, charge);
    return charge;
  }

  async findById(id: string): Promise<PixCharge | null> {
    return this.charges.get(id) ?? null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PixCharge | null> {
    for (const charge of this.charges.values()) {
      if (charge.paymentId === paymentId) {
        return charge;
      }
    }

    return null;
  }

  async findByProviderId(
    providerId: string,
  ): Promise<PixCharge | null> {
    for (const charge of this.charges.values()) {
      if (charge.providerId === providerId) {
        return charge;
      }
    }

    return null;
  }

  async save(charge: PixCharge): Promise<PixCharge> {
    this.charges.set(charge.id, charge);
    return charge;
  }
}

class FakePaymentEventRepository
  implements PaymentEventRepository
{
  private events = new Map<string, PaymentEvent>();

  async create(event: PaymentEvent): Promise<PaymentEvent> {
    this.events.set(event.id, event);
    return event;
  }

  async findById(id: string): Promise<PaymentEvent | null> {
    return this.events.get(id) ?? null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PaymentEvent[]> {
    return [...this.events.values()]
      .filter((event) => event.paymentId === paymentId)
      .sort(
        (a, b) =>
          a.occurredAt.getTime() -
          b.occurredAt.getTime(),
      );
  }

  async findByExternalId(
    externalId: string,
  ): Promise<PaymentEvent | null> {
    for (const event of this.events.values()) {
      if (event.externalId === externalId) {
        return event;
      }
    }

    return null;
  }

  count(): number {
    return this.events.size;
  }
}

function createFixture() {
  const merchant = Merchant.create({
    id: "unit-webhook-merchant-001",
    name: "ViaPay Webhook Unit",
    document: "00000000000777",
    wallet: "unit-webhook-wallet",
  });

  const payment = Payment.create({
    id: "unit-webhook-payment-001",
    merchantId: merchant.id,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: merchant.wallet ?? "unit-webhook-wallet",
  });

  const pixCharge = PixCharge.create({
    id: "unit-webhook-pix-001",
    paymentId: payment.id,
    provider: "unit-provider",
    providerId: "unit-provider-charge-001",
    qrCode: "000201010212UNIT",
    amountBRLMinor: 4990n,
    expiresAt: new Date(
      Date.now() + 15 * 60 * 1000,
    ),
    status: "ACTIVE",
  });

  const paymentRepository =
    new FakePaymentRepository(payment);

  const pixChargeRepository =
    new FakePixChargeRepository(pixCharge);

  const paymentEventRepository =
    new FakePaymentEventRepository();

  const useCase = new ProcessPixWebhook(
    paymentRepository,
    pixChargeRepository,
    paymentEventRepository,
  );

  return {
    payment,
    pixCharge,
    paymentRepository,
    pixChargeRepository,
    paymentEventRepository,
    useCase,
  };
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — PIX WEBHOOK UNIT TEST");
  console.log("==============================================");

  const fixture = createFixture();

  const paidAt = new Date(
    "2026-10-03T10:15:00.000Z",
  );

  const result = await fixture.useCase.execute({
    externalId: "provider-webhook-001",
    provider: "unit-provider",
    providerId: "unit-provider-charge-001",
    paymentId: fixture.payment.id,
    amountBRLMinor: 4990n,
    paidAt,
    payload: {
      provider: "unit-provider",
      transaction: "tx-001",
    },
  });

  assert(
    result.processed === true,
    "First webhook should be processed.",
  );

  assert(
    result.eventId.length > 0,
    "Webhook should return an event id.",
  );

  console.log("✓ Webhook PIX processado");

  const charge =
    await fixture.pixChargeRepository.findByPaymentId(
      fixture.payment.id,
    );

  assert(
    charge?.status === "PAID",
    "PIX charge should become PAID.",
  );

  assert(
    charge?.paidAt?.getTime() === paidAt.getTime(),
    "PIX charge paidAt should be preserved.",
  );

  console.log("✓ PixCharge marcada como PAID");

  const event =
    await fixture.paymentEventRepository.findByExternalId(
      "provider-webhook-001",
    );

  assert(
    event !== null,
    "PIX_PAID event should be created.",
  );

  assert(
    event?.type === "PIX_PAID",
    "Webhook should create PIX_PAID event.",
  );

  assert(
    event?.paymentId === fixture.payment.id,
    "Event should reference the payment.",
  );

  console.log("✓ PaymentEvent PIX_PAID criado");

  const eventCountBefore =
    fixture.paymentEventRepository.count();

  const duplicate =
    await fixture.useCase.execute({
      externalId: "provider-webhook-001",
      provider: "unit-provider",
      providerId: "unit-provider-charge-001",
      paymentId: fixture.payment.id,
      amountBRLMinor: 4990n,
      paidAt,
      payload: {
        duplicate: true,
      },
    });

  assert(
    duplicate.processed === false,
    "Duplicate webhook must not be processed again.",
  );

  assert(
    duplicate.eventId === result.eventId,
    "Duplicate webhook must return the original event id.",
  );

  assert(
    fixture.paymentEventRepository.count() ===
      eventCountBefore,
    "Duplicate webhook must not create another event.",
  );

  console.log("✓ Webhook duplicado tratado de forma idempotente");

  const invalidAmount = createFixture();

  let amountRejected = false;

  try {
    await invalidAmount.useCase.execute({
      externalId: "provider-webhook-invalid-amount",
      provider: "unit-provider",
      providerId: "unit-provider-charge-001",
      paymentId: invalidAmount.payment.id,
      amountBRLMinor: 5000n,
      paidAt,
    });
  } catch {
    amountRejected = true;
  }

  assert(
    amountRejected,
    "Webhook with invalid amount should be rejected.",
  );

  console.log("✓ Valor divergente rejeitado");

  const missingPayment = createFixture();

  let paymentRejected = false;

  try {
    await missingPayment.useCase.execute({
      externalId: "provider-webhook-missing-payment",
      provider: "unit-provider",
      providerId: "unit-provider-charge-001",
      paymentId: "payment-does-not-exist",
      amountBRLMinor: 4990n,
      paidAt,
    });
  } catch {
    paymentRejected = true;
  }

  assert(
    paymentRejected,
    "Webhook for nonexistent payment should be rejected.",
  );

  console.log("✓ Payment inexistente rejeitado");

  const alreadyPaid = createFixture();

  const firstPaid =
    await alreadyPaid.useCase.execute({
      externalId: "provider-webhook-paid-001",
      provider: "unit-provider",
      providerId: "unit-provider-charge-001",
      paymentId: alreadyPaid.payment.id,
      amountBRLMinor: 4990n,
      paidAt,
    });

  assert(
    firstPaid.processed === true,
    "First payment webhook should process.",
  );

  let alreadyPaidRejected = false;

  try {
    await alreadyPaid.useCase.execute({
      externalId: "provider-webhook-paid-002",
      provider: "unit-provider",
      providerId: "unit-provider-charge-001",
      paymentId: alreadyPaid.payment.id,
      amountBRLMinor: 4990n,
      paidAt,
    });
  } catch {
    alreadyPaidRejected = true;
  }

  assert(
    alreadyPaidRejected,
    "Already paid PIX must reject a different webhook.",
  );

  console.log("✓ PIX já pago protegido");

  console.log();
  console.log(
    "✓ PIX WEBHOOK UNIT TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch((error) => {
  console.error();
  console.error("✗ PIX WEBHOOK UNIT TEST FALHOU");
  console.error(error);
  process.exitCode = 1;
});
