
# Database Architecture

## PostgreSQL

Banco principal recomendado para dados transacionais.

## Principais entidades

```text
tenants
organizations
users
customers
accounts
ledger_transactions
ledger_entries
payments
payment_attempts
fx_quotes
settlements
reconciliation_cases
approval_requests
audit_events
webhook_deliveries
idempotency_keys
```

## Constraints

O banco deve proteger invariantes importantes através de:

* foreign keys;
* unique constraints;
* check constraints;
* indexes;
* transactions.

## Migrations

Toda alteração de schema deve possuir migration versionada.
