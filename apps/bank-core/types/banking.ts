export type Currency = "BRL" | "USD" | "EUR" | "GBP" | "CNY";

export type AccountStatus =
  | "ACTIVE"
  | "BLOCKED"
  | "SUSPENDED"
  | "CLOSED";

export type PaymentStatus =
  | "PENDING"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLEMENT"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "REFUNDED"
  | "REVERSED";

export interface BankAccount {
  id: string;
  customerId: string;
  number: string;
  branch: string;
  currency: Currency;
  status: AccountStatus;
  availableBalance: string;
  ledgerBalance: string;
}

export interface Payment {
  id: string;
  accountId: string;
  amount: string;
  currency: Currency;
  status: PaymentStatus;
  idempotencyKey: string;
  createdAt: string;
}

export interface Approval {
  id: string;
  operationId: string;
  requestedBy: string;
  approvedBy?: string;
  requiredLevel: string;
  status: "PENDING" | "APPROVED" | "REJECTED";
}
