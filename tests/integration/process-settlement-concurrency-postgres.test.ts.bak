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
  "integration-concurrency-merchant-001";

const paymentId =
  "integration-concurrency-payment-001";

const settlementId =
  "integration-concurrency-settlement-001";

const externalIdA =
  "integration-concurrency-external-a";

const externalIdB =
  "integration-concurrency-external-b";

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
    "VIAPAY — PROCESS SETTLEMENT CONCURRENCY TEST",
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
    name: "ViaPay Concurrency Integration",
    document: "00000000000666",
    wallet: "concurrency-integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet:
      "concurrency-integration-wallet",
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

  /*
   * Duas instâncias independentes do use case.
   *
   * Isso é importante: não reutilizamos a mesma instância
   * para evitar mascarar problemas de concorrência em memória.
   */
  const useCaseA = new ProcessSettlement(
    new PrismaSettlementRepository(),
    new PrismaPaymentEventRepository(),
  );

  const useCaseB = new ProcessSettlement(
    new PrismaSettlementRepository(),
    new PrismaPaymentEventRepository(),
  );

  console.log();
  console.log(
    "→ Disparando dois processamentos simultâneos...",
  );

  const startedAt = Date.now();

  const results =
    await Promise.allSettled([
      useCaseA.execute({
        settlementId,
        externalId: externalIdA,
        payload: {
          worker: "A",
          source:
            "postgres-concurrency-test",
        },
      }),

      useCaseB.execute({
        settlementId,
        externalId: externalIdB,
        payload: {
          worker: "B",
          source:
            "postgres-concurrency-test",
        },
      }),
    ]);

  const elapsed = Date.now() - startedAt;

  console.log(
    `→ Processamentos concluídos em ${elapsed}ms`,
  );

  const fulfilled = results.filter(
    (
      result,
    ): result is PromiseFulfilledResult<
      Awaited<ReturnType<ProcessSettlement["execute"]>>
    > => result.status === "fulfilled",
  );

  const rejected = results.filter(
    (result) =>
      result.status === "rejected",
  );

  console.log(
    `  Sucessos: ${fulfilled.length}`,
  );

  console.log(
    `  Rejeitados: ${rejected.length}`,
  );

  for (const [index, result] of results.entries()) {
    if (result.status === "fulfilled") {
      console.log(
        `  Worker ${index === 0 ? "A" : "B"}:`,
        result.value.status,
        `processed=${result.value.processed}`,
      );
    } else {
      console.log(
        `  Worker ${index === 0 ? "A" : "B"} rejeitado:`,
        result.reason instanceof Error
          ? result.reason.message
          : result.reason,
      );
    }
  }

  /*
   * ==========================================================
   * VALIDAÇÃO FINAL DO SETTLEMENT
   * ==========================================================
   */

  const finalSettlement =
    await settlementRepository.findById(
      settlementId,
    );

  if (!finalSettlement) {
    throw new Error(
      "Settlement final não encontrado.",
    );
  }

  if (finalSettlement.status !== "SETTLED") {
    throw new Error(
      `Settlement final deveria ser SETTLED, mas foi ${finalSettlement.status}.`,
    );
  }

  if (!finalSettlement.settledAt) {
    throw new Error(
      "Settlement final deveria possuir settledAt.",
    );
  }

  console.log();
  console.log(
    "✓ Settlement final = SETTLED",
  );

  console.log(
    "✓ settledAt preenchido",
  );

  /*
   * ==========================================================
   * VALIDAÇÃO DOS EVENTOS
   * ==========================================================
   */

  const events =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  console.log();
  console.log(
    `→ Total de eventos encontrados: ${events.length}`,
  );

  const startedEvents =
    events.filter(
      (event) =>
        event.type ===
        "SETTLEMENT_STARTED",
    );

  const settledEvents =
    events.filter(
      (event) =>
        event.type === "SETTLED",
    );

  if (startedEvents.length !== 1) {
    throw new Error(
      `Esperado exatamente 1 SETTLEMENT_STARTED, encontrado ${startedEvents.length}.`,
    );
  }

  console.log(
    "✓ SETTLEMENT_STARTED = 1",
  );

  if (settledEvents.length !== 1) {
    throw new Error(
      `Esperado exatamente 1 SETTLED, encontrado ${settledEvents.length}.`,
    );
  }

  console.log(
    "✓ SETTLED = 1",
  );

  if (events.length !== 2) {
    throw new Error(
      `Esperado exatamente 2 eventos, encontrado ${events.length}.`,
    );
  }

  console.log(
    "✓ Total de eventos = 2",
  );

  /*
   * ==========================================================
   * VALIDAÇÃO DOS EXTERNAL IDs
   * ==========================================================
   */

  const startedEvent =
    startedEvents[0];

  const settledEvent =
    settledEvents[0];

  if (
    startedEvent.externalId !==
      `${externalIdA}:started` &&
    startedEvent.externalId !==
      `${externalIdB}:started`
  ) {
    throw new Error(
      `SETTLEMENT_STARTED possui externalId inesperado: ${startedEvent.externalId}`,
    );
  }

  if (
    settledEvent.externalId !==
      `${externalIdA}:settled` &&
    settledEvent.externalId !==
      `${externalIdB}:settled`
  ) {
    throw new Error(
      `SETTLED possui externalId inesperado: ${settledEvent.externalId}`,
    );
  }

  console.log(
    "✓ External IDs dos eventos consistentes",
  );

  /*
   * ==========================================================
   * VERIFICAÇÃO DE AUSÊNCIA DE DUPLICAÇÃO
   * ==========================================================
   */

  const duplicateStarted =
    events.filter(
      (event) =>
        event.type ===
        "SETTLEMENT_STARTED",
    ).length;

  const duplicateSettled =
    events.filter(
      (event) =>
        event.type === "SETTLED",
    ).length;

  if (duplicateStarted > 1) {
    throw new Error(
      "Concorrência gerou múltiplos SETTLEMENT_STARTED.",
    );
  }

  if (duplicateSettled > 1) {
    throw new Error(
      "Concorrência gerou múltiplos SETTLED.",
    );
  }

  console.log(
    "✓ Nenhum SETTLEMENT_STARTED duplicado",
  );

  console.log(
    "✓ Nenhum SETTLED duplicado",
  );

  /*
   * ==========================================================
   * RESULTADO
   * ==========================================================
   */

  await cleanup();

  console.log();
  console.log(
    "✓ Dados de integração removidos",
  );

  console.log();
  console.log(
    "==============================================",
  );

  console.log(
    "✓ PROCESS SETTLEMENT CONCURRENCY TEST CONCLUÍDO COM SUCESSO",
  );

  console.log(
    "==============================================",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ PROCESS SETTLEMENT CONCURRENCY TEST FALHOU",
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
