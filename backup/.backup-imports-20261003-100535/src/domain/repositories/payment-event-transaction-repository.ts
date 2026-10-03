import type { PaymentEvent } from "@/domain/entities/payment-event.js";

export interface PaymentEventTransactionRepository {
  create(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent>;

  countByPaymentId(
    transaction: unknown,
    paymentId: string,
  ): Promise<number>;
}
