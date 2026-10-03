export interface SandboxPaymentRequest {
  amount: string;
  currency: string;
  rail: string;
  customerId: string;
  merchantId: string;
  idempotencyKey: string;
}

export interface SandboxPaymentResponse {
  id: string;
  status: "AUTHORIZED" | "PROCESSING" | "SETTLED";
  amount: string;
  currency: string;
  rail: string;
  createdAt: string;
}

export function simulatePayment(
  request: SandboxPaymentRequest,
): SandboxPaymentResponse {
  return {
    id: `pay_sandbox_${Date.now()}`,
    status: "AUTHORIZED",
    amount: request.amount,
    currency: request.currency,
    rail: request.rail,
    createdAt: new Date().toISOString(),
  };
}
