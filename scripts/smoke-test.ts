import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "@prisma/client";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("DATABASE_URL não definida.");
}

const adapter = new PrismaPg({
  connectionString,
});

const prisma = new PrismaClient({
  adapter,
});

async function main() {
  console.log("==============================================");
  console.log("VIAPAY — SMOKE TEST");
  console.log("==============================================");

  await prisma.paymentEvent.deleteMany({
    where: {
      id: "smoke-event-001",
    },
  });

  await prisma.pixCharge.deleteMany({
    where: {
      id: "smoke-pix-001",
    },
  });

  await prisma.payment.deleteMany({
    where: {
      id: "smoke-payment-001",
    },
  });

  await prisma.merchant.deleteMany({
    where: {
      id: "smoke-merchant-001",
    },
  });

  const merchant = await prisma.merchant.create({
    data: {
      id: "smoke-merchant-001",
      name: "ViaPay Smoke Test",
      document: "00000000000100",
      wallet: "smoke-wallet",
      active: true,
    },
  });

  console.log("✓ Merchant criado:", merchant.id);

  const payment = await prisma.payment.create({
    data: {
      id: "smoke-payment-001",
      merchantId: merchant.id,
      amountBRLMinor: 1990n,
      merchantWallet: "smoke-wallet",
      status: "PIX_PENDING",
    },
  });

  console.log("✓ Payment criado:", payment.id);
  console.log(
    "  Valor:",
    payment.amountBRLMinor.toString(),
    "centavos"
  );

  const pixCharge = await prisma.pixCharge.create({
    data: {
      id: "smoke-pix-001",
      paymentId: payment.id,
      provider: "smoke-provider",
      providerId: "smoke-provider-001",
      qrCode: "000201010212SMOKE",
      amountBRLMinor: 1990n,
      status: "ACTIVE",
      expiresAt: new Date(Date.now() + 15 * 60 * 1000),
    },
  });

  console.log("✓ PixCharge criada:", pixCharge.id);

  const event = await prisma.paymentEvent.create({
    data: {
      id: "smoke-event-001",
      paymentId: payment.id,
      type: "PIX_CREATED",
      externalId: "smoke-provider-001",
      payload: {
        source: "smoke-test",
        provider: "smoke-provider",
      },
      occurredAt: new Date(),
    },
  });

  console.log("✓ PaymentEvent criado:", event.id);

  const result = await prisma.payment.findUnique({
    where: {
      id: payment.id,
    },
    include: {
      merchant: true,
      pixCharge: true,
      events: true,
    },
  });

  console.log();
  console.log("=== RESULTADO ===");

  console.log(
    JSON.stringify(
      result,
      (_, value) =>
        typeof value === "bigint" ? value.toString() : value,
      2
    )
  );

  console.log();
  console.log("✓ SMOKE TEST CONCLUÍDO COM SUCESSO");
}

main()
  .catch((error) => {
    console.error();
    console.error("✗ SMOKE TEST FALHOU");
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
