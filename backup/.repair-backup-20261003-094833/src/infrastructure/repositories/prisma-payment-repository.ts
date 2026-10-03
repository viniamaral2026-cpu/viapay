import type { Payment as PrismaPayment } from "@prisma/client";

import {
  Payment,
  type PaymentStatus,
} from "../../domain/entities/payment.js";
import type { PaymentRepository } from "../../domain/repositories/payment-repository.js";
import { MoneyBRL } from "../../domain/value-objects/money-brl.js";
import { db } from "../../prisma/db.js";

function toDomain(record: PrismaPayment): Payment {
  return Payment.create({
    id: record.id,
    merchantId: record.merchantId,
    amount: MoneyBRL.fromCents(record.amountBRLMinor),
    merchantWallet: record.merchantWallet,
    status: record.status as PaymentStatus,
    createdAt: record.createdAt,
    updatedAt: record.updatedAt,
  });
}

export class PrismaPaymentRepository implements PaymentRepository {
  async create(payment: Payment): Promise<Payment> {
    const record = await db.payment.create({
      data: {
        id: payment.id,
        merchantId: payment.merchantId,
        amountBRLMinor: payment.amount.amountInCents,
        merchantWallet: payment.merchantWallet,
        status: payment.status,
        createdAt: payment.createdAt,
        updatedAt: payment.updatedAt,
      },
    });

    return toDomain(record);
  }

  async findById(id: string): Promise<Payment | null> {
    const record = await db.payment.findUnique({
      where: {
        id,
      },
    });

    return record ? toDomain(record) : null;
  }

  async save(payment: Payment): Promise<Payment> {
    const record = await db.payment.update({
      where: {
        id: payment.id,
      },
      data: {
        merchantId: payment.merchantId,
        amountBRLMinor: payment.amount.amountInCents,
        merchantWallet: payment.merchantWallet,
        status: payment.status,
        updatedAt: payment.updatedAt,
      },
    });

    return toDomain(record);
  }
}
