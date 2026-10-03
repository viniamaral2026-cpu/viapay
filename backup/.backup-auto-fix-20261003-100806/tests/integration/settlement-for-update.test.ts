import "dotenv/config";

import { Merchant } from "@/domain/entities/merchant.js";
import { Payment } from "@/domain/entities/payment.js";
import { Settlement } from "@/domain/entities/settlement.js";
import { MoneyBRL } from "@/domain/value-objects/money-brl.js";

import { PrismaMerchantRepository } from "@/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "@/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaSettlementRepository } from "@/infrastructure/repositories/prisma-settlement-repository.js";
import { PrismaSettlementLockRepository } from "@/infrastructure/repositories/prisma-settlement-lock-repository.js";
import { PrismaUnitOfWork } from "@/infrastructure/database/prisma-unit-of-work.js";

import { db } from "@/prisma/db.js";
import type { PrismaTransactionClient } from "@/infrastructure/database/prisma-transaction-client.js";

const merchantId = "lock-test-merchant-001";
const paymentId = "lock-test-payment-001";
const settlementId = "lock-test-settlement-001";

async function cleanup(): Promise<void> {
  await db.settlement.deleteMany({
    where: { id: settlementId },
  });

  await db.payment.deleteMany({
    where: { id: paymentId },
  });

  await db.merchant.deleteMany({
    where: { id: merchantId },
  });
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — POSTGRES FOR UPDATE LOCK TEST");
  console.log("==============================================");

  await cleanup();

  const merchantRepository = new PrismaMerchantRepository();
  const paymentRepository = new PrismaPaymentRepository();
  const settlementRepository = new PrismaSettlementRepository();

  const lockRepository =
    new PrismaSettlementLockRepository();

  const unitOfWork = new PrismaUnitOfWork();

  const merchant = Merchant.create({
    id: merchantId,
    name: "Postgres Lock Test",
    document: "00000000000666",
    wallet: "postgres-lock-wallet",
  });

  await merchantRepository.create(merchant);

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: "postgres-lock-wallet",
  });

  await paymentRepository.create(payment);

  const settlement = Settlement.create({
    id: settlementId,
    paymentId,
    amountBRLMinor: 4990n,
    externalId: null,
  });

  await settlementRepository.create(settlement);

  console.log("✓ Settlement criado");
  console.log("✓ Status inicial: PENDING");

  let workerAEntered = false;
  let workerAReleased = false;
  let workerBEntered = false;
  let workerBCompleted = false;

  const workerA = unitOfWork.execute(
    async (transaction) => {
      const tx =
        transaction as PrismaTransactionClient;

      workerAEntered = true;

      const locked =
        await lockRepository.findByIdForUpdate(
          tx,
          settlementId,
        );

      if (!locked) {
        throw new Error(
          "Worker A could not lock settlement.",
        );
      }

      console.log(
        "✓ Worker A adquiriu FOR UPDATE",
      );

      locked.startProcessing();

      await tx.settlement.update({
        where: {
          id: settlementId,
        },
        data: {
          status: locked.status,
          updatedAt: locked.updatedAt,
        },
      });

      console.log(
        "✓ Worker A colocou Settlement em PROCESSING",
      );

      await sleep(1000);

      workerAReleased = true;

      console.log(
        "✓ Worker A encerrando transação e liberando lock",
      );
    },
  );

  while (!workerAEntered) {
    await sleep(10);
  }

  await sleep(100);

  const workerBStartedAt = Date.now();

  const workerB = unitOfWork.execute(
    async (transaction) => {
      const tx =
        transaction as PrismaTransactionClient;

      workerBEntered = true;

      console.log(
        "→ Worker B tentando adquirir FOR UPDATE...",
      );

      const locked =
        await lockRepository.findByIdForUpdate(
          tx,
          settlementId,
        );

      if (!locked) {
        throw new Error(
          "Worker B could not lock settlement.",
        );
      }

      console.log(
        "✓ Worker B adquiriu o lock após Worker A",
      );

      workerBCompleted = true;

      if (locked.status !== "PROCESSING") {
        throw new Error(
          `Worker B deveria encontrar PROCESSING, encontrou ${locked.status}.`,
        );
      }
    },
  );

  await Promise.all([
    workerA,
    workerB,
  ]);

  const workerBWaitedMs =
    Date.now() - workerBStartedAt;

  console.log(
    `✓ Worker B aguardou aproximadamente ${workerBWaitedMs}ms`,
  );

  if (!workerAReleased) {
    throw new Error(
      "Worker A did not release its transaction.",
    );
  }

  if (!workerBEntered) {
    throw new Error(
      "Worker B did not enter transaction.",
    );
  }

  if (!workerBCompleted) {
    throw new Error(
      "Worker B did not complete.",
    );
  }

  if (workerBWaitedMs < 700) {
    throw new Error(
      `FOR UPDATE did not block Worker B correctly. Waited only ${workerBWaitedMs}ms.`,
    );
  }

  const finalSettlement =
    await settlementRepository.findById(
      settlementId,
    );

  if (!finalSettlement) {
    throw new Error(
      "Final settlement not found.",
    );
  }

  if (
    finalSettlement.status !==
    "PROCESSING"
  ) {
    throw new Error(
      `Expected PROCESSING, received ${finalSettlement.status}.`,
    );
  }

  console.log(
    "✓ PostgreSQL bloqueou o segundo worker",
  );

  console.log(
    "✓ FOR UPDATE funcionando corretamente",
  );

  console.log(
    "✓ Atualização executada dentro da mesma transação",
  );

  await cleanup();

  console.log("✓ Dados removidos");

  console.log();
  console.log(
    "✓ POSTGRES FOR UPDATE LOCK TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ POSTGRES FOR UPDATE LOCK TEST FALHOU",
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

  await db.$disconnect();

  process.exitCode = 1;
});
