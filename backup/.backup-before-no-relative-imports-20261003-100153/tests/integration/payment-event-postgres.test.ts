import "dotenv/config";

import { Merchant } from "../../src/domain/entities/merchant.js";
import { Payment } from "../../src/domain/entities/payment.js";
import { MoneyBRL } from "../../src/domain/value-objects/money-brl.js";
import { PrismaMerchantRepository } from "../../src/infrastructure/repositories/prisma-merchant-repository.js";
import { PrismaPaymentRepository } from "../../src/infrastructure/repositories/prisma-payment-repository.js";
import { PrismaPaymentEventRepository } from "../../src/infrastructure/repositories/prisma-payment-event-repository.js";
import { CreatePaymentEvent } from "../../src/application/use-cases/payment/create-payment-event.js";
import { db } from "../../src/prisma/db.js";

const merchantId = "integration-event-merchant-001";
const paymentId = "integration-event-payment-001";

const eventCreatedId = "integration-event-created-001";
const eventPixCreatedId = "integration-event-pix-created-001";
const eventPixPaidId = "integration-event-pix-paid-001";

async function cleanup(): Promise<void> {
  await db.paymentEvent.deleteMany({
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
  console.log("VIAPAY — PAYMENT EVENT POSTGRES INTEGRATION TEST");
  console.log("==============================================");

  await cleanup();

  const merchantRepository =
    new PrismaMerchantRepository();

  const paymentRepository =
    new PrismaPaymentRepository();

  const paymentEventRepository =
    new PrismaPaymentEventRepository();

  const merchant = Merchant.create({
    id: merchantId,
    name: "ViaPay Event Integration",
    document: "00000000000888",
    wallet: "event-integration-wallet",
  });

  await merchantRepository.create(merchant);

  console.log("✓ Merchant criado no PostgreSQL");

  const payment = Payment.create({
    id: paymentId,
    merchantId,
    amount: MoneyBRL.fromCents(4990n),
    merchantWallet: "event-integration-wallet",
  });

  await paymentRepository.create(payment);

  console.log("✓ Payment criado no PostgreSQL");

  const createPaymentEvent = new CreatePaymentEvent(
    paymentRepository,
    paymentEventRepository,
  );

  const eventCreated = await createPaymentEvent.execute({
    id: eventCreatedId,
    paymentId,
    type: "CREATED",
    externalId: "provider-event-created-001",
    payload: {
      source: "integration-test",
      sequence: 1,
    },
    occurredAt: new Date(
      "2026-10-03T10:00:00.000Z",
    ),
  });

  console.log("✓ PaymentEvent CREATED criado");
  console.log("  ID:", eventCreated.id);
  console.log("  Tipo:", eventCreated.type);

  if (eventCreated.paymentId !== paymentId) {
    throw new Error(
      "PaymentEvent must reference the correct payment.",
    );
  }

  if (
    eventCreated.externalId !==
    "provider-event-created-001"
  ) {
    throw new Error(
      "externalId was not persisted correctly.",
    );
  }

  if (
    eventCreated.payload?.source !==
    "integration-test"
  ) {
    throw new Error(
      "JSON payload was not persisted correctly.",
    );
  }

  console.log("✓ Vínculo com Payment confirmado");
  console.log("✓ externalId confirmado");
  console.log("✓ Payload JSON confirmado");

  const eventPixCreated =
    await createPaymentEvent.execute({
      id: eventPixCreatedId,
      paymentId,
      type: "PIX_CREATED",
      externalId: "provider-event-pix-created-001",
      payload: {
        provider: "integration-provider",
        amount: 4990,
        sequence: 2,
      },
      occurredAt: new Date(
        "2026-10-03T10:05:00.000Z",
      ),
    });

  console.log("✓ PaymentEvent PIX_CREATED criado");

  const eventPixPaid =
    await createPaymentEvent.execute({
      id: eventPixPaidId,
      paymentId,
      type: "PIX_PAID",
      externalId: "provider-event-pix-paid-001",
      payload: {
        provider: "integration-provider",
        amount: 4990,
        sequence: 3,
      },
      occurredAt: new Date(
        "2026-10-03T10:10:00.000Z",
      ),
    });

  console.log("✓ PaymentEvent PIX_PAID criado");

  if (
    eventPixCreated.occurredAt.getTime() >=
    eventPixPaid.occurredAt.getTime()
  ) {
    throw new Error(
      "PIX_CREATED must occur before PIX_PAID.",
    );
  }

  console.log("✓ occurredAt confirmado");

  const recovered =
    await paymentEventRepository.findById(
      eventPixPaidId,
    );

  if (!recovered) {
    throw new Error(
      "PaymentEvent should be recoverable by id.",
    );
  }

  if (recovered.type !== "PIX_PAID") {
    throw new Error(
      "Recovered event type is incorrect.",
    );
  }

  console.log("✓ PaymentEvent recuperado por ID");

  const events =
    await paymentEventRepository.findByPaymentId(
      paymentId,
    );

  if (events.length !== 3) {
    throw new Error(
      `Expected 3 events, received ${events.length}.`,
    );
  }

  if (events[0].type !== "CREATED") {
    throw new Error(
      "First event should be CREATED.",
    );
  }

  if (events[1].type !== "PIX_CREATED") {
    throw new Error(
      "Second event should be PIX_CREATED.",
    );
  }

  if (events[2].type !== "PIX_PAID") {
    throw new Error(
      "Third event should be PIX_PAID.",
    );
  }

  console.log(
    "✓ Eventos recuperados por paymentId",
  );

  console.log(
    "✓ Ordenação cronológica confirmada",
  );

  const byExternalId =
    await paymentEventRepository.findByExternalId(
      "provider-event-pix-paid-001",
    );

  if (!byExternalId) {
    throw new Error(
      "Event should be recoverable by externalId.",
    );
  }

  if (byExternalId.id !== eventPixPaidId) {
    throw new Error(
      "externalId lookup returned the wrong event.",
    );
  }

  console.log("✓ Recuperação por externalId confirmada");

  let duplicateRejected = false;

  try {
    await createPaymentEvent.execute({
      id: "integration-event-duplicate-001",
      paymentId,
      type: "PIX_PAID",
      externalId: "provider-event-pix-paid-001",
      payload: {
        duplicate: true,
      },
      occurredAt: new Date(
        "2026-10-03T10:11:00.000Z",
      ),
    });
  } catch {
    duplicateRejected = true;
  }

  if (!duplicateRejected) {
    throw new Error(
      "Duplicate externalId should be rejected.",
    );
  }

  console.log("✓ externalId duplicado rejeitado");

  let invalidPaymentRejected = false;

  try {
    await createPaymentEvent.execute({
      id: "integration-event-invalid-payment-001",
      paymentId: "payment-that-does-not-exist",
      type: "PIX_CREATED",
      externalId: "invalid-payment-event-001",
      payload: {
        invalid: true,
      },
    });
  } catch {
    invalidPaymentRejected = true;
  }

  if (!invalidPaymentRejected) {
    throw new Error(
      "Event for nonexistent payment should be rejected.",
    );
  }

  console.log(
    "✓ Evento sem Payment existente rejeitado",
  );

  await cleanup();

  console.log("✓ Dados de integração removidos");

  console.log();
  console.log(
    "✓ PAYMENT EVENT POSTGRES TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch(async (error) => {
  console.error();
  console.error(
    "✗ PAYMENT EVENT POSTGRES TEST FALHOU",
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
