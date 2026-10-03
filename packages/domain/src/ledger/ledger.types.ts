export type LedgerDirection = "DEBIT" | "CREDIT";

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: LedgerDirection;
  amount: string;
  currency: string;
  createdAt: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: string;
}
