
# API Guidelines

## Versionamento

```text
/api/v1
/api/v2
```

## Headers

```http
Authorization
Content-Type
Idempotency-Key
X-Correlation-ID
X-Request-ID
```

## Resposta

```json
{
  "data": {},
  "meta": {
    "request_id": "req_x"
  }
}
```

## Erros

```json
{
  "error": {
    "code": "PAYMENT_NOT_FOUND",
    "message": "Payment not found",
    "request_id": "req_x"
  }
}
```

## Princípios

* backward compatibility;
* explicit contracts;
* idempotency;
* pagination;
* filtering;
* sorting;
* rate limits;
* consistent errors.
  EOF

# ------------------------------------------------------------------------------

# EVENTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/22-events/event-driven.md" <<'EOF'

# Event Driven Architecture

## Eventos

Exemplos:

```text
customer.created
account.created
payment.created
payment.authorized
payment.posted
payment.failed
payment.settled
payment.reconciled
approval.requested
approval.approved
approval.rejected
ledger.transaction.posted
```

## Event Envelope

```json
{
  "event_id": "evt_x",
  "event_type": "payment.settled",
  "version": 1,
  "occurred_at": "2026-01-01T00:00:00Z",
  "tenant_id": "tenant_x",
  "correlation_id": "cor_x",
  "data": {}
}
```

## Outbox

Eventos financeiros devem utilizar transactional outbox quando necessário
para garantir consistência entre database e broker.
