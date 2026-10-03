import { MoneyBRL } from "../../src/domain/value-objects/money-brl.js";
import "dotenv/config";

import { Merchant } from "../../src/domain/entities/merchant.js";
import { Payment } from "../../src/domain/entities/payment.js";
import { PrismaMerchantRepository } from "../../src/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "../../src/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaPixChargeRepository } from "../../src/infrastructure/repositories/prisma-pix-charge-repository.js";
import { CreatePixCharge } from "../../src/application/use-cases/pix/create-pix-charge.js";
import { db } from "../../src/prisma/db.js";

const merchantId = "integration-pix-merchant-001";
const paymentId = "integration-pix-payment-001";
const pixChargeId = "integration-pix-charge-001";

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
  console.log(
    "==============================================",
  );
  console.log(
    "VIAPAY — PIX CHARGE POSTGRES INTEGRATION TEST",
  );
  console.log(
    "==============================================",
  );

  await cleanup();

  const merchantRepository = new PrismaMerchantRepository();
  const paymentRepository = new PrismaPaymentRepository();
  const pixChargeRepository =
    new PrismaPixChargeRepository();

  const merchant = Merchant.create({
    id: merchantId,
    name: "ViaPay PIX Integration",
    document: "00000000000999",
    wallet: "integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: "integration-wallet",
  });

  await paymentRepository.create(payment);

  console.log("✓ Payment criado no PostgreSQL");
  console.log("  Valor:", payment.amount.amountInCents.toString());

  const createPixCharge = new CreatePixCharge(
    paymentRepository,
    pixChargeRepository,
  );

  const pixCharge = await createPixCharge.execute({
    id: pixChargeId,
    paymentId,
    provider: "integration-provider",
    providerId: "integration-provider-001",
    qrCode: "000201010212INTEGRATION",
    amountBRLMinor: 4990n,
    expiresAt: new Date(
      Date.now() + 15 * 60 * 1000,
    ),
  });

  console.log("✓ PixCharge criada no PostgreSQL");
  console.log("  ID:", pixCharge.id);
  console.log("  Status:", pixCharge.status);
  console.log(
    "  Valor:",
    pixCharge.amountBRLMinor.toString(),
  );

  if (pixCharge.status !== "CREATED") {
    throw new Error("PIX charge should start as CREATED.");
  }

  const persisted =
    await pixChargeRepository.findByPaymentId(
      paymentId,
    );

  if (!persisted) {
    throw new Error(
      "PIX charge was not found by paymentId.",
    );
  }

  console.log(
    "✓ PixCharge recuperada pelo paymentId",
  );

  if (persisted.amountBRLMinor !== 4990n) {
    throw new Error(
      "Persisted PIX amount does not match payment.",
    );
  }

  persisted.activate();

  const active =
    await pixChargeRepository.save(persisted);

  console.log("✓ PixCharge ativada");
  console.log("  Status:", active.status);

  active.markAsPaid();

  const paid =
    await pixChargeRepository.save(active);

  console.log("✓ PixCharge marcada como paga");
  console.log("  Status:", paid.status);

  const confirmed =
    await pixChargeRepository.findById(
      pixChargeId,
    );

  if (!confirmed) {
    throw new Error(
      "PIX charge disappeared from PostgreSQL.",
    );
  }

  if (confirmed.status !== "PAID") {
    throw new Error(
      `Expected PAID, received ${confirmed.status}.`,
    );
  }

  if (confirmed.paidAt === null) {
    throw new Error(
      "paidAt was not persisted.",
    );
  }

  console.log(
    "✓ Estado PAID confirmado no PostgreSQL",
  );

  await cleanup();

  console.log("✓ Dados de integração removidos");
  console.log();
  console.log(
    "✓ PIX CHARGE POSTGRES TEST CONCLUÍDO COM SUCESSO",
  );
}

main()
  .catch((error) => {
    console.error();
    console.error(
      "✗ PIX CHARGE POSTGRES TEST FALHOU",
    );
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await db.$disconnect();
  });
