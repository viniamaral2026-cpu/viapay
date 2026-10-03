# VIAPAY API Contract

## Base

/api/v1

## Customers

GET /customers
POST /customers
GET /customers/{id}

## Accounts

GET /accounts
POST /accounts
GET /accounts/{id}
GET /accounts/{id}/transactions

## Payments

POST /payments
GET /payments/{id}
POST /payments/{id}/authorize
POST /payments/{id}/cancel

Header obrigatório:

Idempotency-Key

## Transfers

POST /transfers
GET /transfers/{id}

## Approvals

GET /approvals
POST /approvals/{id}/approve
POST /approvals/{id}/reject

## Settlement

GET /settlements
GET /settlements/{id}

## Reconciliation

GET /reconciliation
POST /reconciliation/run

## Audit

GET /audit/events
