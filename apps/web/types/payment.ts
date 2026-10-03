export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";

export interface Payment {
  id: string;
  amountBRL: number;
  merchantWallet: string;
  status: PaymentStatus;
  pixChargeId?: string;
  qrCode?: string;
  qrCodeImage?: string;
  amountUSDC?: number;
  exchangeRate?: string;
  customerName?: string;
  reference?: string;
  expiresAt?: string;
  solanaSignature?: string;
  createdAt: string;
  updatedAt: string;
}
