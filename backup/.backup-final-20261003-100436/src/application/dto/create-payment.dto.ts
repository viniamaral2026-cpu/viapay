export interface CreatePaymentInput {
  id: string;
  merchantId: string;
  amountBRLMinor: bigint | number;
  merchantWallet: string;
}
