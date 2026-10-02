import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { buildApp } from "../app.js";

describe("Payments API", () => {
  const app = buildApp();

  beforeAll(async () => {
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  it("GET /health deve retornar 200", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/health"
    });

    expect(response.statusCode).toBe(200);

    expect(response.json()).toEqual({
      status: "ok",
      service: "viapay-api"
    });
  });

  it("POST /payments deve criar pagamento", async () => {
    const response = await app.inject({
      method: "POST",
      url: "/payments",
      payload: {
        amountBRL: 49.90,
        merchantWallet: "merchant_wallet_123"
      }
    });

    expect(response.statusCode).toBe(201);

    const body = response.json();

    expect(body.paymentId).toMatch(/^payment_/);
    expect(body.status).toBe("PIX_PENDING");
    expect(body.pixChargeId).toMatch(/^pix_payment_/);
    expect(body.qrCode).toContain("VIAPAY-PIX-");
    expect(body.expiresAt).toBeTypeOf("string");
  });

  it("GET /payments/:id deve retornar pagamento existente", async () => {
    const createResponse = await app.inject({
      method: "POST",
      url: "/payments",
      payload: {
        amountBRL: 99.90,
        merchantWallet: "merchant_wallet_test"
      }
    });

    expect(createResponse.statusCode).toBe(201);

    const created = createResponse.json();

    const response = await app.inject({
      method: "GET",
      url: `/payments/${created.paymentId}`
    });

    expect(response.statusCode).toBe(200);

    expect(response.json()).toMatchObject({
      id: created.paymentId,
      amountBRL: 99.9,
      merchantWallet: "merchant_wallet_test",
      status: "PIX_PENDING"
    });
  });

  it("GET /payments/:id deve retornar 404 quando não existe", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/payments/payment_not_found"
    });

    expect(response.statusCode).toBe(404);

    expect(response.json()).toEqual({
      error: "PAYMENT_NOT_FOUND",
      message: "Payment not found"
    });
  });

  it("POST /payments deve rejeitar valor inválido", async () => {
    const response = await app.inject({
      method: "POST",
      url: "/payments",
      payload: {
        amountBRL: 0,
        merchantWallet: "merchant_wallet_123"
      }
    });

    expect(response.statusCode).toBe(400);
  });

  it("POST /payments deve rejeitar merchant wallet vazia", async () => {
    const response = await app.inject({
      method: "POST",
      url: "/payments",
      payload: {
        amountBRL: 49.90,
        merchantWallet: ""
      }
    });

    expect(response.statusCode).toBe(400);
  });
});
