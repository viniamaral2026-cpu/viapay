import { DomainError } from "../errors/domain-error.js";

export type PixChargeStatus =
  | "CREATED"
  | "ACTIVE"
  | "PAID"
  | "EXPIRED"
  | "CANCELLED"
  | "FAILED";

export interface PixChargeProps {
  id: string;
  paymentId: string;
  provider: string;
  providerId: string | null;
  qrCode: string;
  qrCodeImage: string | null;
  amountBRLMinor: bigint;
  status: PixChargeStatus;
  expiresAt: Date;
  paidAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export class PixCharge {
  private constructor(
    private readonly props: PixChargeProps,
  ) {}

  static create(props: {
    id: string;
    paymentId: string;
    provider: string;
    providerId?: string | null;
    qrCode: string;
    qrCodeImage?: string | null;
    amountBRLMinor: bigint;
    status?: PixChargeStatus;
    expiresAt: Date;
    paidAt?: Date | null;
    createdAt?: Date;
    updatedAt?: Date;
  }): PixCharge {
    if (!props.id.trim()) {
      throw new DomainError("Pix charge id is required.");
    }

    if (!props.paymentId.trim()) {
      throw new DomainError("Payment id is required.");
    }

    if (!props.provider.trim()) {
      throw new DomainError("PIX provider is required.");
    }

    if (!props.qrCode.trim()) {
      throw new DomainError("PIX QR code is required.");
    }

    if (props.amountBRLMinor <= 0n) {
      throw new DomainError(
        "PIX charge amount must be greater than zero.",
      );
    }

    if (props.expiresAt.getTime() <= Date.now()) {
      throw new DomainError(
        "PIX charge expiration must be in the future.",
      );
    }

    return new PixCharge({
      id: props.id,
      paymentId: props.paymentId,
      provider: props.provider.trim(),
      providerId: props.providerId ?? null,
      qrCode: props.qrCode,
      qrCodeImage: props.qrCodeImage ?? null,
      amountBRLMinor: props.amountBRLMinor,
      status: props.status ?? "CREATED",
      expiresAt: props.expiresAt,
      paidAt: props.paidAt ?? null,
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

  get provider(): string {
    return this.props.provider;
  }

  get providerId(): string | null {
    return this.props.providerId;
  }

  get qrCode(): string {
    return this.props.qrCode;
  }

  get qrCodeImage(): string | null {
    return this.props.qrCodeImage;
  }

  get amountBRLMinor(): bigint {
    return this.props.amountBRLMinor;
  }

  get status(): PixChargeStatus {
    return this.props.status;
  }

  get expiresAt(): Date {
    return this.props.expiresAt;
  }

  get paidAt(): Date | null {
    return this.props.paidAt;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  activate(): void {
    if (this.props.status !== "CREATED") {
      throw new DomainError(
        `Cannot activate PIX charge from status ${this.props.status}.`,
      );
    }

    this.props.status = "ACTIVE";
    this.touch();
  }

  markAsPaid(paidAt: Date = new Date()): void {
    if (
      this.props.status !== "CREATED" &&
      this.props.status !== "ACTIVE"
    ) {
      throw new DomainError(
        `Cannot mark PIX charge as paid from status ${this.props.status}.`,
      );
    }

    if (paidAt.getTime() > Date.now()) {
      throw new DomainError(
        "PIX payment date cannot be in the future.",
      );
    }

    this.props.status = "PAID";
    this.props.paidAt = paidAt;
    this.touch();
  }

  expire(now: Date = new Date()): void {
    if (
      this.props.status !== "CREATED" &&
      this.props.status !== "ACTIVE"
    ) {
      throw new DomainError(
        `Cannot expire PIX charge from status ${this.props.status}.`,
      );
    }

    if (now.getTime() < this.props.expiresAt.getTime()) {
      throw new DomainError(
        "PIX charge has not expired yet.",
      );
    }

    this.props.status = "EXPIRED";
    this.touch();
  }

  cancel(): void {
    if (
      this.props.status !== "CREATED" &&
      this.props.status !== "ACTIVE"
    ) {
      throw new DomainError(
        `Cannot cancel PIX charge from status ${this.props.status}.`,
      );
    }

    this.props.status = "CANCELLED";
    this.touch();
  }

  fail(): void {
    if (
      this.props.status !== "CREATED" &&
      this.props.status !== "ACTIVE"
    ) {
      throw new DomainError(
        `Cannot fail PIX charge from status ${this.props.status}.`,
      );
    }

    this.props.status = "FAILED";
    this.touch();
  }

  private touch(): void {
    this.props.updatedAt = new Date();
  }
}
