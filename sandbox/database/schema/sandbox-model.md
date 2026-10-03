# Sandbox Data Model

Entidades:

Application

ApiCredential

Customer

Merchant

Account

PaymentIntent

Transaction

LedgerTransaction

LedgerEntry

Transfer

FxQuote

Settlement

WebhookEvent

ReconciliationCase

AuditLog

TestScenario

## Relações

Merchant
  |
  +--- Customer
  |
  +--- Account
  |
  +--- PaymentIntent
           |
           +--- Transaction
           |
           +--- LedgerTransaction
           |
           +--- Settlement

WebhookEvent relaciona-se através de event_id e aggregate_id.

Todas as entidades financeiras devem possuir:

id
environment
created_at
updated_at
