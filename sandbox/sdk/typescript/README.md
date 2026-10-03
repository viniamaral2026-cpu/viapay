# ViaPay TypeScript SDK — Sandbox

O SDK deve permitir que um desenvolvedor teste a integração
sem implementar diretamente HTTP.

Exemplo conceitual:

const viaPay = new ViaPay({
  apiKey: process.env.VIAPAY_SANDBOX_API_KEY,
  environment: "sandbox"
});

const payment = await viaPay.paymentIntents.create({
  merchantId: "mrc_sandbox_000001",
  amount: "109.00",
  currency: "BRL"
});

await viaPay.paymentIntents.simulate(payment.id, {
  scenario: "success"
});

const status = await viaPay.paymentIntents.get(payment.id);

console.log(status);
