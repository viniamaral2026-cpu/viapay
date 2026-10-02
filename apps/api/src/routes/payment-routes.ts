import type { FastifyInstance } from "fastify";

import {
  createPaymentController,
  getPaymentController
} from "../controllers/payment-controller.js";

export async function paymentRoutes(
  app: FastifyInstance
): Promise<void> {
  app.post(
    "/payments",
    {
      schema: {
        tags: ["Payments"],
        summary: "Create payment",
        description: "Creates a payment and generates a PIX charge.",
        body: {
          $ref: "CreatePaymentRequest#"
        },
        response: {
          201: {
            $ref: "CreatePaymentResponse#"
          },
          400: {
            $ref: "ErrorResponse#"
          }
        }
      }
    },
    createPaymentController
  );

  app.get(
    "/payments/:id",
    {
      schema: {
        tags: ["Payments"],
        summary: "Get payment",
        description: "Returns a payment by ID.",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: {
              type: "string",
              minLength: 1
            }
          }
        },
        response: {
          200: {
            $ref: "PaymentResponse#"
          },
          404: {
            $ref: "ErrorResponse#"
          }
        }
      }
    },
    getPaymentController
  );
}
