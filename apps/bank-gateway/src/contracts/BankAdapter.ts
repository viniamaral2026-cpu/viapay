export interface BankAdapter {
  getAccountBalance(accountId: string): Promise<{
    accountId: string;
    availableBalance: string;
    currency: string;
  }>;

  debitAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }): Promise<{
    transactionId: string;
    status: string;
  }>;

  creditAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }): Promise<{
    transactionId: string;
    status: string;
  }>;

  getTransactionStatus(transactionId: string): Promise<{
    transactionId: string;
    status: string;
  }>;
}
