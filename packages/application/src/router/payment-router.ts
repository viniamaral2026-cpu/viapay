import type {
  PaymentIntent,
  PaymentRail,
} from "../../../domain/src/payment/payment.types";

import type {
  PaymentRoute,
  PaymentRouter,
} from "../../../domain/src/router/router.types";

const routes: Record<PaymentRail, PaymentRoute> = {
  SANDBOX: {
    rail: "SANDBOX",
    provider: "viapay-sandbox",
    priority: 1,
    enabled: true,
  },

  PIX: {
    rail: "PIX",
    provider: "bank-pix-adapter",
    priority: 10,
    enabled: true,
  },

  BANK: {
    rail: "BANK",
    provider: "bank-transfer-adapter",
    priority: 20,
    enabled: true,
  },

  CARD: {
    rail: "CARD",
    provider: "card-adapter",
    priority: 30,
    enabled: true,
  },

  THUNES: {
    rail: "THUNES",
    provider: "thunes-adapter",
    priority: 40,
    enabled: true,
  },

  SOLANA: {
    rail: "SOLANA",
    provider: "solana-adapter",
    priority: 50,
    enabled: true,
  },

  BLOCKCHAIN: {
    rail: "BLOCKCHAIN",
    provider: "blockchain-adapter",
    priority: 60,
    enabled: true,
  },
};

export class DefaultPaymentRouter implements PaymentRouter {
  async resolve(payment: PaymentIntent): Promise<PaymentRoute> {
    const route = routes[payment.rail];

    if (!route || !route.enabled) {
      throw new Error(`No payment route available for ${payment.rail}`);
    }

    return route;
  }
}
