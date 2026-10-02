import type { PaymentStatus } from "./payment-status.js";

export interface PaymentProps {
  id: string;
  amountBRLMinor: bigint;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: Date;
  updatedAt: Date;
}

export class Payment {
  private constructor(
    private readonly props: PaymentProps
  ) {}

  static create(input: {
    id: string;
    amountBRLMinor: bigint;
    merchantWallet: string;
    now?: Date;
  }): Payment {
    if (input.amountBRLMinor <= 0n) {
      throw new Error("Payment amount must be greater than zero");
    }

    if (!input.merchantWallet.trim()) {
      throw new Error("Merchant wallet is required");
    }

    const now = input.now ?? new Date();

    return new Payment({
      id: input.id,
      amountBRLMinor: input.amountBRLMinor,
      merchantWallet: input.merchantWallet,
      status: "CREATED",
      createdAt: now,
      updatedAt: now
    });
  }

  get id(): string {
    return this.props.id;
  }

  get amountBRLMinor(): bigint {
    return this.props.amountBRLMinor;
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

  transitionTo(status: PaymentStatus, now = new Date()): void {
    if (!this.canTransitionTo(status)) {
      throw new Error(
        `Invalid payment transition: ${this.props.status} -> ${status}`
      );
    }

    this.props.status = status;
    this.props.updatedAt = now;
  }

  private canTransitionTo(next: PaymentStatus): boolean {
    const transitions: Record<PaymentStatus, PaymentStatus[]> = {
      CREATED: ["PIX_PENDING", "FAILED", "EXPIRED"],
      PIX_PENDING: ["PIX_PAID", "FAILED", "EXPIRED"],
      PIX_PAID: ["SETTLEMENT_PENDING", "FAILED"],
      SETTLEMENT_PENDING: ["SETTLING", "FAILED"],
      SETTLING: ["SETTLED", "FAILED"],
      SETTLED: [],
      FAILED: [],
      EXPIRED: []
    };

    return transitions[this.props.status].includes(next);
  }
}
