# ViaPay Developer Sandbox

## Visão

O ViaPay Developer Sandbox é um ambiente isolado para que
comerciantes, desenvolvedores, bancos, instituições financeiras
e parceiros possam desenvolver e testar integrações com o ViaPay
antes de solicitar acesso ao ambiente de produção.

O Sandbox NÃO movimenta dinheiro real.

Nenhuma operação executada neste ambiente deve produzir
liquidação financeira real.

## Objetivos

O ambiente permite testar:

- Payments
- Payment Intents
- Transfers
- Accounts
- Customers
- Merchants
- FX
- Settlement
- Reconciliation
- Webhooks
- Idempotency
- Errors
- Authentication
- Authorization
- SDK
- QR Code
- Blockchain payment simulation
- Stablecoin payment simulation

## Ambientes

Development:

    DEV

Sandbox:

    SANDBOX

Staging:

    STAGING

Production:

    PRODUCTION

Cada ambiente deve possuir credenciais, banco, filas,
webhooks e configurações separados.

## Regra principal

Sandbox nunca deve compartilhar credenciais de produção.

Sandbox nunca deve acessar bancos de produção.

Sandbox nunca deve possuir capacidade de liquidar dinheiro real.

## Fluxo

Developer
    |
    v
Developer Portal
    |
    v
Sandbox API
    |
    +--> Payment Simulator
    +--> FX Simulator
    +--> Webhook Simulator
    +--> Settlement Simulator
    +--> Reconciliation Simulator
    |
    v
Test Ledger

## Status

Este módulo deve ser considerado:

DESIGNED / IN DEVELOPMENT

até que todos os componentes estejam implementados,
testados e integrados ao backend real do ViaPay.
