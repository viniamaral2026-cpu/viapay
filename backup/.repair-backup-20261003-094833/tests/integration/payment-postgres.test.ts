import "dotenv/config";

import { CreatePayment } from "../../src/application/use-cases/payment/create-payment.js";
import { Merchant } from "../../src/domain/entities/merchant.js";
import { PrismaMerchantRepository } from "../../src/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "../../src/infrastructure/repositories/prisma-payment-repository.js";
import { db } from "../../src/prisma/db.js";

const merchantId = "integration-merchant-001";
const paymentId = "integration-payment-001";

async function cleanup(): Promise<void> {
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
  console.log("VIAPAY — PAYMENT POSTGRES INTEGRATION TEST");
  console.log("==============================================");

  await cleanup();

  const merchantRepository = new PrismaMerchantRepository();

  await merchantRepository.create(
    Merchant.create({
      id: merchantId,
      name: "ViaPay Integration Test",
      document: "00000000000200",
      wallet: "integration-wallet",
    }),
  );

  console.log("✓ Merchant criado no PostgreSQL");

  const paymentRepository = new PrismaPaymentRepository();

  const createPayment = new CreatePayment(paymentRepository);

  const created = await createPayment.execute({
    id: paymentId,
    merchantId,
    amountBRLMinor: 4990n,
    merchantWallet: "integration-wallet",
  });

  console.log("✓ Payment criado no PostgreSQL");
  console.log("  ID:", created.id);
  console.log("  Valor:", created.amount.amountInCents.toString());
  console.log("  Status:", created.status);

  if (created.status !== "CREATED") {
    throw new Error("Payment should be CREATED.");
  }

  if (created.amount.amountInCents !== 4990n) {
    throw new Error("Payment amount should be 4990 cents.");
  }

  const found = await paymentRepository.findById(paymentId);

  if (!found) {
    throw new Error("Payment was not found after creation.");
  }

  console.log("✓ Payment recuperado do PostgreSQL");
  console.log("  Status:", found.status);
  console.log("  Valor:", found.amount.amountInCents.toString());

  found.markPixPending();

  const saved = await paymentRepository.save(found);

  console.log("✓ Payment atualizado");
  console.log("  Novo status:", saved.status);

  if (saved.status !== "PIX_PENDING") {
    throw new Error("Payment should be PIX_PENDING.");
  }

  const persisted = await paymentRepository.findById(paymentId);

  if (!persisted) {
    throw new Error("Persisted payment was not found.");
  }

  if (persisted.status !== "PIX_PENDING") {
    throw new Error(
      "PostgreSQL did not persist PIX_PENDING status.",
    );
  }

  console.log("✓ Estado confirmado no PostgreSQL");

  await cleanup();

  console.log("✓ Dados de integração removidos");
  console.log();
  console.log("✓ PAYMENT POSTGRES TEST CONCLUÍDO COM SUCESSO");
}

main()
  .catch(async (error) => {
    console.error();
    console.error("✗ PAYMENT POSTGRES TEST FALHOU");
    console.error(error);

    try {
      await cleanup();
    } catch {
      // Preserve original test error.
    }

    process.exitCode = 1;
  })
  .finally(async () => {
    await db.$disconnect();
  });
