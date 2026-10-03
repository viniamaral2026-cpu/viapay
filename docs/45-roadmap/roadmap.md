
# Product Roadmap

## Phase 0 — Foundation

* repository;
* CI;
* documentation;
* coding standards;
* architecture;
* observability base.

## Phase 1 — Identity

* tenants;
* organizations;
* users;
* roles;
* permissions;
* MFA.

## Phase 2 — Customer

* customer;
* KYB;
* KYC;
* accounts.

## Phase 3 — Ledger

* double-entry;
* transactions;
* balances;
* statements;
* reversals.

## Phase 4 — Payments

* payment API;
* idempotency;
* state machine;
* approval.

## Phase 5 — Settlement

* provider adapters;
* settlement;
* retries;
* confirmation.

## Phase 6 — Reconciliation

* matching;
* exception management;
* reports.

## Phase 7 — FX

* quote;
* conversion;
* spread;
* fees.

## Phase 8 — Cross Border

* multi-currency;
* international routing;
* compliance;
* settlement.

## Phase 9 — Blockchain

* adapter;
* wallet integration;
* transaction monitoring;
* confirmation.

## Phase 10 — Enterprise

* COBOL;
* mainframe;
* MQ;
* SFTP;
* enterprise SSO;
* HSM;
* advanced audit.

## Phase 11 — Scale

* multi-region;
* disaster recovery;
* advanced observability;
* performance engineering.
  EOF

# ------------------------------------------------------------------------------

# GLOSSARY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/46-glossary/glossary.md" <<'EOF'

# Glossary

## Account

Conta utilizada para registrar posição financeira.

## Ledger

Livro contábil transacional.

## Double Entry

Método em que débitos e créditos devem permanecer balanceados.

## Payment

Instrução de pagamento.

## Settlement

Liquidação efetiva através de um rail externo.

## Reconciliation

Processo de comparação entre registros internos e externos.

## FX

Foreign Exchange, conversão cambial.

## Rail

Infraestrutura utilizada para transportar/liquidar uma transação.

## PSP

Payment Service Provider.

## RBAC

Role Based Access Control.

## ABAC

Attribute Based Access Control.

## MFA

Multi-Factor Authentication.

## Idempotency

Capacidade de processar uma mesma requisição repetida sem produzir
duplicidade financeira.

## Correlation ID

Identificador utilizado para rastrear uma operação entre serviços.

## COBOL

Linguagem historicamente utilizada em sistemas corporativos e mainframes,
inclusive em sistemas bancários legados.

## Adapter

Componente que conecta uma interface externa ao modelo interno.

## Anti-Corruption Layer

Camada que impede que modelos externos contaminem o domínio interno.
