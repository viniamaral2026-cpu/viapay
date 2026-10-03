import "dotenv/config";

import { Merchant } from "../../src/domain/entities/merchant.js";
import { Payment } from "../../src/domain/entities/payment.js";
import { Settlement } from "../../src/domain/entities/settlement.js";
import { MoneyBRL } from "../../src/domain/value-objects/money-brl.js";

import { PrismaMerchantRepository } from "../../src/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "../../src/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaSettlementRepository } from "../../src/infrastructure/repositories/prisma-settlement-repository.js";
import { PrismaPaymentEventRepository } from "../../src/infrastructure/repositories/prisma-payment-event-repository.js";
import { PrismaUnitOfWork } from "../../src/infrastructure/database/prisma-unit-of-work.js";

import { ProcessSettlement } from "../../src/application/use-cases/settlement/process-settlement.js";

import { db } from "../../src/prisma/db.js";

const merchantId =
  "integration-process-settlement-merchant-001";

const paymentId =
  "integration-process-settlement-payment-001";

const settlementId =
  "integration-process-settlement-001";

const externalId =
  "integration-process-settlement-external-001";

async function cleanup(): Promise<void> {
  await db.paymentEvent.deleteMany({
    where: {
      paymentId,
    },
  });

  await db.settlement.deleteMany({
    where: {
      id: settlementId,
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
  console.log(
    "VIAPAY — PROCESS SETTLEMENT POSTGRES INTEGRATION TEST",
  );
  console.log("==============================================");

  await cleanup();

  const merchantRepository =
    new PrismaMerchantRepository();

  const paymentRepository =
    new PrismaPaymentRepository();

  const settlementRepository =
    new PrismaSettlementRepository();

  const paymentEventRepository =
    new PrismaPaymentEventRepository();

  const unitOfWork =
    new PrismaUnitOfWork();

  const merchant = Merchant.create({
    id: merchantId,
    name: "ViaPay Process Settlement Integration",
    document: "00000000000888",
    wallet: "process-settlement-integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet:
      "process-settlement-integration-wallet",
  });

  await paymentRepository.create(payment);

  console.log("✓ Payment criado no PostgreSQL");

  const settlement = Settlement.create({
    id: settlementId,
    paymentId,
    amountBRLMinor: 4990n,
    externalId: null,
  });

  await settlementRepository.create(settlement);

  console.log("✓ Settlement criado no PostgreSQL");
  console.log(
    "  Status inicial:",
    settlement.status,
  );

  const useCase = new ProcessSettlement(
    unitOfWork,
    settlementRepository,
    paymentEventRepository,
  );

  const first = await useCase.execute({
    settlementId,
    externalId,
    payload: {
      provider: "integration-provider",
      transactionId:
        "integration-settlement-tx-001",
      source: "postgres-integration-test",
    },
  });

  if (!first.processed) {
    throw new Error(
      "First settlement processing should be processed.",
    );
  }

  if (first.status !== "SETTLED") {
    throw new Error(
      `Expected SETTLED, received ${first.status}.`,
    );
  }

  if (!first.settledEventId) {
    throw new Error(
      "SETTLED event ID should be returned.",
    );
  }

  console.log("✓ Settlement processado");
  console.log("✓ PENDING → PROCESSING → SETTLED");
  console.log(
    "  SETTLED Event ID:",
    first.settledEventId,
  );

  const persisted =
    await settlementRepository.findById(
      settlementId,
    );

  if (!persisted) {
    throw new Error(
      "Settlement should exist after processing.",
    );
  }

  if (persisted.status !== "SETTLED") {
    throw new Error(
      `Expected persisted SETTLED, received ${persisted.status}.`,
    );
  }

  if (!persisted.settledAt) {
    throw new Error(
      "settledAt should be persisted.",
    );
  }

  console.log(
    "✓ Settlement SETTLED confirmado no PostgreSQL",
  );

  console.log("✓ settledAt persistido");

  const eventsAfterFirst =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  if (eventsAfterFirst.length !== 2) {
    throw new Error(
      `Expected 2 settlement events, received ${eventsAfterFirst.length}.`,
    );
  }

  const startedEvent =
    eventsAfterFirst.find(
      (event) =>
        event.type === "SETTLEMENT_STARTED",
    );

  const settledEvent =
    eventsAfterFirst.find(
      (event) =>
        event.type === "SETTLED",
    );

  if (!startedEvent) {
    throw new Error(
      "SETTLEMENT_STARTED event was not persisted.",
    );
  }

  if (!settledEvent) {
    throw new Error(
      "SETTLED event was not persisted.",
    );
  }

  if (
    startedEvent.externalId !==
    `${externalId}:started`
  ) {
    throw new Error(
      "SETTLEMENT_STARTED externalId is incorrect.",
    );
  }

  if (
    settledEvent.externalId !==
    `${externalId}:settled`
  ) {
    throw new Error(
      "SETTLED externalId is incorrect.",
    );
  }

  console.log(
    "✓ SETTLEMENT_STARTED persistido",
  );

  console.log("✓ SETTLED persistido");
  console.log("✓ External IDs dos eventos confirmados");

  const duplicate = await useCase.execute({
    settlementId,
    externalId,
    payload: {
      duplicate: true,
    },
  });

  if (duplicate.processed) {
    throw new Error(
      "Duplicate settlement must not be processed.",
    );
  }

  if (duplicate.status !== "SETTLED") {
    throw new Error(
      "Duplicate processing should return SETTLED.",
    );
  }

  console.log(
    "✓ Processamento duplicado tratado de forma idempotente",
  );

  const eventsAfterDuplicate =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  if (eventsAfterDuplicate.length !== 2) {
    throw new Error(
      "Duplicate processing created additional events.",
    );
  }

  console.log(
    "✓ Nenhum evento duplicado criado",
  );

  const recoveredByExternal =
    await settlementRepository.findByExternalId(
      externalId,
    );

  if (recoveredByExternal !== null) {
    throw new Error(
      "Settlement externalId should remain null because the process input externalId is not persisted on Settlement.",
    );
  }

  console.log(
    "✓ externalId do processamento não confundido com externalId do Settlement",
  );

  const persistedStarted =
    await paymentEventRepository.findByExternalId(
      `${externalId}:started`,
    );

  if (!persistedStarted) {
    throw new Error(
      "SETTLEMENT_STARTED event should be recoverable by externalId.",
    );
  }

  const persistedSettled =
    await paymentEventRepository.findByExternalId(
      `${externalId}:settled`,
    );

  if (!persistedSettled) {
    throw new Error(
      "SETTLED event should be recoverable by externalId.",
    );
  }

  console.log(
    "✓ SETTLEMENT_STARTED recuperado por externalId",
  );

  console.log(
    "✓ SETTLED recuperado por externalId",
  );

  await cleanup();

  console.log("✓ Dados de integração removidos");

  console.log();
  console.log(
    "✓ PROCESS SETTLEMENT POSTGRES TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ PROCESS SETTLEMENT POSTGRES TEST FALHOU",
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
