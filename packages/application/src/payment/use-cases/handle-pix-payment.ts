import type { PaymentRepository } from "../ports/payment-repository.js";

export interface HandlePixPaymentInput {
  paymentId: string;
}

export class HandlePixPayment {
  constructor(
    private readonly repository: PaymentRepository
  ) {}

  async execute(input: HandlePixPaymentInput): Promise<void> {
    const payment = await this.repository.findById(input.paymentId);

    if (!payment) {
      throw new Error("Payment not found");
    }

    if (payment.status !== "PIX_PENDING") {
      return;
    }

    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");

    await this.repository.save(payment);
  }
}
