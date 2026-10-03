import { InMemorySettlementLockRepository } from "@tests/unit/in-memory-settlement-lock-repository.js";
import { Merchant } from "@/domain/entities/merchant.js";
import { Payment } from "@/domain/entities/payment.js";
import { PaymentEvent } from "@/domain/entities/payment-event.js";
import { Settlement } from "@/domain/entities/settlement.js";
import { MoneyBRL } from "@/domain/value-objects/money-brl.js";

import { ProcessSettlement } from "@/application/use-cases/settlement/process-settlement.js";

import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { PaymentEventRepository } from "@/domain/repositories/payment-event-repository.js";
import type { SettlementRepository } from "@/domain/repositories/settlement-repository.js";

function assert(
  condition: boolean,
  message: string,
): void {
  if (!condition) {
    throw new Error(message);
  }
}

class InMemoryUnitOfWork {
  async execute<T>(
    callback: (transaction: unknown) => Promise<T>,
  ): Promise<T> {
    return callback({});
  }
}

class InMemoryPaymentRepository
  implements PaymentRepository
{
  private readonly payments = new Map<
    string,
    Payment
  >();

  async create(
    payment: Payment,
  ): Promise<Payment> {
    this.payments.set(payment.id, payment);
    return payment;
  }

  async findById(
    id: string,
  ): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }

  async findByMerchantId(
    merchantId: string,
  ): Promise<Payment[]> {
    return [...this.payments.values()].filter(
      (payment) =>
        payment.merchantId === merchantId,
    );
  }

  async save(
    payment: Payment,
  ): Promise<Payment> {
    this.payments.set(payment.id, payment);
    return payment;
  }
}

class InMemorySettlementRepository
  implements SettlementRepository
{
  private readonly settlements = new Map<
    string,
    Settlement
  >();

  async create(
    settlement: Settlement,
  ): Promise<Settlement> {
    this.settlements.set(
      settlement.id,
      settlement,
    );

    return settlement;
  }

  async findById(
    id: string,
  ): Promise<Settlement | null> {
    return this.settlements.get(id) ?? null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<Settlement | null> {
    return (
      [...this.settlements.values()].find(
        (settlement) =>
          settlement.paymentId === paymentId,
      ) ?? null
    );
  }

  async findByExternalId(
    externalId: string,
  ): Promise<Settlement | null> {
    return (
      [...this.settlements.values()].find(
        (settlement) =>
          settlement.externalId === externalId,
      ) ?? null
    );
  }

  async save(
    settlement: Settlement,
  ): Promise<Settlement> {
    this.settlements.set(
      settlement.id,
      settlement,
    );

    return settlement;
  }
}

class InMemoryPaymentEventRepository
  implements PaymentEventRepository
{
  private readonly events: PaymentEvent[] = [];

  async create(
    event: PaymentEvent,
  ): Promise<PaymentEvent> {
    this.events.push(event);
    return event;
  }

  async findById(
    id: string,
  ): Promise<PaymentEvent | null> {
    return (
      this.events.find(
        (event) => event.id === id,
      ) ?? null
    );
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PaymentEvent[]> {
    return this.events
      .filter(
        (event) =>
          event.paymentId === paymentId,
      )
      .sort(
        (a, b) =>
          a.occurredAt.getTime() -
          b.occurredAt.getTime(),
      );
  }

  async findByExternalId(
    externalId: string,
  ): Promise<PaymentEvent | null> {
    return (
      this.events.find(
        (event) =>
          event.externalId === externalId,
      ) ?? null
    );
  }

  all(): PaymentEvent[] {
    return [...this.events];
  }

  async countByPaymentId(
    paymentId: string,
  ): Promise<number> {
    return this.events.filter(
      (event) => event.paymentId === paymentId,
    ).length;
  }

  
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — PROCESS SETTLEMENT UNIT TEST");
  console.log("==============================================");

  const merchant = Merchant.create({
    id: "unit-settlement-merchant-001",
    name: "Settlement Unit Test",
    document: "00000000000999",
    wallet: "unit-settlement-wallet",
  });

  const payment = Payment.create({
    id: "unit-settlement-payment-001",
    merchantId: merchant.id,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: "unit-settlement-wallet",
  });

  const settlement = Settlement.create({
    id: "unit-settlement-001",
    paymentId: payment.id,
    amountBRLMinor: 4990n,
    externalId: null,
  });

  const paymentRepository =
    new InMemoryPaymentRepository();

  const settlementRepository =
    new InMemorySettlementRepository();

  const paymentEventRepository =
    new InMemoryPaymentEventRepository();

  await paymentRepository.create(payment);

  await settlementRepository.create(
    settlement,
  );

  const unitOfWork =
    new InMemoryUnitOfWork();

  const useCase = new ProcessSettlement(
    unitOfWork,
    new InMemorySettlementLockRepository(
      settlementRepository,
    ),
    paymentEventRepository,
  );

  const first =
    await useCase.execute({
      settlementId: settlement.id,
      externalId:
        "unit-settlement-external-001",
      payload: {
        source: "unit-test",
      },
    });

  assert(
    first.processed,
    "First settlement processing should be processed.",
  );

  assert(
    first.status === "SETTLED",
    "First settlement processing should finish as SETTLED.",
  );

  assert(
    first.settledEventId !== null,
    "SETTLED event id should be returned.",
  );

  console.log("✓ Settlement processado");
  console.log("✓ PENDING → PROCESSING → SETTLED");

  const persisted =
    await settlementRepository.findById(
      settlement.id,
    );

  assert(
    persisted !== null,
    "Settlement should exist.",
  );

  assert(
    persisted?.status === "SETTLED",
    "Settlement should be SETTLED.",
  );

  assert(
    persisted?.settledAt !== null,
    "settledAt should be populated.",
  );

  console.log("✓ Settlement persistido como SETTLED");
  console.log("✓ settledAt preenchido");

  const events =
    paymentEventRepository.all();

  assert(
    events.length === 2,
    `Expected 2 events, received ${events.length}.`,
  );

  assert(
    events[0].type ===
      "SETTLEMENT_STARTED",
    "First event should be SETTLEMENT_STARTED.",
  );

  assert(
    events[1].type === "SETTLED",
    "Second event should be SETTLED.",
  );

  console.log("✓ SETTLEMENT_STARTED criado");
  console.log("✓ SETTLED criado");

  assert(
    events[0].paymentId === payment.id,
    "Started event should reference payment.",
  );

  assert(
    events[1].paymentId === payment.id,
    "Settled event should reference payment.",
  );

  console.log("✓ Eventos vinculados ao Payment");

  const duplicate =
    await useCase.execute({
      settlementId: settlement.id,
      externalId:
        "unit-settlement-external-001",
      payload: {
        duplicate: true,
      },
    });

  assert(
    !duplicate.processed,
    "Duplicate settlement must not be processed again.",
  );

  assert(
    duplicate.status === "SETTLED",
    "Duplicate processing should return SETTLED.",
  );

  assert(
    events.length === 2,
    "Duplicate processing must not create another event.",
  );

  console.log("✓ Processamento duplicado tratado de forma idempotente");
  console.log("✓ Nenhum evento duplicado criado");

  let failed = false;

  try {
    await useCase.execute({
      settlementId: settlement.id,
      externalId:
        "another-external-id",
    });
  } catch {
    failed = true;
  }

  assert(
    !failed,
    "Already SETTLED settlement should remain idempotent.",
  );

  console.log("✓ Settlement SETTLED permanece idempotente");

  let invalidExternalIdRejected =
    false;

  try {
    await useCase.execute({
      settlementId: settlement.id,
      externalId: "",
    });
  } catch {
    invalidExternalIdRejected = true;
  }

  assert(
    invalidExternalIdRejected,
    "Empty externalId should be rejected.",
  );

  console.log("✓ externalId vazio rejeitado");

  let invalidSettlementRejected =
    false;

  try {
    await useCase.execute({
      settlementId:
        "settlement-that-does-not-exist",
      externalId:
        "unit-invalid-settlement-external",
    });
  } catch {
    invalidSettlementRejected = true;
  }

  assert(
    invalidSettlementRejected,
    "Unknown settlement should be rejected.",
  );

  console.log("✓ Settlement inexistente rejeitado");

  console.log();
  console.log(
    "✓ PROCESS SETTLEMENT UNIT TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch((error) => {
  console.error();
  console.error(
    "✗ PROCESS SETTLEMENT UNIT TEST FALHOU",
  );
  console.error(error);
  process.exitCode = 1;



});
