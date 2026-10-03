import type { PaymentIntent } from "../payment/payment.types";

export interface PaymentRoute {
  rail: string;
  provider: string;
  priority: number;
  enabled: boolean;
}

export interface PaymentRouter {
  resolve(payment: PaymentIntent): Promise<PaymentRoute>;
}
