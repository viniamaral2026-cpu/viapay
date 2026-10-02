export interface CreatePaymentRequest {
  amountBRL: number;
  merchantWallet: string;
}

export interface CreatePaymentResponse {
  paymentId: string;
  status: PaymentStatus;
  pixChargeId: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: string;
}

export interface PaymentResponse {
  id: string;
  amountBRL: number;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: string;
  updatedAt: string;
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
