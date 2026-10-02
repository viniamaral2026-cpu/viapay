import type { FastifyReply, FastifyRequest } from "fastify";
import { z } from "zod";

import { container } from "../composition/container.js";

const createPaymentSchema = z.object({
  amountBRL: z.number().finite().positive(),
  merchantWallet: z.string().trim().min(1)
});

const paymentIdSchema = z.object({
  id: z.string().trim().min(1)
});

export async function createPaymentController(
  request: FastifyRequest,
  reply: FastifyReply
) {
  const input = createPaymentSchema.parse(request.body);

  const amountBRLMinor = BigInt(
    Math.round(input.amountBRL * 100)
  );

  const paymentId = `payment_${crypto.randomUUID()}`;

  const result = await container.createPayment.execute({
    paymentId,
    amountBRLMinor,
    merchantWallet: input.merchantWallet
  });

  return reply.status(201).send({
    paymentId: result.paymentId,
    status: result.status,
    pixChargeId: result.pixChargeId,
    qrCode: result.qrCode,
    ...(result.qrCodeImage
      ? { qrCodeImage: result.qrCodeImage }
      : {}),
    expiresAt: result.expiresAt.toISOString()
  });
}

export async function getPaymentController(
  request: FastifyRequest,
  reply: FastifyReply
) {
  const params = paymentIdSchema.parse(request.params);

  const payment = await container.getPayment.execute(
    params.id
  );

  if (!payment) {
    return reply.status(404).send({
      error: "PAYMENT_NOT_FOUND",
      message: "Payment not found"
    });
  }

  return reply.status(200).send({
    id: payment.id,
    amountBRL: Number(payment.amountBRLMinor) / 100,
    merchantWallet: payment.merchantWallet,
    status: payment.status,
    createdAt: payment.createdAt.toISOString(),
    updatedAt: payment.updatedAt.toISOString()
  });
}
