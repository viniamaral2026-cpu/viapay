
# Governance

## Mudanças críticas

Mudanças em:

* ledger;
* settlement;
* FX;
* limites;
* permissions;
* security;
* compliance;

devem possuir processo de aprovação.

## Configuration as Data

Parâmetros críticos devem ser versionados e auditados.

## Change Management

Cada mudança deve possuir:

* autor;
* motivo;
* revisão;
* testes;
* aprovação;
* rollout;
* rollback.
  EOF

# ------------------------------------------------------------------------------

# ADRs

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/40-adr/0001-api-first.md" <<'EOF'

# ADR 0001 — API First

## Status

Accepted

## Contexto

Instituições podem possuir diferentes canais e sistemas internos.

## Decisão

A plataforma terá API como contrato primário.

## Consequências

Frontend, SDK e integrações utilizarão os mesmos contratos de domínio.

Isso reduz acoplamento entre interface e infraestrutura.
