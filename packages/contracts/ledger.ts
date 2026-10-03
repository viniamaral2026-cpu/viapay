export interface LedgerEntry {
  accountId: string;
  direction: "DEBIT" | "CREDIT";
  amount: string;
  currency: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: string;
}
