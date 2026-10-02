import type { Payment } from "@viapay/domain";
import type { PaymentRepository } from "@viapay/application";

export class InMemoryPaymentRepository implements PaymentRepository {
  private readonly payments = new Map<string, Payment>();

  async save(payment: Payment): Promise<void> {
    this.payments.set(payment.id, payment);
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }
}
