import { DomainError } from "@/domain/errors/domain-error.js";
import { MoneyBRL } from "@/domain/value-objects/money-brl.js";

export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";

export interface PaymentProps {
  id: string;
  merchantId: string;
  amount: MoneyBRL;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: Date;
  updatedAt: Date;
}

export class Payment {
  private constructor(
    private readonly props: PaymentProps,
  ) {}

  static create(props: {
    id: string;
    merchantId: string;
    amount: MoneyBRL;
    merchantWallet: string;
    status?: PaymentStatus;
    createdAt?: Date;
    updatedAt?: Date;
  }): Payment {
    if (!props.id.trim()) {
      throw new DomainError("Payment id is required.");
    }

    if (!props.merchantId.trim()) {
      throw new DomainError("Merchant id is required.");
    }

    if (!props.merchantWallet.trim()) {
      throw new DomainError("Merchant wallet is required.");
    }

    return new Payment({
      id: props.id,
      merchantId: props.merchantId,
      amount: props.amount,
      merchantWallet: props.merchantWallet,
      status: props.status ?? "CREATED",
      createdAt: props.createdAt ?? new Date(),
      updatedAt: props.updatedAt ?? new Date(),
    });
  }

  get id(): string {
    return this.props.id;
  }

  get merchantId(): string {
    return this.props.merchantId;
  }

  get amount(): MoneyBRL {
    return this.props.amount;
  }

  get merchantWallet(): string {
    return this.props.merchantWallet;
  }

  get status(): PaymentStatus {
    return this.props.status;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  markPixPending(): void {
    this.ensureStatus("CREATED");

    this.props.status = "PIX_PENDING";
    this.props.updatedAt = new Date();
  }

  markPixPaid(): void {
    this.ensureStatus("PIX_PENDING");

    this.props.status = "PIX_PAID";
    this.props.updatedAt = new Date();
  }

  markSettlementPending(): void {
    this.ensureStatus("PIX_PAID");

    this.props.status = "SETTLEMENT_PENDING";
    this.props.updatedAt = new Date();
  }

  markSettling(): void {
    this.ensureStatus("SETTLEMENT_PENDING");

    this.props.status = "SETTLING";
    this.props.updatedAt = new Date();
  }

  markSettled(): void {
    this.ensureStatus("SETTLING");

    this.props.status = "SETTLED";
    this.props.updatedAt = new Date();
  }

  markFailed(): void {
    if (
      this.props.status === "SETTLED" ||
      this.props.status === "EXPIRED"
    ) {
      throw new DomainError(
        `Payment cannot be failed from status ${this.props.status}.`,
      );
    }

    this.props.status = "FAILED";
    this.props.updatedAt = new Date();
  }

  markExpired(): void {
    if (
      this.props.status === "PIX_PAID" ||
      this.props.status === "SETTLEMENT_PENDING" ||
      this.props.status === "SETTLING" ||
      this.props.status === "SETTLED"
    ) {
      throw new DomainError(
        `Payment cannot expire from status ${this.props.status}.`,
      );
    }

    this.props.status = "EXPIRED";
    this.props.updatedAt = new Date();
  }

  private ensureStatus(expected: PaymentStatus): void {
    if (this.props.status !== expected) {
      throw new DomainError(
        `Invalid payment transition: ${this.props.status} -> ${expected}.`,
      );
    }
  }
}
