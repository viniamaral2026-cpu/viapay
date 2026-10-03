export type PaymentStatus =
  | "CREATED"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLED"
  | "FAILED"
  | "REVERSED"
  | "CANCELLED";

export type PaymentRail =
  | "SANDBOX"
  | "PIX"
  | "BANK"
  | "CARD"
  | "THUNES"
  | "SOLANA"
  | "BLOCKCHAIN";

export interface Money {
  amount: string;
  currency: string;
}

export interface PaymentIntent {
  id: string;
  idempotencyKey: string;
  status: PaymentStatus;
  rail: PaymentRail;
  source: Money;
  destination: Money;
  merchantId: string;
  customerId: string;
  createdAt: string;
  updatedAt: string;
}
