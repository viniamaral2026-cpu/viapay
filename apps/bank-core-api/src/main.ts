import Fastify from "fastify";

const app = Fastify({
  logger: true,
});

app.get("/health", async () => ({
  service: "viapay-bank-core-api",
  status: "healthy",
  version: "0.1.0",
}));

app.get("/api/v1/accounts/:id", async (request) => {
  const { id } = request.params as { id: string };

  return {
    id,
    status: "ACTIVE",
    message: "Account contract ready",
  };
});

app.post("/api/v1/payments", async (request) => {
  const body = request.body;

  return {
    status: "PENDING",
    message: "Payment command accepted",
    request: body,
  };
});

app.get("/api/v1/ledger/health", async () => ({
  ledger: "available",
  doubleEntry: true,
  immutableEntries: true,
}));

app.listen({
  port: Number(process.env.PORT ?? 4010),
  host: "0.0.0.0",
});
