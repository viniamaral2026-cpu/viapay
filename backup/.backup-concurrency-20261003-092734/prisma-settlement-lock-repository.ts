import type { PrismaTransactionClient } from "../database/prisma-transaction-client.js";

import {
  Settlement,
  type SettlementStatus,
} from "../../domain/entities/settlement.js";

function toDomain(record: {
  id: string;
  paymentId: string;
  amountBRLMinor: bigint;
  status: SettlementStatus;
  externalId: string | null;
  settledAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}): Settlement {
  return Settlement.create({
    id: record.id,
    paymentId: record.paymentId,
    amountBRLMinor: record.amountBRLMinor,
    externalId: record.externalId,
    status: record.status,
    settledAt: record.settledAt,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaSettlementLockRepository {
  async findByIdForUpdate(
    tx: PrismaTransactionClient,
    id: string,
  ): Promise<Settlement | null> {
    const records = await tx.$queryRaw<
      Array<{
        id: string;
        paymentId: string;
        amountBRLMinor: bigint;
        status: SettlementStatus;
        externalId: string | null;
        settledAt: Date | null;
        createdAt: Date;
        updatedAt: Date;
      }>
    >`
      SELECT
        id,
        "paymentId",
        "amountBRLMinor",
        status,
        "externalId",
        "settledAt",
        "createdAt",
        "updatedAt"
      FROM settlements
      WHERE id = ${id}
      FOR UPDATE
    `;

    const record = records[0];

    if (!record) {
      return null;
    }

    return toDomain(record);
  }

  async save(
    tx: PrismaTransactionClient,
    settlement: Settlement,
  ): Promise<void> {
    await tx.settlement.update({
      where: {
        id: settlement.id,
      },
      data: {
        status: settlement.status,
        externalId: settlement.externalId,
        settledAt: settlement.settledAt,
        updatedAt: settlement.updatedAt,
      },
    });
  }
}
