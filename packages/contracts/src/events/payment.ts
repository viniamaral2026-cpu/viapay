export interface PixPaymentConfirmedEvent {
  type: "pix.payment.confirmed";
  paymentId: string;
  occurredAt: string;
}
