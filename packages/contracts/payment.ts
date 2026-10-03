export interface PaymentRequest {
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amount: string;
  currency: string;
  purpose?: string;
  metadata?: Record<string, string>;
}

export interface PaymentResponse {
  paymentId: string;
  status: string;
  createdAt: string;
}
