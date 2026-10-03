# VIAPAY Banking Infrastructure

## Arquitetura

O projeto possui quatro camadas principais:

1. Bank Core Frontend
2. Bank Core API
3. Bank Gateway
4. VIAPAY Payment Infrastructure

## Frontend

apps/bank-core

## Backend

apps/bank-core-api

## Gateway

apps/bank-gateway

## Integrações

integrations/banking

## Segurança

- RBAC
- ABAC
- MFA
- maker-checker
- approval engine
- audit trail
- idempotency
- correlation IDs

## Financeiro

- accounts
- ledger
- double-entry
- payments
- transfers
- settlement
- reconciliation
- FX

## Mainframe

- COBOL
- CICS
- IBM MQ
- DB2

## Regra arquitetural

Frontend nunca acessa diretamente o Core Banking.

Frontend
→ API
→ Domain
→ Gateway
→ Adapter
→ Banco

## Importante

Adapters reais de banco precisam ser implementados com os contratos, credenciais, schemas, ambientes de homologação e especificações fornecidas pela instituição financeira.
