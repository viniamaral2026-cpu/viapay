import { describe, expect, it } from "vitest";
import { GetPayment } from "../use-cases/get-payment.js";
import { Payment } from "@viapay/domain";
import type { PaymentRepository } from "../ports/payment-repository.js";

class TestPaymentRepository implements PaymentRepository {
  readonly payments = new Map<string, Payment>();

  async save(payment: Payment): Promise<void> {
    this.payments.set(payment.id, payment);
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }
}

describe("GetPayment", () => {
  it("deve retornar pagamento existente", async () => {
    const repository = new TestPaymentRepository();

    const payment = Payment.create({
      id: "payment_123",
      amountBRLMinor: 4990n,
      merchantWallet: "merchant_wallet_123"
    });

    await repository.save(payment);

    const useCase = new GetPayment(repository);

    const result = await useCase.execute("payment_123");

    expect(result).toBe(payment);
  });

  it("deve retornar null quando pagamento não existe", async () => {
    const repository = new TestPaymentRepository();

    const useCase = new GetPayment(repository);

    const result = await useCase.execute(
      "payment_not_found"
    );

    expect(result).toBeNull();
  });
});
