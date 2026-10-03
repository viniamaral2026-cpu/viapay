export type AccountStatus =
  | "PENDING"
  | "ACTIVE"
  | "BLOCKED"
  | "SUSPENDED"
  | "CLOSED";

export interface Account {
  id: string;
  customerId: string;
  number: string;
  currency: string;
  status: AccountStatus;
  ledgerBalanceMinor: bigint;
  availableBalanceMinor: bigint;
}
