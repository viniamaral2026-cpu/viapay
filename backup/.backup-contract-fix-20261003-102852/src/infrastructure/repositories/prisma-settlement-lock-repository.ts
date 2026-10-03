import type { PrismaTransactionClient } from "@/infrastructure/database/prisma-transaction-client.js";

import {
  Settlement,
  type SettlementStatus,
} from "@/domain/entities/settlement.js";

import type { SettlementLockRepository } from "@/domain/repositories/settlement-lock-repository.js";

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
    status: record.status,
    externalId: record.externalId,
    settledAt: record.settledAt,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaSettlementLockRepository
  implements SettlementLockRepository
{
  async findByIdForUpdate(
    transaction: unknown,
    id: string,
  ): Promise<Settlement | null> {
    const tx =
      transaction as PrismaTransactionClient;

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
}
