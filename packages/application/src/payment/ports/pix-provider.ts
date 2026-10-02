export interface CreatePixChargeInput {
  paymentId: string;
  amountBRLMinor: bigint;
}

export interface PixCharge {
  id: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: Date;
}

export interface PixProvider {
  createCharge(input: CreatePixChargeInput): Promise<PixCharge>;
}
