export type PaymentStatus =
  | "CREATED"
  | "PENDING_APPROVAL"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLEMENT"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "REVERSED";

export interface Payment {
  id: string;
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amountMinor: bigint;
  currency: string;
  status: PaymentStatus;
  createdAt: Date;
}
