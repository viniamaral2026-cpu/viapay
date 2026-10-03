import type { PaymentEvent } from "@/domain/entities/payment-event.js";

export interface PaymentEventRepository {
  create(event: PaymentEvent): Promise<PaymentEvent>;

  findById(id: string): Promise<PaymentEvent | null>;

  findByPaymentId(paymentId: string): Promise<PaymentEvent[]>;

  findByExternalId(
    externalId: string,
  ): Promise<PaymentEvent | null>;
  countByPaymentId(
    paymentId: string,
  ): Promise<number>;

}
