import { describe, expect, it } from "vitest";
import { Payment } from "../payment.js";

describe("Payment", () => {
  const validInput = {
    id: "payment_123",
    amountBRLMinor: 4990n,
    merchantWallet: "merchant_wallet_123"
  };

  it("deve criar um pagamento no estado CREATED", () => {
    const payment = Payment.create(validInput);

    expect(payment.id).toBe("payment_123");
    expect(payment.amountBRLMinor).toBe(4990n);
    expect(payment.merchantWallet).toBe("merchant_wallet_123");
    expect(payment.status).toBe("CREATED");
    expect(payment.createdAt).toBeInstanceOf(Date);
    expect(payment.updatedAt).toBeInstanceOf(Date);
  });

  it("deve rejeitar valor igual a zero", () => {
    expect(() =>
      Payment.create({
        ...validInput,
        amountBRLMinor: 0n
      })
    ).toThrow("Payment amount must be greater than zero");
  });

  it("deve rejeitar valor negativo", () => {
    expect(() =>
      Payment.create({
        ...validInput,
        amountBRLMinor: -1n
      })
    ).toThrow("Payment amount must be greater than zero");
  });

  it("deve rejeitar merchant wallet vazia", () => {
    expect(() =>
      Payment.create({
        ...validInput,
        merchantWallet: ""
      })
    ).toThrow("Merchant wallet is required");
  });

  it("deve rejeitar merchant wallet contendo apenas espaços", () => {
    expect(() =>
      Payment.create({
        ...validInput,
        merchantWallet: "   "
      })
    ).toThrow("Merchant wallet is required");
  });

  it("deve permitir CREATED → PIX_PENDING", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");

    expect(payment.status).toBe("PIX_PENDING");
  });

  it("deve permitir PIX_PENDING → PIX_PAID", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");
    payment.transitionTo("PIX_PAID");

    expect(payment.status).toBe("PIX_PAID");
  });

  it("deve permitir PIX_PAID → SETTLEMENT_PENDING", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");
    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");

    expect(payment.status).toBe("SETTLEMENT_PENDING");
  });

  it("deve permitir SETTLEMENT_PENDING → SETTLING", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");
    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");
    payment.transitionTo("SETTLING");

    expect(payment.status).toBe("SETTLING");
  });

  it("deve permitir SETTLING → SETTLED", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");
    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");
    payment.transitionTo("SETTLING");
    payment.transitionTo("SETTLED");

    expect(payment.status).toBe("SETTLED");
  });

  it("deve rejeitar transição direta CREATED → SETTLED", () => {
    const payment = Payment.create(validInput);

    expect(() => payment.transitionTo("SETTLED")).toThrow(
      "Invalid payment transition: CREATED -> SETTLED"
    );
  });

  it("deve rejeitar transição SETTLED → PIX_PENDING", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("PIX_PENDING");
    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");
    payment.transitionTo("SETTLING");
    payment.transitionTo("SETTLED");

    expect(() => payment.transitionTo("PIX_PENDING")).toThrow(
      "Invalid payment transition: SETTLED -> PIX_PENDING"
    );
  });

  it("deve rejeitar transição FAILED → PIX_PAID", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("FAILED");

    expect(() => payment.transitionTo("PIX_PAID")).toThrow(
      "Invalid payment transition: FAILED -> PIX_PAID"
    );
  });

  it("deve rejeitar transição EXPIRED → PIX_PAID", () => {
    const payment = Payment.create(validInput);

    payment.transitionTo("EXPIRED");

    expect(() => payment.transitionTo("PIX_PAID")).toThrow(
      "Invalid payment transition: EXPIRED -> PIX_PAID"
    );
  });

  it("deve atualizar updatedAt durante uma transição", () => {
    const createdAt = new Date("2026-10-02T20:00:00.000Z");
    const transitionAt = new Date("2026-10-02T20:01:00.000Z");

    const payment = Payment.create({
      ...validInput,
      now: createdAt
    });

    expect(payment.createdAt).toEqual(createdAt);
    expect(payment.updatedAt).toEqual(createdAt);

    payment.transitionTo("PIX_PENDING", transitionAt);

    expect(payment.updatedAt).toEqual(transitionAt);
    expect(payment.createdAt).toEqual(createdAt);
  });
});
