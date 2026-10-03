import { DomainError } from "@/domain/errors/domain-error.js";

export type PaymentEventType =
  | "CREATED"
  | "PIX_CREATED"
  | "PIX_PAID"
  | "PIX_EXPIRED"
  | "SETTLEMENT_PENDING"
  | "SETTLEMENT_STARTED"
  | "SETTLED"
  | "FAILED";

export interface PaymentEventProps {
  id: string;
  paymentId: string;
  type: PaymentEventType;
  externalId: string | null;
  payload: Record<string, unknown> | null;
  occurredAt: Date;
  createdAt: Date;
}

export class PaymentEvent {
  private constructor(
    private readonly props: PaymentEventProps,
  ) {}

  static create(props: {
    id: string;
    paymentId: string;
    type: PaymentEventType;
    externalId?: string | null;
    payload?: Record<string, unknown> | null;
    occurredAt?: Date;
    createdAt?: Date;
  }): PaymentEvent {
    if (!props.id.trim()) {
      throw new DomainError("Payment event id is required.");
    }

    if (!props.paymentId.trim()) {
      throw new DomainError("Payment id is required.");
    }

    if (!props.type) {
      throw new DomainError("Payment event type is required.");
    }

    const occurredAt = props.occurredAt ?? new Date();

    if (Number.isNaN(occurredAt.getTime())) {
      throw new DomainError(
        "Payment event occurredAt must be a valid date.",
      );
    }

    return new PaymentEvent({
      id: props.id,
      paymentId: props.paymentId,
      type: props.type,
      externalId: props.externalId?.trim() || null,
      payload: props.payload ?? null,
      occurredAt,
      createdAt: props.createdAt ?? new Date(),
    });
  }

  get id(): string {
    return this.props.id;
  }

  get paymentId(): string {
    return this.props.paymentId;
  }

  get type(): PaymentEventType {
    return this.props.type;
  }

  get externalId(): string | null {
    return this.props.externalId;
  }

  get payload(): Record<string, unknown> | null {
    return this.props.payload;
  }

  get occurredAt(): Date {
    return this.props.occurredAt;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }
}
