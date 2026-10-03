import { randomUUID } from "node:crypto";

import { PixCharge } from "@/domain/entities/pix-charge.js";
import { DomainError } from "@/domain/errors/domain-error.js";
import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { PixChargeRepository } from "@/domain/repositories/pix-charge-repository.js";
import type { CreatePixChargeInput } from "@/application/dto/create-pix-charge.dto.js";

export class CreatePixCharge {
  constructor(
    private readonly paymentRepository: PaymentRepository,
    private readonly pixChargeRepository: PixChargeRepository,
  ) {}

  async execute(input: CreatePixChargeInput): Promise<PixCharge> {
    const payment = await this.paymentRepository.findById(
      input.paymentId,
    );

    if (!payment) {
      throw new DomainError("Payment not found.");
    }

    const existing =
      await this.pixChargeRepository.findByPaymentId(
        input.paymentId,
      );

    if (existing) {
      throw new DomainError(
        "A PIX charge already exists for this payment.",
      );
    }

    if (input.amountBRLMinor !== payment.amount.amountInCents) {
      throw new DomainError(
        "PIX charge amount must match payment amount.",
      );
    }

    const pixCharge = PixCharge.create({
      id: input.id || randomUUID(),
      paymentId: payment.id,
      provider: input.provider,
      providerId: input.providerId,
      qrCode: input.qrCode,
      qrCodeImage: input.qrCodeImage,
      amountBRLMinor: input.amountBRLMinor,
      expiresAt: input.expiresAt,
      status: "CREATED",
    });

    return this.pixChargeRepository.create(pixCharge);
  }
}
