import type { PaymentRepository } from "../ports/payment-repository.js";

export class GetPayment {
  constructor(
    private readonly repository: PaymentRepository
  ) {}

  async execute(paymentId: string) {
    return this.repository.findById(paymentId);
  }
}
