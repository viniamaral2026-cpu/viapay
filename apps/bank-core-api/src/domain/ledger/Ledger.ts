export type LedgerDirection = "DEBIT" | "CREDIT";

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: LedgerDirection;
  amountMinor: bigint;
  currency: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: Date;
}

export function validateBalancedTransaction(
  entries: LedgerEntry[],
): boolean {
  const debit = entries
    .filter((entry) => entry.direction === "DEBIT")
    .reduce((sum, entry) => sum + entry.amountMinor, 0n);

  const credit = entries
    .filter((entry) => entry.direction === "CREDIT")
    .reduce((sum, entry) => sum + entry.amountMinor, 0n);

  return debit === credit;
}
