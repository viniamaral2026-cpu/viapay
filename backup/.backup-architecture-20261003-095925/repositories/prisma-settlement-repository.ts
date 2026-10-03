import type { Settlement as PrismaSettlement } from "@prisma/client";

import {
  Settlement,
  type SettlementStatus,
} from "../../domain/entities/settlement.js";

import type { SettlementRepository } from "../../domain/repositories/settlement-repository.js";

import { db } from "../../prisma/db.js";

function toDomain(
  record: PrismaSettlement,
): Settlement {
  return Settlement.create({
    id: record.id,
    paymentId: record.paymentId,
    amountBRLMinor: record.amountBRLMinor,
    status: record.status as SettlementStatus,
    externalId: record.externalId,
    settledAt: record.settledAt,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaSettlementRepository
  implements SettlementRepository
{
  async create(
    settlement: Settlement,
  ): Promise<Settlement> {
    const record =
      await db.settlement.create({
        data: {
          id: settlement.id,
          paymentId: settlement.paymentId,
          amountBRLMinor:
            settlement.amountBRLMinor,
          status: settlement.status,
          externalId:
            settlement.externalId,
          settledAt:
            settlement.settledAt,
          createdAt:
            settlement.createdAt,
          updatedAt:
            settlement.updatedAt,
        },
      });

    return toDomain(record);
  }

  async findById(
    id: string,
  ): Promise<Settlement | null> {
    const record =
      await db.settlement.findUnique({
        where: { id },
      });

    return record
      ? toDomain(record)
      : null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<Settlement | null> {
    const record =
      await db.settlement.findUnique({
        where: { paymentId },
      });

    return record
      ? toDomain(record)
      : null;
  }

  async findByExternalId(
    externalId: string,
  ): Promise<Settlement | null> {
    const record =
      await db.settlement.findUnique({
        where: { externalId },
      });

    return record
      ? toDomain(record)
      : null;
  }

  async save(
    settlement: Settlement,
  ): Promise<Settlement> {
    const record =
      await db.settlement.update({
        where: {
          id: settlement.id,
        },
        data: {
          paymentId:
            settlement.paymentId,
          amountBRLMinor:
            settlement.amountBRLMinor,
          status:
            settlement.status,
          externalId:
            settlement.externalId,
          settledAt:
            settlement.settledAt,
          updatedAt:
            settlement.updatedAt,
        },
      });

    return toDomain(record);
  }
}
