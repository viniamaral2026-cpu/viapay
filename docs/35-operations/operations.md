
# Operations

## Rotinas

* monitoring;
* settlement;
* reconciliation;
* incident management;
* support;
* compliance review.

## Daily Operations

O operador deve visualizar:

* pagamentos pendentes;
* settlements;
* divergências;
* falhas;
* approvals;
* alertas.

## Operational Control

Operações críticas devem possuir:

* maker/checker;
* segregação;
* evidência;
* auditoria.
  EOF

# ------------------------------------------------------------------------------

# DR

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/36-disaster-recovery/disaster-recovery.md" <<'EOF'

# Disaster Recovery

## Objetivo

Restaurar o serviço após falha grave.

## RPO

RPO deve ser definido conforme criticidade.

## RTO

RTO deve ser definido conforme serviço.

## Componentes críticos

* PostgreSQL;
* ledger;
* message broker;
* secrets;
* object storage;
* audit logs.

## Backups

Backups devem ser:

* automatizados;
* criptografados;
* testados;
* versionados;
* protegidos contra exclusão acidental.

## Restore

Restore deve ser testado periodicamente.
