import "dotenv/config";

import { Merchant } from "../../src/domain/entities/merchant.js";
import { Payment } from "../../src/domain/entities/payment.js";
import { PrismaMerchantRepository } from "../../src/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "../../src/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaSettlementRepository } from "../../src/infrastructure/repositories/prisma-settlement-repository.js";
import { MoneyBRL } from "../../src/domain/value-objects/money-brl.js";
import { CreateSettlement } from "../../src/application/use-cases/settlement/create-settlement.js";
import { db } from "../../src/prisma/db.js";

const merchantId = "integration-settlement-merchant-001";
const paymentId = "integration-settlement-payment-001";
const settlementId = "integration-settlement-001";
const externalId = "integration-settlement-external-001";

async function cleanup(): Promise<void> {
  await db.settlement.deleteMany({
    where: {
      paymentId,
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
  console.log("VIAPAY — SETTLEMENT POSTGRES INTEGRATION TEST");
  console.log("==============================================");

  await cleanup();

  const merchantRepository =
    new PrismaMerchantRepository();

  const paymentRepository =
    new PrismaPaymentRepository();

  const settlementRepository =
    new PrismaSettlementRepository();

  const merchant = Merchant.create({
    id: merchantId,
    name: "ViaPay Settlement Integration",
    document: "00000000000777",
    wallet: "settlement-integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: "settlement-integration-wallet",
  });

  await paymentRepository.create(payment);

  console.log("✓ Payment criado no PostgreSQL");

  const createSettlement = new CreateSettlement(
    paymentRepository,
    settlementRepository,
  );

  const settlement =
    await createSettlement.execute({
      id: settlementId,
      paymentId,
      amountBRLMinor: 4990n,
      externalId,
    });

  console.log("✓ Settlement criado no PostgreSQL");
  console.log("  ID:", settlement.id);
  console.log("  Status:", settlement.status);
  console.log(
    "  Valor:",
    settlement.amountBRLMinor.toString(),
  );

  if (settlement.paymentId !== paymentId) {
    throw new Error(
      "Settlement must reference the correct payment.",
    );
  }

  if (settlement.amountBRLMinor !== 4990n) {
    throw new Error(
      "Settlement amount was not persisted correctly.",
    );
  }

  if (settlement.status !== "PENDING") {
    throw new Error(
      "New settlement should start as PENDING.",
    );
  }

  if (settlement.externalId !== externalId) {
    throw new Error(
      "externalId was not persisted correctly.",
    );
  }

  console.log("✓ Payment vinculado");
  console.log("✓ Valor confirmado");
  console.log("✓ Status PENDING confirmado");
  console.log("✓ externalId confirmado");

  const recoveredById =
    await settlementRepository.findById(
      settlementId,
    );

  if (!recoveredById) {
    throw new Error(
      "Settlement should be recoverable by id.",
    );
  }

  console.log("✓ Settlement recuperado por ID");

  const recoveredByPayment =
    await settlementRepository.findByPaymentId(
      paymentId,
    );

  if (!recoveredByPayment) {
    throw new Error(
      "Settlement should be recoverable by paymentId.",
    );
  }

  if (recoveredByPayment.id !== settlementId) {
    throw new Error(
      "paymentId lookup returned the wrong settlement.",
    );
  }

  console.log(
    "✓ Settlement recuperado por paymentId",
  );

  const recoveredByExternal =
    await settlementRepository.findByExternalId(
      externalId,
    );

  if (!recoveredByExternal) {
    throw new Error(
      "Settlement should be recoverable by externalId.",
    );
  }

  if (recoveredByExternal.id !== settlementId) {
    throw new Error(
      "externalId lookup returned the wrong settlement.",
    );
  }

  console.log(
    "✓ Settlement recuperado por externalId",
  );

  recoveredByPayment.startProcessing();

  const processing =
    await settlementRepository.save(
      recoveredByPayment,
    );

  if (processing.status !== "PROCESSING") {
    throw new Error(
      "Settlement should be PROCESSING.",
    );
  }

  console.log("✓ Settlement PENDING → PROCESSING");
  console.log("✓ PROCESSING persistido no PostgreSQL");

  const settledAt = new Date(
    "2026-10-03T11:30:00.000Z",
  );

  processing.markAsSettled(settledAt);

  const settled =
    await settlementRepository.save(
      processing,
    );

  if (settled.status !== "SETTLED") {
    throw new Error(
      "Settlement should be SETTLED.",
    );
  }

  if (
    settled.settledAt?.getTime() !==
    settledAt.getTime()
  ) {
    throw new Error(
      "settledAt was not persisted correctly.",
    );
  }

  console.log("✓ Settlement PROCESSING → SETTLED");
  console.log("✓ SETTLED persistido no PostgreSQL");
  console.log("✓ settledAt persistido");

  const final =
    await settlementRepository.findById(
      settlementId,
    );

  if (!final) {
    throw new Error(
      "Final settlement should exist.",
    );
  }

  if (final.status !== "SETTLED") {
    throw new Error(
      "Final persisted status should be SETTLED.",
    );
  }

  console.log(
    "✓ Estado SETTLED confirmado no PostgreSQL",
  );

  let duplicateRejected = false;

  try {
    await createSettlement.execute({
      id: "integration-settlement-duplicate-001",
      paymentId,
      amountBRLMinor: 4990n,
      externalId: "integration-settlement-duplicate",
    });
  } catch {
    duplicateRejected = true;
  }

  if (!duplicateRejected) {
    throw new Error(
      "A second settlement for the same payment must be rejected.",
    );
  }

  console.log(
    "✓ Settlement duplicado por paymentId rejeitado",
  );

  let invalidAmountRejected = false;

  try {
    await createSettlement.execute({
      id: "integration-settlement-invalid-amount-001",
      paymentId,
      amountBRLMinor: 5000n,
      externalId: "integration-settlement-invalid-amount",
    });
  } catch {
    invalidAmountRejected = true;
  }

  if (!invalidAmountRejected) {
    throw new Error(
      "Settlement with a different amount must be rejected.",
    );
  }

  console.log("✓ Valor divergente rejeitado");

  await cleanup();

  console.log("✓ Dados de integração removidos");

  console.log();
  console.log(
    "✓ SETTLEMENT POSTGRES TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ SETTLEMENT POSTGRES TEST FALHOU",
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
