export interface FxQuote {
  id: string;
  baseCurrency: string;
  quoteCurrency: string;
  rate: string;
  sourceAmount: string;
  destinationAmount: string;
  provider: string;
  expiresAt: string;
}
