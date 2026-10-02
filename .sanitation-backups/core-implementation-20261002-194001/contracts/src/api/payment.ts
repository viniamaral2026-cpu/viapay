export interface CreatePaymentRequest {
  amountBRL: number;
  merchantWallet: string;
}

export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";
