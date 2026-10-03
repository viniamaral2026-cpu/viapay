# Sandbox API Endpoints

## Applications

POST /api/v1/sandbox/applications
GET /api/v1/sandbox/applications
GET /api/v1/sandbox/applications/{id}
DELETE /api/v1/sandbox/applications/{id}

## API Keys

POST /api/v1/sandbox/api-keys
GET /api/v1/sandbox/api-keys
DELETE /api/v1/sandbox/api-keys/{id}

## Customers

POST /api/v1/sandbox/customers
GET /api/v1/sandbox/customers/{id}

## Merchants

POST /api/v1/sandbox/merchants
GET /api/v1/sandbox/merchants/{id}

## Accounts

POST /api/v1/sandbox/accounts
GET /api/v1/sandbox/accounts/{id}
GET /api/v1/sandbox/accounts/{id}/balance

## Payments

POST /api/v1/sandbox/payment-intents
GET /api/v1/sandbox/payment-intents/{id}

POST /api/v1/sandbox/payment-intents/{id}/simulate

POST /api/v1/sandbox/payment-intents/{id}/confirm

POST /api/v1/sandbox/payment-intents/{id}/cancel

## Transfers

POST /api/v1/sandbox/transfers
GET /api/v1/sandbox/transfers/{id}

POST /api/v1/sandbox/transfers/{id}/simulate

## FX

POST /api/v1/sandbox/fx/quotes
GET /api/v1/sandbox/fx/quotes/{id}

POST /api/v1/sandbox/fx/quotes/{id}/lock

POST /api/v1/sandbox/fx/quotes/{id}/execute

## Settlement

POST /api/v1/sandbox/settlements
GET /api/v1/sandbox/settlements/{id}

POST /api/v1/sandbox/settlements/{id}/simulate

## Webhooks

POST /api/v1/sandbox/webhooks/test
GET /api/v1/sandbox/webhooks
GET /api/v1/sandbox/webhooks/{id}

## Blockchain simulation

POST /api/v1/sandbox/crypto/payment-intents

GET /api/v1/sandbox/crypto/payment-intents/{id}

POST /api/v1/sandbox/crypto/payment-intents/{id}/simulate

GET /api/v1/sandbox/crypto/transactions/{signature}
