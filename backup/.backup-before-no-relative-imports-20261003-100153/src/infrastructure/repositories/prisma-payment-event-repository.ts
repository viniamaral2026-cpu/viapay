import type { PaymentEvent as PrismaPaymentEvent, Prisma } from "@prisma/client";

import {
  PaymentEvent,
  type PaymentEventType,
} from "../../domain/entities/payment-event.js";
import type { PaymentEventRepository } from "../../domain/repositories/payment-event-repository.js";
import { db } from "../../prisma/db.js";

function toDomain(record: PrismaPaymentEvent): PaymentEvent {
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

export class PrismaPaymentEventRepository
  implements PaymentEventRepository
{
  async create(event: PaymentEvent): Promise<PaymentEvent> {
    const record = await db.paymentEvent.create({
      data: {
        id: event.id,
        paymentId: event.paymentId,
        type: event.type,
        externalId: event.externalId,
        payload: event.payload as Prisma.InputJsonValue | undefined,
        occurredAt: event.occurredAt,
        createdAt: event.createdAt,
      },
    });

    return toDomain(record);
  }

  async findById(id: string): Promise<PaymentEvent | null> {
    const record = await db.paymentEvent.findUnique({
      where: { id },
    });

    return record ? toDomain(record) : null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PaymentEvent[]> {
    const records = await db.paymentEvent.findMany({
      where: { paymentId },
      orderBy: [
        {
          occurredAt: "asc",
        },
        {
          createdAt: "asc",
        },
      ],
    });

    return records.map(toDomain);
  }


  async countByPaymentId(
    paymentId: string,
  ): Promise<number> {
    return db.paymentEvent.count({
      where: {
        paymentId,
      },
    });
  }

  async findByExternalId(
    externalId: string,
  ): Promise<PaymentEvent | null> {
    const record = await db.paymentEvent.findFirst({
      where: { externalId },
    });

    return record ? toDomain(record) : null;
  }
}
