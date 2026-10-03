import { PaymentEvent } from "@/domain/entities/payment-event.js";

function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(message);
  }
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — PAYMENT EVENT UNIT TEST");
  console.log("==============================================");

  const occurredAt = new Date("2026-10-03T10:00:00.000Z");

  const event = PaymentEvent.create({
    id: "unit-event-001",
    paymentId: "unit-payment-001",
    type: "PIX_CREATED",
    externalId: "provider-event-001",
    payload: {
      provider: "unit-provider",
      amount: 4990,
      source: "unit-test",
    },
    occurredAt,
  });

  assert(
    event.id === "unit-event-001",
    "Event id should be preserved.",
  );

  assert(
    event.paymentId === "unit-payment-001",
    "Payment id should be preserved.",
  );

  assert(
    event.type === "PIX_CREATED",
    "Event type should be PIX_CREATED.",
  );

  assert(
    event.externalId === "provider-event-001",
    "External id should be preserved.",
  );

  assert(
    event.payload?.provider === "unit-provider",
    "Payload should be preserved.",
  );

  assert(
    event.payload?.amount === 4990,
    "Payload amount should be preserved.",
  );

  assert(
    event.occurredAt.getTime() === occurredAt.getTime(),
    "occurredAt should be preserved.",
  );

  console.log("✓ Event creation");
  console.log("✓ Payment binding");
  console.log("✓ Valid event type");
  console.log("✓ externalId");
  console.log("✓ JSON payload");
  console.log("✓ occurredAt");

  let failed = false;

  try {
    PaymentEvent.create({
      id: "",
      paymentId: "unit-payment-001",
      type: "PIX_CREATED",
    });
  } catch {
    failed = true;
  }

  assert(
    failed,
    "Empty event id should be rejected.",
  );

  failed = false;

  try {
    PaymentEvent.create({
      id: "unit-event-invalid-payment",
      paymentId: "",
      type: "PIX_CREATED",
    });
  } catch {
    failed = true;
  }

  assert(
    failed,
    "Empty payment id should be rejected.",
  );

  failed = false;

  try {
    PaymentEvent.create({
      id: "unit-event-invalid-date",
      paymentId: "unit-payment-001",
      type: "PIX_CREATED",
      occurredAt: new Date("invalid"),
    });
  } catch {
    failed = true;
  }

  assert(
    failed,
    "Invalid occurredAt should be rejected.",
  );

  console.log("✓ Invalid event rejected");
  console.log("✓ Invalid payment binding rejected");
  console.log("✓ Invalid occurredAt rejected");

  console.log();
  console.log("✓ PAYMENT EVENT UNIT TEST CONCLUÍDO COM SUCESSO");
}

main().catch((error) => {
  console.error();
  console.error("✗ PAYMENT EVENT UNIT TEST FALHOU");
  console.error(error);
  process.exitCode = 1;
});
