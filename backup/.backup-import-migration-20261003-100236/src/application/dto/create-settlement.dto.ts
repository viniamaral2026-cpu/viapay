export interface CreateSettlementInput {
  id: string;
  paymentId: string;
  amountBRLMinor: bigint;
  externalId?: string | null;
}
