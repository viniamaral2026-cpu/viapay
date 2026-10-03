export type Environment =
  | "sandbox"
  | "development"
  | "staging"
  | "production";

export type Currency =
  | "BRL"
  | "USD"
  | "EUR"
  | "GBP"
  | "CNY"
  | "USDC";

export type TransactionStatus =
  | "CREATED"
  | "PENDING"
  | "PROCESSING"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "EXPIRED"
  | "REQUIRES_APPROVAL";

export type PaymentStatus =
  | "CREATED"
  | "AWAITING_PAYMENT"
  | "PAYMENT_DETECTED"
  | "VERIFYING"
  | "CONFIRMED"
  | "FAILED"
  | "EXPIRED"
  | "CANCELLED"
  | "SETTLEMENT_PENDING"
  | "SETTLED";

export type SettlementStatus =
  | "PENDING"
  | "PROCESSING"
  | "COMPLETED"
  | "FAILED"
  | "REVERSED";

export interface Money {
  amount: string;
  currency: Currency;
}

export interface Institution {
  id: string;
  name: string;
  country: string;
  status: "ACTIVE" | "SUSPENDED";
}

export interface Account {
  id: string;
  customerId: string;
  type: "CHECKING" | "SETTLEMENT" | "ESCROW" | "TEST";
  currency: Currency;
  balance: string;
  availableBalance: string;
  status: "ACTIVE" | "BLOCKED" | "CLOSED";
}

export interface Customer {
  id: string;
  name: string;
  email: string;
  country: string;
  status: "ACTIVE" | "PENDING" | "BLOCKED";
}

export interface Merchant {
  id: string;
  legalName: string;
  displayName: string;
  country: string;
  status: "ACTIVE" | "PENDING" | "SUSPENDED";
}

export interface Payment {
  id: string;
  merchantId: string;
  amount: string;
  currency: Currency;
  status: PaymentStatus;
  description: string;
  createdAt: string;
}

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: "DEBIT" | "CREDIT";
  amount: string;
  currency: Currency;
  createdAt: string;
}

export interface Settlement {
  id: string;
  paymentId: string;
  amount: string;
  currency: Currency;
  status: SettlementStatus;
  provider: string;
  createdAt: string;
}

export interface FxQuote {
  id: string;
  baseCurrency: Currency;
  quoteCurrency: Currency;
  baseAmount: string;
  quoteAmount: string;
  rate: string;
  fee: string;
  status: "CREATED" | "LOCKED" | "EXECUTED" | "EXPIRED" | "FAILED";
}

export interface AuditLog {
  id: string;
  actor: string;
  action: string;
  resource: string;
  resourceId: string;
  result: "SUCCESS" | "DENIED" | "ERROR";
  timestamp: string;
}

export interface ApiApplication {
  id: string;
  name: string;
  environment: Environment;
  status: "ACTIVE" | "SUSPENDED";
  createdAt: string;
}

export interface WebhookEvent {
  id: string;
  type: string;
  status: "DELIVERED" | "FAILED" | "PENDING";
  attempts: number;
  createdAt: string;
}
