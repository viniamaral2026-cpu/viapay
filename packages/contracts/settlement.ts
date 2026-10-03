export interface SettlementInstruction {
  settlementId: string;
  paymentId: string;
  sourceCurrency: string;
  destinationCurrency: string;
  grossAmount: string;
  netAmount: string;
  fees: string;
  status: string;
}
