import type { PrismaTransactionClient } from "../database/prisma-transaction-client.js";

import {
  Settlement,
  type SettlementStatus,
} from "../../domain/entities/settlement.js";

import type { SettlementLockRepository } from "../../domain/repositories/settlement-lock-repository.js";

type SettlementRecord = {
  id: string;
  paymentId: string;
  amountBRLMinor: bigint;
  status: SettlementStatus;
  externalId: string | null;
  settledAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
};

function toDomain(
  record: SettlementRecord,
): Settlement {
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

    const records =
      await tx.$queryRaw<SettlementRecord[]>`
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

    return record ? toDomain(record) : null;
  }

  async save(
    transaction: unknown,
    settlement: Settlement,
  ): Promise<void> {
    const tx =
      transaction as PrismaTransactionClient;

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
