import type { Payment } from "../entities/payment.js";

export interface PaymentRepository {
  create(payment: Payment): Promise<Payment>;

  findById(id: string): Promise<Payment | null>;

  save(payment: Payment): Promise<Payment>;
}
