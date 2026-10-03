import type { PaymentEventType } from "../../domain/entities/payment-event.js";

export interface CreatePaymentEventInput {
  id: string;
  paymentId: string;
  type: PaymentEventType;
  externalId?: string | null;
  payload?: Record<string, unknown> | null;
  occurredAt?: Date;
}
