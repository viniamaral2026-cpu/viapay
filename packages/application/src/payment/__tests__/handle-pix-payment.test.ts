import { describe, expect, it } from "vitest";
import { HandlePixPayment } from "../use-cases/handle-pix-payment.js";
import { Payment } from "@viapay/domain";
import type { PaymentRepository } from "../ports/payment-repository.js";

class TestPaymentRepository implements PaymentRepository {
  readonly payments = new Map<string, Payment>();
  saveCalls = 0;

  async save(payment: Payment): Promise<void> {
    this.saveCalls++;
    this.payments.set(payment.id, payment);
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }
}

function createPendingPayment(): Payment {
  const payment = Payment.create({
    id: "payment_123",
    amountBRLMinor: 4990n,
    merchantWallet: "merchant_wallet_123"
  });

  payment.transitionTo("PIX_PENDING");

  return payment;
}

describe("HandlePixPayment", () => {
  it("deve rejeitar pagamento inexistente", async () => {
    const repository = new TestPaymentRepository();

    const useCase = new HandlePixPayment(repository);

    await expect(
      useCase.execute({
        paymentId: "payment_not_found"
      })
    ).rejects.toThrow("Payment not found");

    expect(repository.saveCalls).toBe(0);
  });

  it("deve mover PIX_PENDING para SETTLEMENT_PENDING", async () => {
    const repository = new TestPaymentRepository();
    const payment = createPendingPayment();

    await repository.save(payment);
    repository.saveCalls = 0;

    const useCase = new HandlePixPayment(repository);

    await useCase.execute({
      paymentId: "payment_123"
    });

    expect(payment.status).toBe("SETTLEMENT_PENDING");
    expect(repository.saveCalls).toBe(1);
  });

  it("não deve alterar pagamento que não está em PIX_PENDING", async () => {
    const repository = new TestPaymentRepository();

    const payment = Payment.create({
      id: "payment_123",
      amountBRLMinor: 4990n,
      merchantWallet: "merchant_wallet_123"
    });

    payment.transitionTo("FAILED");

    await repository.save(payment);
    repository.saveCalls = 0;

    const useCase = new HandlePixPayment(repository);

    await useCase.execute({
      paymentId: "payment_123"
    });

    expect(payment.status).toBe("FAILED");
    expect(repository.saveCalls).toBe(0);
  });

  it("deve ser idempotente quando o pagamento já saiu de PIX_PENDING", async () => {
    const repository = new TestPaymentRepository();
    const payment = createPendingPayment();

    await repository.save(payment);
    repository.saveCalls = 0;

    const useCase = new HandlePixPayment(repository);

    await useCase.execute({
      paymentId: "payment_123"
    });

    expect(payment.status).toBe("SETTLEMENT_PENDING");

    repository.saveCalls = 0;

    await useCase.execute({
      paymentId: "payment_123"
    });

    expect(payment.status).toBe("SETTLEMENT_PENDING");
    expect(repository.saveCalls).toBe(0);
  });
});
