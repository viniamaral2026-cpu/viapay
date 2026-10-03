import { randomUUID } from "node:crypto";

import { PaymentEvent } from "@/domain/entities/payment-event.js";
import { DomainError } from "@/domain/errors/domain-error.js";
import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { PaymentEventRepository } from "@/domain/repositories/payment-event-repository.js";
import type { CreatePaymentEventInput } from "@/application/dto/create-payment-event.dto.js";

export class CreatePaymentEvent {
  constructor(
    private readonly paymentRepository: PaymentRepository,
    private readonly paymentEventRepository: PaymentEventRepository,
  ) {}

  async execute(
    input: CreatePaymentEventInput,
  ): Promise<PaymentEvent> {
    const payment = await this.paymentRepository.findById(
      input.paymentId,
    );

    if (!payment) {
      throw new DomainError("Payment not found.");
    }

    if (input.externalId) {
      const existing =
        await this.paymentEventRepository.findByExternalId(
          input.externalId,
        );

      if (existing) {
        throw new DomainError(
          "A payment event with this externalId already exists.",
        );
      }
    }

    const event = PaymentEvent.create({
      id: input.id || randomUUID(),
      paymentId: payment.id,
      type: input.type,
      externalId: input.externalId,
      payload: input.payload,
      occurredAt: input.occurredAt,
    });

    return this.paymentEventRepository.create(event);
  }
}
