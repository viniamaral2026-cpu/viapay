import { DomainError } from "@/domain/errors/domain-error.js";

export type SettlementStatus =
  | "PENDING"
  | "PROCESSING"
  | "SETTLED"
  | "FAILED"
  | "CANCELLED";

export interface SettlementProps {
  id: string;
  paymentId: string;
  amountBRLMinor: bigint;
  status: SettlementStatus;
  externalId: string | null;
  settledAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export class Settlement {
  private constructor(
    private readonly props: SettlementProps,
  ) {}

  static create(props: {
    id: string;
    paymentId: string;
    amountBRLMinor: bigint;
    status?: SettlementStatus;
    externalId?: string | null;
    settledAt?: Date | null;
    createdAt?: Date;
    updatedAt?: Date;
  }): Settlement {
    if (!props.id.trim()) {
      throw new DomainError(
        "Settlement id is required.",
      );
    }

    if (!props.paymentId.trim()) {
      throw new DomainError(
        "Payment id is required.",
      );
    }

    if (props.amountBRLMinor <= 0n) {
      throw new DomainError(
        "Settlement amount must be greater than zero.",
      );
    }

    if (
      props.settledAt &&
      Number.isNaN(props.settledAt.getTime())
    ) {
      throw new DomainError(
        "Settlement settledAt must be a valid date.",
      );
    }

    return new Settlement({
      id: props.id,
      paymentId: props.paymentId,
      amountBRLMinor: props.amountBRLMinor,
      status: props.status ?? "PENDING",
      externalId: props.externalId?.trim() || null,
      settledAt: props.settledAt ?? null,
      createdAt: props.createdAt ?? new Date(),
      updatedAt: props.updatedAt ?? new Date(),
    });
  }

  get id(): string {
    return this.props.id;
  }

  get paymentId(): string {
    return this.props.paymentId;
  }

  get amountBRLMinor(): bigint {
    return this.props.amountBRLMinor;
  }

  get status(): SettlementStatus {
    return this.props.status;
  }

  get externalId(): string | null {
    return this.props.externalId;
  }

  get settledAt(): Date | null {
    return this.props.settledAt;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  startProcessing(): void {
    if (this.props.status !== "PENDING") {
      throw new DomainError(
        `Cannot process settlement from status ${this.props.status}.`,
      );
    }

    this.props.status = "PROCESSING";
    this.touch();
  }

  markAsSettled(
    settledAt: Date = new Date(),
  ): void {
    if (
      this.props.status !== "PENDING" &&
      this.props.status !== "PROCESSING"
    ) {
      throw new DomainError(
        `Cannot settle from status ${this.props.status}.`,
      );
    }

    if (settledAt.getTime() > Date.now()) {
      throw new DomainError(
        "Settlement date cannot be in the future.",
      );
    }

    this.props.status = "SETTLED";
    this.props.settledAt = settledAt;
    this.touch();
  }

  fail(): void {
    if (
      this.props.status !== "PENDING" &&
      this.props.status !== "PROCESSING"
    ) {
      throw new DomainError(
        `Cannot fail settlement from status ${this.props.status}.`,
      );
    }

    this.props.status = "FAILED";
    this.touch();
  }

  cancel(): void {
    if (
      this.props.status !== "PENDING" &&
      this.props.status !== "PROCESSING"
    ) {
      throw new DomainError(
        `Cannot cancel settlement from status ${this.props.status}.`,
      );
    }

    this.props.status = "CANCELLED";
    this.touch();
  }

  private touch(): void {
    this.props.updatedAt = new Date();
  }
}
