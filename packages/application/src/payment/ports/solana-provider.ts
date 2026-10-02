export interface SettlementInput {
  paymentId: string;
  amountUSDCAtomic: bigint;
  merchantWallet: string;
}

export interface SettlementResult {
  transactionSignature: string;
}

export interface SolanaProvider {
  settle(input: SettlementInput): Promise<SettlementResult>;
}
