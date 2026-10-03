export interface Settlement {
  id: string;
  paymentId: string;
  sourceCurrency: string;
  destinationCurrency: string;
  grossAmountMinor: bigint;
  feesMinor: bigint;
  netAmountMinor: bigint;
  status:
    | "CREATED"
    | "PROCESSING"
    | "SETTLED"
    | "FAILED";
  createdAt: Date;
}
