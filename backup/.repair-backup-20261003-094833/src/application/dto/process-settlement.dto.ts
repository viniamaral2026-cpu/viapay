export interface ProcessSettlementInput {
  settlementId: string;
  externalId: string;
  payload?: Record<string, unknown> | null;
}
