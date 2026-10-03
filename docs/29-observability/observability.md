
# Observability

## Três pilares

* logs;
* metrics;
* traces.

## OpenTelemetry

Todos os serviços devem propagar:

* trace_id;
* span_id;
* correlation_id.

## Métricas

Exemplos:

```text
payments_total
payments_failed_total
payment_processing_latency
settlement_success_total
settlement_failure_total
reconciliation_unmatched_total
ledger_posting_latency
api_error_rate
```

## Alertas

Alertar para:

* aumento de falhas;
* divergência de reconciliation;
* settlement atrasado;
* indisponibilidade de provider;
* aumento de latência;
* erros de autenticação;
* comportamento anômalo.
  EOF

# ------------------------------------------------------------------------------

# TESTING

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/30-testing/testing-strategy.md" <<'EOF'

# Testing Strategy

## Unit

Testar:

* regras de domínio;
* value objects;
* state machines;
* ledger;
* FX;
* approval.

## Integration

Testar:

* PostgreSQL;
* Redis;
* RabbitMQ;
* providers;
* adapters.

## Contract

Validar contratos entre:

* API;
* frontend;
* bancos;
* PSPs;
* webhooks.

## E2E

Fluxos:

```text
Customer
→ Account
→ Payment
→ Approval
→ Ledger
→ Settlement
→ Reconciliation
```

## Financial tests

Obrigatórios:

* double-entry invariant;
* idempotency;
* duplicate prevention;
* reversal;
* concurrent payment;
* race conditions;
* rounding;
* FX precision.
  EOF

# ------------------------------------------------------------------------------

# DEVOPS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/31-devops/devops.md" <<'EOF'

# DevOps

## Pipeline

```text
Commit
 ↓
Lint
 ↓
Typecheck
 ↓
Unit Tests
 ↓
Security Scan
 ↓
Build
 ↓
Integration Tests
 ↓
Contract Tests
 ↓
Container Build
 ↓
Deploy
```

## Ambientes

* development;
* test;
* staging;
* production.

## Segredos

Devem ser gerenciados por secret manager apropriado.

## Deploy

Preferir:

* immutable artifacts;
* rolling deployment;
* blue/green;
* canary quando aplicável.

## Rollback

Todo deploy deve possuir estratégia de rollback.
