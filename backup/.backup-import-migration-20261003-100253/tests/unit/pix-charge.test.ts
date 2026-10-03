import { PixCharge } from "@/domain/entities/pix-charge.js";

function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(`Assertion failed: ${message}`);
  }
}

function expectThrow(fn: () => void, message: string): void {
  try {
    fn();
  } catch {
    return;
  }

  throw new Error(`Expected error: ${message}`);
}

console.log("==============================================");
console.log("VIAPAY — PIX CHARGE UNIT TEST");
console.log("==============================================");

const future = new Date(Date.now() + 15 * 60 * 1000);

const charge = PixCharge.create({
  id: "unit-pix-001",
  paymentId: "unit-payment-001",
  provider: "unit-provider",
  providerId: "unit-provider-001",
  qrCode: "000201010212UNIT",
  amountBRLMinor: 4990n,
  expiresAt: future,
});

assert(charge.status === "CREATED", "initial status");

charge.activate();

assert(
  charge.status === "ACTIVE",
  "charge should become ACTIVE",
);

charge.markAsPaid();

assert(
  charge.status === "PAID",
  "charge should become PAID",
);

assert(
  charge.paidAt !== null,
  "paidAt should be populated",
);

expectThrow(
  () => charge.activate(),
  "cannot activate paid charge",
);

expectThrow(
  () => charge.expire(),
  "cannot expire paid charge",
);

expectThrow(
  () =>
    PixCharge.create({
      id: "unit-invalid-001",
      paymentId: "unit-payment-001",
      provider: "unit-provider",
      qrCode: "UNIT",
      amountBRLMinor: 0n,
      expiresAt: future,
    }),
  "zero amount must be rejected",
);

expectThrow(
  () =>
    PixCharge.create({
      id: "unit-invalid-002",
      paymentId: "unit-payment-001",
      provider: "unit-provider",
      qrCode: "UNIT",
      amountBRLMinor: 4990n,
      expiresAt: new Date(Date.now() - 1000),
    }),
  "expired charge must be rejected",
);

console.log("✓ PIX charge lifecycle");
console.log("✓ Invalid transitions rejected");
console.log("✓ Invalid amount rejected");
console.log("✓ Expired creation rejected");
console.log();
console.log("✓ PIX CHARGE UNIT TEST CONCLUÍDO COM SUCESSO");
