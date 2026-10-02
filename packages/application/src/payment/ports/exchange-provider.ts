export interface ExchangeQuote {
  amountBRLMinor: bigint;
  amountUSDCAtomic: bigint;
  rate: string;
}

export interface ExchangeProvider {
  quoteBRLToUSDC(amountBRLMinor: bigint): Promise<ExchangeQuote>;
}
