import { randomUUID } from "node:crypto";

import { Payment } from "../../../domain/entities/payment.js";
import type { PaymentRepository } from "../../../domain/repositories/payment-repository.js";
import { MoneyBRL } from "../../../domain/value-objects/money-brl.js";
import type { CreatePaymentInput } from "../../dto/create-payment.dto.js";

export class CreatePayment {
  constructor(
    private readonly paymentRepository: PaymentRepository,
  ) {}

  async execute(input: CreatePaymentInput): Promise<Payment> {
    const payment = Payment.create({
      id: input.id || randomUUID(),
      merchantId: input.merchantId,
      amount: MoneyBRL.fromCents(input.amountBRLMinor),
      merchantWallet: input.merchantWallet,
    });

    return this.paymentRepository.create(payment);
  }
}
