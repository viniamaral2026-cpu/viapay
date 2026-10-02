import type { Payment } from "@viapay/domain";

export interface PaymentRepository {
  save(payment: Payment): Promise<void>;
  findById(id: string): Promise<Payment | null>;
}
