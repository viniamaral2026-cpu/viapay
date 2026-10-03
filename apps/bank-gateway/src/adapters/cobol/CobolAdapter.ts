import type { BankAdapter } from "../../contracts/BankAdapter.js";

export class CobolAdapter implements BankAdapter {
  async getAccountBalance(accountId: string) {
    return {
      accountId,
      availableBalance: "0",
      currency: "BRL",
    };
  }

  async debitAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }) {
    return {
      transactionId: `COBOL-${input.reference}`,
      status: "PENDING",
    };
  }

  async creditAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }) {
    return {
      transactionId: `COBOL-${input.reference}`,
      status: "PENDING",
    };
  }

  async getTransactionStatus(transactionId: string) {
    return {
      transactionId,
      status: "PENDING",
    };
  }
}
