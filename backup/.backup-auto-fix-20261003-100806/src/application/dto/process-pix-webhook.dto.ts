export interface ProcessPixWebhookInput {
  externalId: string;
  provider: string;
  providerId: string;
  paymentId: string;
  amountBRLMinor: bigint;
  paidAt: Date;
  payload?: Record<string, unknown> | null;
}
