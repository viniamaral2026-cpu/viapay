import type { Payment } from "@/domain/entities/payment.js";

export interface PaymentRepository {
  create(payment: Payment): Promise<Payment>;

  findById(id: string): Promise<Payment | null>;

  save(payment: Payment): Promise<Payment>;
}
