import { Settlement } from "../../src/domain/entities/settlement.js";

function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(message);
  }
}

async function main(): Promise<void> {
  console.log("==============================================");
  console.log("VIAPAY — SETTLEMENT UNIT TEST");
  console.log("==============================================");

  const settlement = Settlement.create({
    id: "unit-settlement-001",
    paymentId: "unit-payment-001",
    amountBRLMinor: 4990n,
    externalId: "settlement-external-001",
  });

  assert(
    settlement.id === "unit-settlement-001",
    "Settlement id should be preserved.",
  );

  assert(
    settlement.paymentId === "unit-payment-001",
    "Payment id should be preserved.",
  );

  assert(
    settlement.amountBRLMinor === 4990n,
    "Settlement amount should be preserved.",
  );

  assert(
    settlement.status === "PENDING",
    "Initial status should be PENDING.",
  );

  assert(
    settlement.externalId === "settlement-external-001",
    "externalId should be preserved.",
  );

  assert(
    settlement.settledAt === null,
    "settledAt should initially be null.",
  );

  console.log("✓ Settlement creation");
  console.log("✓ Payment binding");
  console.log("✓ Amount");
  console.log("✓ Initial PENDING status");
  console.log("✓ externalId");
  console.log("✓ Initial settledAt");

  settlement.startProcessing();

  assert(
    settlement.status === "PROCESSING",
    "Settlement should become PROCESSING.",
  );

  console.log("✓ PENDING → PROCESSING");

  const settledAt = new Date(
    "2026-10-03T11:00:00.000Z",
  );

  settlement.markAsSettled(settledAt);

  assert(
    settlement.status === "SETTLED",
    "Settlement should become SETTLED.",
  );

  assert(
    settlement.settledAt?.getTime() ===
      settledAt.getTime(),
    "settledAt should be preserved.",
  );

  console.log("✓ PROCESSING → SETTLED");
  console.log("✓ settledAt");

  let failed = false;

  try {
    settlement.fail();
  } catch {
    failed = true;
  }

  assert(
    failed,
    "SETTLED settlement should not be allowed to fail.",
  );

  console.log("✓ Invalid SETTLED → FAILED transition rejected");

  failed = false;

  try {
    settlement.cancel();
  } catch {
    failed = true;
  }

  assert(
    failed,
    "SETTLED settlement should not be allowed to cancel.",
  );

  console.log("✓ Invalid SETTLED → CANCELLED transition rejected");

  failed = false;

  try {
    Settlement.create({
      id: "unit-settlement-invalid-amount",
      paymentId: "unit-payment-001",
      amountBRLMinor: 0n,
    });
  } catch {
    failed = true;
  }

  assert(
    failed,
    "Zero settlement amount should be rejected.",
  );

  console.log("✓ Invalid amount rejected");

  failed = false;

  try {
    Settlement.create({
      id: "unit-settlement-invalid-payment",
      paymentId: "",
      amountBRLMinor: 4990n,
    });
  } catch {
    failed = true;
  }

  assert(
    failed,
    "Empty payment id should be rejected.",
  );

  console.log("✓ Invalid payment binding rejected");

  console.log();
  console.log(
    "✓ SETTLEMENT UNIT TEST CONCLUÍDO COM SUCESSO",
  );
}

main().catch((error) => {
  console.error();
  console.error("✗ SETTLEMENT UNIT TEST FALHOU");
  console.error(error);
  process.exitCode = 1;
});
