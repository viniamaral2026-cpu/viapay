import type { PixCharge as PrismaPixCharge } from "@prisma/client";

import {
  PixCharge,
  type PixChargeStatus,
} from "@/domain/entities/pix-charge.js";
import type { PixChargeRepository } from "@/domain/repositories/pix-charge-repository.js";
import { db } from "@/prisma/db.js";

function toDomain(record: PrismaPixCharge): PixCharge {
  return PixCharge.create({
    id: record.id,
    paymentId: record.paymentId,
    provider: record.provider,
    providerId: record.providerId,
    qrCode: record.qrCode,
    qrCodeImage: record.qrCodeImage,
    amountBRLMinor: record.amountBRLMinor,
    status: record.status as PixChargeStatus,
    expiresAt: record.expiresAt,
    paidAt: record.paidAt,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaPixChargeRepository
  implements PixChargeRepository
{
  async create(pixCharge: PixCharge): Promise<PixCharge> {
    const record = await db.pixCharge.create({
      data: {
        id: pixCharge.id,
        paymentId: pixCharge.paymentId,
        provider: pixCharge.provider,
        providerId: pixCharge.providerId,
        qrCode: pixCharge.qrCode,
        qrCodeImage: pixCharge.qrCodeImage,
        amountBRLMinor: pixCharge.amountBRLMinor,
        status: pixCharge.status,
        expiresAt: pixCharge.expiresAt,
        paidAt: pixCharge.paidAt,
        createdAt: pixCharge.createdAt,
        updatedAt: pixCharge.updatedAt,
      },
    });

    return toDomain(record);
  }

  async findById(id: string): Promise<PixCharge | null> {
    const record = await db.pixCharge.findUnique({
      where: { id },
    });

    return record ? toDomain(record) : null;
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PixCharge | null> {
    const record = await db.pixCharge.findUnique({
      where: { paymentId },
    });

    return record ? toDomain(record) : null;
  }

  async findByProviderId(
    providerId: string,
  ): Promise<PixCharge | null> {
    const record = await db.pixCharge.findFirst({
      where: { providerId },
    });

    return record ? toDomain(record) : null;
  }

  async save(pixCharge: PixCharge): Promise<PixCharge> {
    const record = await db.pixCharge.update({
      where: {
        id: pixCharge.id,
      },
      data: {
        provider: pixCharge.provider,
        providerId: pixCharge.providerId,
        qrCode: pixCharge.qrCode,
        qrCodeImage: pixCharge.qrCodeImage,
        amountBRLMinor: pixCharge.amountBRLMinor,
        status: pixCharge.status,
        expiresAt: pixCharge.expiresAt,
        paidAt: pixCharge.paidAt,
        updatedAt: pixCharge.updatedAt,
      },
    });

    return toDomain(record);
  }
}
