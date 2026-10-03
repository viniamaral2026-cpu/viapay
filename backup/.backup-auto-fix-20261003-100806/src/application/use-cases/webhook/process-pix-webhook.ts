import { PaymentEvent } from "@/domain/entities/payment-event.js";
import { DomainError } from "@/domain/errors/domain-error.js";
import type { PaymentRepository } from "@/domain/repositories/payment-repository.js";
import type { PaymentEventRepository } from "@/domain/repositories/payment-event-repository.js";
import type { PixChargeRepository } from "@/domain/repositories/pix-charge-repository.js";
import type { ProcessPixWebhookInput } from "@/application/dto/process-pix-webhook.dto.js";

export class ProcessPixWebhook {
  constructor(
    private readonly paymentRepository: PaymentRepository,
    private readonly pixChargeRepository: PixChargeRepository,
    private readonly paymentEventRepository: PaymentEventRepository,
  ) {}

  async execute(
    input: ProcessPixWebhookInput,
  ): Promise<{
    processed: boolean;
    eventId: string;
  }> {
    if (!input.externalId.trim()) {
      throw new DomainError(
        "Webhook externalId is required.",
      );
    }

    const existing =
      await this.paymentEventRepository.findByExternalId(
        input.externalId,
      );

    if (existing) {
      return {
        processed: false,
        eventId: existing.id,
      };
    }

    const payment =
      await this.paymentRepository.findById(
        input.paymentId,
      );

    if (!payment) {
      throw new DomainError("Payment not found.");
    }

    if (
      payment.amount.amountInCents !==
      input.amountBRLMinor
    ) {
      throw new DomainError(
        "Webhook amount does not match payment amount.",
      );
    }

    const pixCharge =
      await this.pixChargeRepository.findByPaymentId(
        input.paymentId,
      );

    if (!pixCharge) {
      throw new DomainError(
        "PIX charge not found.",
      );
    }

    if (
      pixCharge.amountBRLMinor !==
      input.amountBRLMinor
    ) {
      throw new DomainError(
        "Webhook amount does not match PIX charge amount.",
      );
    }

    if (pixCharge.status === "PAID") {
      throw new DomainError(
        "PIX charge is already marked as paid.",
      );
    }

    pixCharge.markAsPaid(input.paidAt);

    const event = PaymentEvent.create({
      id: crypto.randomUUID(),
      paymentId: payment.id,
      type: "PIX_PAID",
      externalId: input.externalId,
      payload: input.payload ?? {
        provider: input.provider,
        providerId: input.providerId,
      },
      occurredAt: input.paidAt,
    });

    await this.pixChargeRepository.save(pixCharge);
    await this.paymentEventRepository.create(event);

    return {
      processed: true,
      eventId: event.id,
    };
  }
}
