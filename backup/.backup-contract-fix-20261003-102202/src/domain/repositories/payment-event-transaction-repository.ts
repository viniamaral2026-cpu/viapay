import type { PaymentEvent } from "../entities/payment-event.js";

export interface PaymentEventTransactionRepository {
  append(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent>;

  countByPaymentId(
    transaction: unknown,
    paymentId: string,
  ): Promise<number>;
}
