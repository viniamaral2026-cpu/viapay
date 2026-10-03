export type Currency =
  | "BRL"
  | "USD"
  | "EUR"
  | "GBP"
  | "CNY"
  | "JPY";

export type AccountStatus =
  | "PENDING"
  | "ACTIVE"
  | "BLOCKED"
  | "SUSPENDED"
  | "CLOSED";

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

export type ApprovalStatus =
  | "PENDING"
  | "APPROVED"
  | "REJECTED"
  | "EXPIRED";

export interface Money {
  amount: string;
  currency: Currency;
}

export interface Customer {
  id: string;
  legalName: string;
  document?: string;
  status: string;
  createdAt: string;
}

export interface Account {
  id: string;
  customerId: string;
  number: string;
  branch?: string;
  currency: Currency;
  status: AccountStatus;
  availableBalance: string;
  ledgerBalance: string;
}

export interface Payment {
  id: string;
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amount: string;
  currency: Currency;
  status: PaymentStatus;
  createdAt: string;
}

export interface Approval {
  id: string;
  operationId: string;
  requestedBy: string;
  approvedBy?: string;
  requiredLevel: string;
  status: ApprovalStatus;
}
