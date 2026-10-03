import { DomainError } from "../../src/domain/errors/domain-error.js";
import { Payment } from "../../src/domain/entities/payment.js";
import { MoneyBRL } from "../../src/domain/value-objects/money-brl.js";

function assert(condition: boolean, message: string): void {
  if (!condition) {
    throw new Error(`ASSERTION FAILED: ${message}`);
  }
}

function assertThrows(fn: () => void, message: string): void {
  let thrown = false;

  try {
    fn();
  } catch (error) {
    thrown = error instanceof DomainError;
  }

  assert(thrown, message);
}

function testPaymentLifecycle(): void {
  const payment = Payment.create({
    id: "payment-unit-001",
    merchantId: "merchant-unit-001",
    amount: MoneyBRL.fromCents(1990n),
    merchantWallet: "wallet-unit",
  });

  assert(
    payment.status === "CREATED",
    "Payment should start as CREATED.",
  );

  assert(
    payment.amount.amountInCents === 1990n,
    "Payment amount should be 1990 cents.",
  );

  payment.markPixPending();

  assert(
    payment.status === "PIX_PENDING",
    "Payment should become PIX_PENDING.",
  );

  payment.markPixPaid();

  assert(
    payment.status === "PIX_PAID",
    "Payment should become PIX_PAID.",
  );

  payment.markSettlementPending();

  assert(
    payment.status === "SETTLEMENT_PENDING",
    "Payment should become SETTLEMENT_PENDING.",
  );

  payment.markSettling();

  assert(
    payment.status === "SETTLING",
    "Payment should become SETTLING.",
  );

  payment.markSettled();

  assert(
    payment.status === "SETTLED",
    "Payment should become SETTLED.",
  );
}

function testInvalidTransition(): void {
  const payment = Payment.create({
    id: "payment-unit-002",
    merchantId: "merchant-unit-001",
    amount: MoneyBRL.fromCents(1000n),
    merchantWallet: "wallet-unit",
  });

  assertThrows(
    () => payment.markPixPaid(),
    "PIX payment cannot be marked paid before PIX_PENDING.",
  );
}

function testNegativeMoney(): void {
  assertThrows(
    () => MoneyBRL.fromCents(-1n),
    "Negative money should be rejected.",
  );
}

function main(): void {
  console.log("==============================================");
  console.log("VIAPAY — PAYMENT UNIT TEST");
  console.log("==============================================");

  testPaymentLifecycle();
  console.log("✓ Payment lifecycle");

  testInvalidTransition();
  console.log("✓ Invalid transition rejected");

  testNegativeMoney();
  console.log("✓ Negative money rejected");

  console.log();
  console.log("✓ UNIT TESTS CONCLUÍDOS COM SUCESSO");
}

main();
