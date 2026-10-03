import type { PrismaTransactionClient } from "@/infrastructure/database/prisma-transaction-client.js";

import {
  PaymentEvent,
  type PaymentEventType,
} from "@/domain/entities/payment-event.js";

import type { PaymentEventTransactionRepository } from "@/domain/repositories/payment-event-transaction-repository.js";

import type { Prisma } from "@prisma/client";

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
    payload: record.payload as Record<string, unknown> | null,
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

    const record = await tx.paymentEvent.create({
      data: {
        id: event.id,
        paymentId: event.paymentId,
        type: event.type,
        externalId: event.externalId,
        payload:
          event.payload as Prisma.InputJsonValue | undefined,
        occurredAt: event.occurredAt,
        createdAt: event.createdAt,
      },
    });

    return toDomain(record);
  }

  async append(
    transaction: unknown,
    event: PaymentEvent,
  ): Promise<PaymentEvent> {
    const tx = transaction as PrismaTransactionClient;

    await tx.paymentEvent.create({
      data: {
        id: event.id,
        paymentId: event.paymentId,
        type: event.type,
        externalId: event.externalId,
        payload: event.payload ?? Prisma.JsonNull,
        createdAt: event.createdAt,
      },
    });

    return event;
  }

  async findByExternalId(
    transaction: unknown,
    externalId: string,
  ): Promise<PaymentEvent | null> {
    const tx = transaction as PrismaTransactionClient;

    const record = await tx.paymentEvent.findFirst({
      where: {
        externalId,
      },
    });

    if (!record) {
      return null;
    }

    return PaymentEvent.create({
      id: record.id,
      paymentId: record.paymentId,
      type: record.type,
      externalId: record.externalId,
      payload:
        record.payload === null ||
        typeof record.payload !== "object" ||
        Array.isArray(record.payload)
          ? null
          : (record.payload as Record<string, unknown>),
      createdAt: record.createdAt,
    });
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
