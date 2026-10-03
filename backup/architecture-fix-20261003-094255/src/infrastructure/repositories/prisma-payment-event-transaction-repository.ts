import type { PrismaTransactionClient } from "../database/prisma-transaction-client.js";

import {
  PaymentEvent,
  type PaymentEventType,
} from "../../domain/entities/payment-event.js";

import type { PaymentEventTransactionRepository } from "../../domain/repositories/payment-event-transaction-repository.js";

function toDomain(record: {
  id: string;
  paymentId: string;
  type: string;
  externalId: string | null;
  payload: unknown;
  occurredAt: Date;
  createdAt: Date;
}): PaymentEvent {
  return PaymentEvent.create({
    id: record.id,
    paymentId: record.paymentId,
    type: record.type as PaymentEventType,
    externalId: record.externalId,
    payload:
      record.payload as Record<string, unknown> | null,
    occurredAt: record.occurredAt,
    createdAt: record.createdAt,
  });
}

export class PrismaPaymentEventTransactionRepository
  implements PaymentEventTransactionRepository
{
  async create(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent> {
    const tx =
      transaction as PrismaTransactionClient;

    const record =
      await tx.paymentEvent.create({
        data: {
          id: event.id,
          paymentId: event.paymentId,
          type: event.type,
          externalId: event.externalId,
          payload:
            event.payload === null
              ? undefined
              : event.payload,
          occurredAt: event.occurredAt,
          createdAt: event.createdAt,
        },
      });

    return toDomain(record);
  }

  async countByPaymentId(
    transaction: unknown,
    paymentId: string,
  ): Promise<number> {
    const tx =
      transaction as PrismaTransactionClient;

    return tx.paymentEvent.count({
      where: {
        paymentId,
      },
    });
  }
}
