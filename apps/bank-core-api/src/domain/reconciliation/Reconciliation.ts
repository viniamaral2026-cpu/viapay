export type ReconciliationStatus =
  | "MATCHED"
  | "MISMATCH"
  | "MISSING"
  | "DUPLICATE"
  | "PENDING";

export interface ReconciliationItem {
  id: string;
  internalReference: string;
  externalReference?: string;
  amountMinor: bigint;
  currency: string;
  status: ReconciliationStatus;
  createdAt: Date;
}
