export interface CreatePixChargeInput {
  id: string;
  paymentId: string;
  provider: string;
  providerId?: string | null;
  qrCode: string;
  qrCodeImage?: string | null;
  amountBRLMinor: bigint;
  expiresAt: Date;
}
