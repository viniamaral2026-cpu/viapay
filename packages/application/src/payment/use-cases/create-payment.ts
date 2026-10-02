import { Payment } from "@viapay/domain";
import type { PaymentRepository } from "../ports/payment-repository.js";
import type { PixProvider } from "../ports/pix-provider.js";

export interface CreatePaymentInput {
  paymentId: string;
  amountBRLMinor: bigint;
  merchantWallet: string;
}

export interface CreatePaymentOutput {
  paymentId: string;
  status: "PIX_PENDING";
  pixChargeId: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: Date;
}

export class CreatePayment {
  constructor(
    private readonly repository: PaymentRepository,
    private readonly pixProvider: PixProvider
  ) {}

  async execute(
    input: CreatePaymentInput
  ): Promise<CreatePaymentOutput> {
    const payment = Payment.create({
      id: input.paymentId,
      amountBRLMinor: input.amountBRLMinor,
      merchantWallet: input.merchantWallet
    });

    payment.transitionTo("PIX_PENDING");

    await this.repository.save(payment);

    const charge = await this.pixProvider.createCharge({
      paymentId: payment.id,
      amountBRLMinor: payment.amountBRLMinor
    });

    return {
      paymentId: payment.id,
      status: "PIX_PENDING",
      pixChargeId: charge.id,
      qrCode: charge.qrCode,
      ...(charge.qrCodeImage
        ? { qrCodeImage: charge.qrCodeImage }
        : {}),
      expiresAt: charge.expiresAt
    };
  }
}
