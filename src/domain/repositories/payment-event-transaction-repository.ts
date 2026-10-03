import type { PaymentEvent } from "../entities/payment-event.js";

export interface PaymentEventTransactionRepository {
  create(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent>;

  append(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent>;

  findByExternalId(
    transaction: unknown,
    externalId: string,
  ): Promise<PaymentEvent | null>;

  countByPaymentId(
    transaction: unknown,
    paymentId: string,
  ): Promise<number>;
}
