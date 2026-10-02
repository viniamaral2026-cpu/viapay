import { describe, expect, it } from "vitest";
import { CreatePayment } from "../use-cases/create-payment.js";
import type {
  CreatePixChargeInput,
  PixCharge,
  PixProvider
} from "../ports/pix-provider.js";
import type { PaymentRepository } from "../ports/payment-repository.js";
import type { Payment } from "@viapay/domain";

class TestPaymentRepository implements PaymentRepository {
  readonly payments = new Map<string, Payment>();

  async save(payment: Payment): Promise<void> {
    this.payments.set(payment.id, payment);
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }
}

class TestPixProvider implements PixProvider {
  lastInput: CreatePixChargeInput | null = null;

  async createCharge(input: CreatePixChargeInput): Promise<PixCharge> {
    this.lastInput = input;

    return {
      id: `pix_${input.paymentId}`,
      qrCode: `PIX-${input.paymentId}`,
      qrCodeImage: "data:image/png;base64,test",
      expiresAt: new Date("2026-10-02T21:00:00.000Z")
    };
  }
}

describe("CreatePayment", () => {
  it("deve criar pagamento e gerar cobrança PIX", async () => {
    const repository = new TestPaymentRepository();
    const pixProvider = new TestPixProvider();

    const useCase = new CreatePayment(
      repository,
      pixProvider
    );

    const result = await useCase.execute({
      paymentId: "payment_123",
      amountBRLMinor: 4990n,
      merchantWallet: "merchant_wallet_123"
    });

    expect(result).toEqual({
      paymentId: "payment_123",
      status: "PIX_PENDING",
      pixChargeId: "pix_payment_123",
      qrCode: "PIX-payment_123",
      qrCodeImage: "data:image/png;base64,test",
      expiresAt: new Date("2026-10-02T21:00:00.000Z")
    });

    const payment = await repository.findById("payment_123");

    expect(payment).not.toBeNull();
    expect(payment?.status).toBe("PIX_PENDING");
    expect(payment?.amountBRLMinor).toBe(4990n);
    expect(payment?.merchantWallet).toBe(
      "merchant_wallet_123"
    );

    expect(pixProvider.lastInput).toEqual({
      paymentId: "payment_123",
      amountBRLMinor: 4990n
    });
  });

  it("deve rejeitar pagamento com valor inválido", async () => {
    const repository = new TestPaymentRepository();
    const pixProvider = new TestPixProvider();

    const useCase = new CreatePayment(
      repository,
      pixProvider
    );

    await expect(
      useCase.execute({
        paymentId: "payment_invalid",
        amountBRLMinor: 0n,
        merchantWallet: "merchant_wallet_123"
      })
    ).rejects.toThrow(
      "Payment amount must be greater than zero"
    );

    expect(repository.payments.size).toBe(0);
    expect(pixProvider.lastInput).toBeNull();
  });
});
