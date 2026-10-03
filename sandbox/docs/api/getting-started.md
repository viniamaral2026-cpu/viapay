# Getting Started

## 1. Criar conta

O desenvolvedor cria uma conta no Developer Portal.

## 2. Criar aplicação

Cada aplicação deve possuir:

- application_id
- name
- environment
- scopes
- webhook endpoint

## 3. Criar credenciais

O sistema fornece:

client_id
client_secret

ou API Key conforme o modelo de autenticação.

## 4. Criar Merchant

O desenvolvedor pode criar um merchant de teste.

## 5. Criar Payment Intent

Exemplo:

POST /api/v1/sandbox/payment-intents

Request:

{
  "merchant_id": "mrc_sandbox_001",
  "amount": "109.00",
  "currency": "BRL",
  "description": "Test payment"
}

Response:

{
  "id": "pi_sandbox_001",
  "status": "AWAITING_PAYMENT",
  "amount": "109.00",
  "currency": "BRL",
  "environment": "sandbox"
}

## 6. Simular pagamento

POST /api/v1/sandbox/payment-intents/pi_sandbox_001/simulate

Request:

{
  "scenario": "success"
}

## 7. Consultar

GET /api/v1/sandbox/payment-intents/pi_sandbox_001

## 8. Webhook

O Sandbox envia:

payment.detected

payment.confirmed

payment.failed

payment.expired
