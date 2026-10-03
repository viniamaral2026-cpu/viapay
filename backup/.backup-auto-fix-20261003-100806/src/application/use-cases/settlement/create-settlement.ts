import { randomUUID } from "node:crypto";

import { Settlement } from "@/domain/entities/settlement.js";
import { DomainError } from "@/domain/errors/domain-error.js";
import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { SettlementRepository } from "@/domain/repositories/settlement-repository.js";
import type { CreateSettlementInput } from "@/application/dto/create-settlement.dto.js";

export class CreateSettlement {
  constructor(
    private readonly paymentRepository: PaymentRepository,
    private readonly settlementRepository: SettlementRepository,
  ) {}

  async execute(
    input: CreateSettlementInput,
  ): Promise<Settlement> {
    const payment =
      await this.paymentRepository.findById(
        input.paymentId,
      );

    if (!payment) {
      throw new DomainError(
        "Payment not found.",
      );
    }

    const existing =
      await this.settlementRepository.findByPaymentId(
        input.paymentId,
      );

    if (existing) {
      throw new DomainError(
        "A settlement already exists for this payment.",
      );
    }

    if (
      input.amountBRLMinor !==
      payment.amount.amountInCents
    ) {
      throw new DomainError(
        "Settlement amount must match payment amount.",
      );
    }

    if (input.externalId) {
      const existingExternal =
        await this.settlementRepository.findByExternalId(
          input.externalId,
        );

      if (existingExternal) {
        throw new DomainError(
          "A settlement with this externalId already exists.",
        );
      }
    }

    const settlement = Settlement.create({
      id: input.id || randomUUID(),
      paymentId: payment.id,
      amountBRLMinor: input.amountBRLMinor,
      externalId: input.externalId,
      status: "PENDING",
    });

    return this.settlementRepository.create(
      settlement,
    );
  }
}
