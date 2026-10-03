import Fastify from "fastify";

const app = Fastify({
  logger: true,
});

app.get("/health", async () => ({
  service: "viapay-bank-gateway",
  status: "healthy",
}));

app.post("/v1/payments", async (request) => ({
  status: "ACCEPTED",
  adapter: "configured-by-bank",
  request: request.body,
}));

app.listen({
  port: Number(process.env.PORT ?? 4020),
  host: "0.0.0.0",
});
