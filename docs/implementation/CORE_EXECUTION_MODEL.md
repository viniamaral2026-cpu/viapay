# ViaPay — Core Execution Model

## Objetivo

O ViaPay é uma infraestrutura de pagamentos e financial orchestration
destinada a instituições financeiras, bancos, fintechs e entidades
governamentais.

O produto não depende de um único rail.

O Core deve abstrair:

- PIX
- Bank Transfer
- Card
- Open Banking
- FX Provider
- Liquidity Provider
- Blockchain / DLT
- Stablecoin rails
- Cross-border providers
- Settlement providers

## Fluxo

Client
-> Payment Intent
-> Compliance
-> Authorization
-> Payment Core
-> Payment Router
-> Selected Rail
-> Ledger
-> Settlement
-> Reconciliation
-> Webhook

## Princípios

- Double-entry ledger
- Idempotency
- Immutable financial events
- Audit trail
- RBAC
- ABAC
- MFA
- Approval workflows
- Correlation ID
- Distributed tracing
- Reconciliation
- Provider adapters
- Sandbox first

## Regra

O domínio nunca deve depender diretamente de:

- banco específico
- provider específico
- blockchain específica
- FX provider específico

Esses componentes devem ser adapters.

