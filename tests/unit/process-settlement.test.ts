import { PaymentEvent } from "@/domain/entities/payment-event.js";
import type { PaymentEventRepository } from "@/domain/repositories/payment-event-repository.js";

class InMemoryPaymentEventRepository
  implements PaymentEventRepository
{
  private readonly events: PaymentEvent[] = [];

  async create(
    event: PaymentEvent,
  ): Promise<PaymentEvent> {
    this.events.push(event);
    return event;
  }

  async findById(
    id: string,
  ): Promise<PaymentEvent | null> {
    return (
      this.events.find(
        (event) => event.id === id,
      ) ?? null
    );
  }

  async findByPaymentId(
    paymentId: string,
  ): Promise<PaymentEvent[]> {
    return this.events
      .filter(
        (event) =>
          event.paymentId === paymentId,
      )
      .sort(
        (a, b) =>
          a.occurredAt.getTime() -
          b.occurredAt.getTime(),
      );
  }

  async findByExternalId(
    externalId: string,
  ): Promise<PaymentEvent | null> {
    return (
      this.events.find(
        (event) =>
          event.externalId === externalId,
      ) ?? null
    );
  }

  async countByPaymentId(
    paymentId: string,
  ): Promise<number> {
    return this.events.filter(
      (event) => event.paymentId === paymentId,
    ).length;
  }

  all(): PaymentEvent[] {
    return [...this.events];
  }
}
