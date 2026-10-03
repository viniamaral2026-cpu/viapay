import type { Merchant as PrismaMerchant } from "@prisma/client";

import { Merchant } from "../../domain/entities/merchant.js";
import type { MerchantRepository } from "../../domain/repositories/merchant-repository.js";
import { db } from "../../prisma/db.js";

function toDomain(record: PrismaMerchant): Merchant {
  return Merchant.create({
    id: record.id,
    name: record.name,
    document: record.document,
    wallet: record.wallet,
    active: record.active,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaMerchantRepository implements MerchantRepository {
  async create(merchant: Merchant): Promise<Merchant> {
    const record = await db.merchant.create({
      data: {
        id: merchant.id,
        name: merchant.name,
        document: merchant.document,
        wallet: merchant.wallet,
        active: merchant.active,
        createdAt: merchant.createdAt,
        updatedAt: merchant.updatedAt,
      },
    });

    return toDomain(record);
  }

  async findById(id: string): Promise<Merchant | null> {
    const record = await db.merchant.findUnique({
      where: { id },
    });

    return record ? toDomain(record) : null;
  }

  async findByDocument(document: string): Promise<Merchant | null> {
    const record = await db.merchant.findUnique({
      where: { document },
    });

    return record ? toDomain(record) : null;
  }

  async save(merchant: Merchant): Promise<Merchant> {
    const record = await db.merchant.update({
      where: {
        id: merchant.id,
      },
      data: {
        name: merchant.name,
        document: merchant.document,
        wallet: merchant.wallet,
        active: merchant.active,
        updatedAt: merchant.updatedAt,
      },
    });

    return toDomain(record);
  }
}
