# ViaPay

<p align="center">
  <img src="./docs/assets/viapay-logo.svg" alt="ViaPay" width="180">
</p>

<p align="center">
  <strong>Payment Settlement Infrastructure</strong>
</p>

<p align="center">
  Infraestrutura tecnológica para pagamentos, processamento, roteamento,
  liquidação, integração com parceiros financeiros e settlement digital.
</p>

<p align="center">

![Status](https://img.shields.io/badge/status-active%20development-2563EB)
![Architecture](https://img.shields.io/badge/architecture-modular-06B6D4)
![Frontend](https://img.shields.io/badge/frontend-Next.js-000000)
![Runtime](https://img.shields.io/badge/runtime-Node.js-339933)
![TypeScript](https://img.shields.io/badge/language-TypeScript-3178C6)
![PostgreSQL](https://img.shields.io/badge/database-PostgreSQL-4169E1)
![Redis](https://img.shields.io/badge/cache-Redis-DC382D)
![RabbitMQ](https://img.shields.io/badge/messaging-RabbitMQ-FF6600)
![Docker](https://img.shields.io/badge/container-Docker-2496ED)

</p>

---

# 1. Visão geral

O ViaPay é uma plataforma de infraestrutura financeira e de pagamentos projetada para conectar:

```text
┌─────────────────────┐
│ Cliente / Consumidor│
└──────────┬──────────┘
           │
           │ Pix
           ▼
┌─────────────────────┐
│       ViaPay        │
│ Payment Platform    │
└──────────┬──────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
   Router       FX
     │           │
     └─────┬─────┘
           │
           ▼
      Settlement
           │
           ▼
      USDC / Asset
           │
           ▼
        Solana
           │
           ▼
┌─────────────────────┐
│ Carteira do Lojista │
└─────────────────────┘
````

A plataforma tem como objetivo oferecer uma camada tecnológica capaz de abstrair a complexidade operacional existente entre:

* aplicações;
* comerciantes;
* sistemas de pagamento;
* bancos;
* instituições financeiras;
* provedores de liquidez;
* provedores FX;
* sistemas de settlement;
* infraestrutura blockchain;
* APIs;
* webhooks;
* sistemas de compliance;
* sistemas de reconciliação.

O ViaPay não deve ser entendido apenas como um checkout.

Seu objetivo arquitetural é funcionar como uma **camada de payment infrastructure e settlement orchestration**.

---

# 2. Propósito

O propósito do ViaPay é criar uma infraestrutura tecnológica moderna para processamento financeiro, permitindo que instituições e empresas integrem pagamentos através de APIs e operem seus fluxos através de interfaces especializadas.

A plataforma foi concebida para separar claramente:

```text
APLICAÇÃO
     │
     ▼
API / SDK
     │
     ▼
PAYMENT ORCHESTRATION
     │
     ├──────────────┐
     ▼              ▼
 PAYMENT          ROUTER
     │              │
     └──────┬───────┘
            ▼
          FX
            │
            ▼
       SETTLEMENT
            │
            ▼
       RECONCILIATION
            │
            ▼
         LEDGER
```

---

# 3. Problema que o ViaPay resolve

Sistemas financeiros modernos normalmente precisam integrar múltiplos componentes:

```text
Merchant
   │
   ├── Payment Provider
   ├── Bank
   ├── FX Provider
   ├── Liquidity Provider
   ├── Compliance
   ├── Blockchain
   ├── Wallet
   ├── Webhooks
   ├── Reconciliation
   └── Reporting
```

Sem uma camada de orquestração, cada aplicação precisa implementar individualmente:

* autenticação;
* credenciais;
* idempotência;
* criação de pagamentos;
* consulta de status;
* webhooks;
* retries;
* reconciliação;
* FX;
* settlement;
* auditoria;
* segurança;
* observabilidade.

O ViaPay procura centralizar essas responsabilidades.

---

# 4. Modelo operacional

## 4.1 Fluxo principal

O fluxo conceitual principal é:

```text
┌───────────────┐
│ Cliente       │
└───────┬───────┘
        │
        │ QR Code / Pix
        ▼
┌───────────────┐
│ ViaPay        │
│ Checkout      │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Payment Core  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Payment Router│
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ FX / Treasury │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Settlement    │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Blockchain    │
│ / Wallet      │
└───────────────┘
```

---

# 5. Ecossistema

O ViaPay foi pensado para quatro atores principais.

## Cliente / Consumidor

Responsável por iniciar o pagamento.

```text
QR Code
   ↓
Pix
   ↓
Confirmação
```

## Comerciante / Lojista

Responsável por receber pagamentos e administrar sua operação.

```text
Cadastro
   ↓
Empresa
   ↓
Carteira
   ↓
Configuração
   ↓
Dashboard
   ↓
Pagamentos
   ↓
Liquidações
```

## Desenvolvedor

Responsável por integrar o ViaPay à aplicação.

```text
Cadastro
   ↓
API Keys
   ↓
Sandbox
   ↓
Documentação
   ↓
Integração
   ↓
Payment API
   ↓
Webhooks
   ↓
Production
```

## Instituição / Operador

Responsável pela infraestrutura operacional.

```text
Customers
Payments
Ledger
FX
Liquidity
Settlement
Reconciliation
Risk
Compliance
Audit
Users
Roles
Approvals
```

---

# 6. Arquitetura

A arquitetura segue uma abordagem modular, com separação entre domínio, aplicação, infraestrutura e interfaces.

```text
                         ┌─────────────────────┐
                         │      Clients        │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │       API / SDK     │
                         └──────────┬──────────┘
                                    │
                         ┌──────────▼──────────┐
                         │ Payment Gateway     │
                         │ / Orchestrator      │
                         └──────────┬──────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
     Payments                    Router                      FX
          │                         │                         │
          └─────────────────────────┼─────────────────────────┘
                                    │
                                    ▼
                              Settlement
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
                 Ledger      Reconciliation     Treasury
                    │
                    ▼
                Audit Log
```

---

# 7. Monorepo

O projeto utiliza uma estrutura de monorepo.

```text
viapay/
│
├── apps/
│   ├── api/
│   ├── bank-core/
│   ├── bank-core-api/
│   ├── bank-gateway/
│   ├── demo-store/
│   ├── web/
│   └── worker/
│
├── packages/
│   ├── application/
│   ├── contracts/
│   ├── domain/
│   ├── infrastructure/
│   ├── sdk/
│   └── shared/
│
├── sandbox/
│
├── docs/
│
├── scripts/
│
├── prisma/
│
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
└── README.md
```

---

# 8. Aplicações

## apps/web

Frontend institucional e experiência pública do ViaPay.

Responsabilidades:

* Home;
* apresentação;
* preços;
* empresa;
* contato;
* cadastro;
* login;
* documentação pública;
* experiência do comerciante;
* checkout;
* interfaces de integração.

Tecnologias:

```text
Next.js
React
TypeScript
Tailwind CSS
Lucide
Recharts
Zod
React Hook Form
```

---

## apps/bank-core

Interface operacional do Core Banking / Payment Operations.

Responsabilidades:

```text
Dashboard
Customers
Accounts
Payments
Transfers
Ledger
Accounting
Approvals
Audit
Compliance
Fraud
Risk
FX
Liquidity
Settlement
Reconciliation
Merchants
Users
Roles
Permissions
Integrations
Developer
Settings
```

O `bank-core` representa a camada operacional interna.

---

## apps/bank-core-api

API especializada para operações do Core.

Responsabilidades:

* autenticação;
* autorização;
* clientes;
* contas;
* pagamentos;
* ledger;
* aprovações;
* settlement;
* reconciliação;
* auditoria.

---

## apps/bank-gateway

Gateway responsável pela exposição e roteamento de integrações financeiras.

Conceitualmente:

```text
External Provider
       │
       ▼
Bank Gateway
       │
       ▼
Payment Router
       │
       ▼
Internal Core
```

---

## apps/api

API principal da plataforma.

Responsável por expor contratos de negócio para:

* merchants;
* developers;
* applications;
* payments;
* webhooks;
* API keys;
* sandbox;
* integrações.

---

## apps/worker

Processamento assíncrono.

Exemplos:

```text
Payment Processing
Webhook Delivery
Settlement
Reconciliation
Retry
Notifications
FX Processing
Blockchain Processing
```

---

## apps/demo-store

Aplicação demonstrativa para simular um comerciante integrado ao ViaPay.

Fluxo:

```text
Demo Store
    │
    ▼
ViaPay API
    │
    ▼
Payment
    │
    ▼
Webhook
    │
    ▼
Settlement
```

---

# 9. Packages

## @viapay/domain

Contém regras de domínio.

Exemplos:

```text
Payment
Ledger
Account
Customer
Merchant
Router
FX
Settlement
Reconciliation
```

O domínio não deve depender de frameworks de infraestrutura.

---

# 10. Payment Domain

Um pagamento deve possuir identidade própria e ciclo de vida controlado.

Exemplo conceitual:

```text
CREATED
   │
   ▼
PENDING
   │
   ▼
PROCESSING
   │
   ├───────────────┐
   ▼               ▼
CONFIRMED       FAILED
   │
   ▼
SETTLING
   │
   ▼
SETTLED
```

Estados possíveis:

```text
created
pending
processing
confirmed
failed
cancelled
expired
settling
settled
```

---

# 11. Idempotência

Operações financeiras não devem depender exclusivamente de retries cegos.

A API deverá trabalhar com chaves de idempotência.

Exemplo:

```http
POST /v1/payments
Idempotency-Key: 8c9e7d...
```

A mesma operação enviada novamente deve retornar o resultado da operação original em vez de criar uma segunda transação.

---

# 12. Ledger

O ledger é um dos componentes críticos da arquitetura.

O modelo recomendado é baseado em partidas dobradas.

```text
                 TRANSACTION
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
     DEBIT ENTRY             CREDIT ENTRY
          │                       │
          ▼                       ▼
     ACCOUNT A                ACCOUNT B
```

Regra fundamental:

```text
Σ Débitos = Σ Créditos
```

O ledger deve ser:

* auditável;
* imutável;
* consistente;
* reconciliável;
* identificável;
* rastreável.

---

# 13. Accounts

Contas representam entidades financeiras utilizadas pelo sistema.

Exemplos:

```text
Merchant Account
Customer Account
Settlement Account
Treasury Account
Fee Account
Clearing Account
Suspense Account
```

---

# 14. FX

A camada FX permite abstrair conversão de moedas e ativos.

Fluxo:

```text
BRL
 │
 ▼
FX Quote
 │
 ├── rate
 ├── spread
 ├── fee
 ├── expiration
 │
 ▼
Converted Amount
```

Um quote deve possuir:

```text
quote_id
base_currency
quote_currency
rate
spread
fee
expires_at
created_at
```

---

# 15. Settlement

Settlement representa a liquidação financeira.

Fluxo conceitual:

```text
Payment
   │
   ▼
Clearing
   │
   ▼
FX
   │
   ▼
Settlement
   │
   ▼
Destination Wallet
```

O sistema deve separar claramente:

```text
Payment
Settlement
Reconciliation
Ledger
```

Esses conceitos não devem ser tratados como uma única operação.

---

# 16. Reconciliation

Reconciliação compara registros de diferentes fontes.

```text
             ┌──────────────┐
             │ ViaPay Ledger│
             └──────┬───────┘
                    │
                    │
                    ▼
             ┌──────────────┐
             │ Reconciliation│
             └──────┬───────┘
                    │
                    ▼
             ┌──────────────┐
             │ Provider Data│
             └──────────────┘
```

Resultados possíveis:

```text
MATCHED
MISMATCH
MISSING_INTERNAL
MISSING_EXTERNAL
PENDING
MANUAL_REVIEW
```

---

# 17. Sandbox

O ViaPay possui uma área dedicada para desenvolvedores testarem integrações antes de acessar produção.

Fluxo:

```text
Developer
   │
   ▼
Create Account
   │
   ▼
Sandbox
   │
   ├── API Keys
   ├── Test Payments
   ├── Webhooks
   ├── Logs
   ├── Applications
   └── Documentation
   │
   ▼
Certification
   │
   ▼
Production
```

A sandbox não deve movimentar recursos financeiros reais.

---

# 18. Developer Platform

O desenvolvedor deve possuir acesso a:

```text
Applications
API Keys
Sandbox
Documentation
Webhooks
Logs
Certification
Production
```

Arquitetura:

```text
Developer
    │
    ▼
Application
    │
    ├── Client ID
    ├── Client Secret
    ├── API Keys
    └── Webhook Secret
```

---

# 19. Webhooks

Webhooks permitem comunicar eventos para sistemas externos.

Exemplo:

```json
{
  "event": "payment.confirmed",
  "id": "evt_123",
  "payment_id": "pay_123",
  "created_at": "2026-01-01T12:00:00Z"
}
```

Eventos:

```text
payment.created
payment.pending
payment.confirmed
payment.failed
payment.cancelled

settlement.created
settlement.processing
settlement.completed
settlement.failed

refund.created
refund.completed
```

A entrega deve possuir:

* retry;
* backoff;
* assinatura;
* timestamp;
* idempotência;
* logs;
* dead-letter handling.

---

# 20. API

A API deve seguir princípios REST e contratos versionados.

Base conceitual:

```text
/v1
```

Exemplos:

```http
POST /v1/payments
GET  /v1/payments/{id}

POST /v1/refunds
GET  /v1/refunds/{id}

GET  /v1/settlements
GET  /v1/settlements/{id}

GET  /v1/accounts/{id}

POST /v1/webhooks
GET  /v1/events
```

---

# 21. Segurança

A plataforma foi projetada considerando:

```text
Authentication
Authorization
RBAC
ABAC
MFA
API Keys
Secrets
Audit Logs
Idempotency
Rate Limiting
Encryption
Webhook Signing
Least Privilege
```

---

# 22. RBAC / ABAC

A autorização deve considerar:

```text
User
Role
Permission
Resource
Action
Context
```

Exemplo:

```text
Gerente
   │
   ├── visualizar pagamentos
   ├── aprovar settlement
   ├── visualizar ledger
   └── acessar auditoria
```

Enquanto:

```text
Operador
   │
   ├── visualizar pagamentos
   ├── criar operação
   └── sem autorização para settlement crítico
```

---

# 23. Alçadas

Operações sensíveis devem poder exigir aprovação.

Exemplo:

```text
Operação
   │
   ▼
Limite
   │
   ├── baixo → automático
   │
   ├── médio → operador
   │
   └── alto → gerente
```

Fluxo:

```text
REQUESTED
   │
   ▼
PENDING_APPROVAL
   │
   ├───────────────┐
   ▼               ▼
APPROVED        REJECTED
   │
   ▼
EXECUTED
```

---

# 24. Auditoria

Operações críticas devem produzir eventos de auditoria.

Exemplo:

```text
WHO
WHAT
WHEN
WHERE
RESOURCE
ACTION
RESULT
CORRELATION_ID
IP
USER_AGENT
```

Exemplo:

```text
User: usr_123
Action: APPROVE_SETTLEMENT
Resource: stl_123
Time: 2026-10-03T12:00:00Z
Result: APPROVED
```

---

# 25. Compliance

O sistema possui espaço arquitetural para módulos de compliance.

Exemplos:

```text
KYC
KYB
AML
Transaction Monitoring
Risk
Fraud
Sanctions Screening
Audit
Case Management
```

A implementação regulatória efetiva depende do modelo operacional, jurisdição, licenças, parceiros e requisitos legais aplicáveis.

---

# 26. Blockchain

O ViaPay possui uma camada arquitetural para integração blockchain.

Fluxo conceitual:

```text
BRL Payment
     │
     ▼
Payment Confirmation
     │
     ▼
Conversion
     │
     ▼
USDC
     │
     ▼
Solana
     │
     ▼
Merchant Wallet
```

A infraestrutura blockchain deve ser desacoplada do domínio de pagamentos.

Isso permite trocar:

```text
Blockchain Provider
RPC Provider
Custody Provider
Wallet Infrastructure
Liquidity Provider
```

sem alterar o domínio principal.

---

# 27. Observabilidade

A plataforma deve trabalhar com:

```text
Logs
Metrics
Tracing
Correlation IDs
Health Checks
Error Tracking
Audit Events
```

Fluxo:

```text
Request
   │
   ├── correlation_id
   │
   ▼
API
   │
   ▼
Application
   │
   ▼
Domain
   │
   ▼
Infrastructure
   │
   ▼
Observability
```

---

# 28. Resiliência

Componentes financeiros devem ser projetados para falhas.

Estratégias:

```text
Retry
Exponential Backoff
Circuit Breaker
Timeout
Idempotency
Dead Letter Queue
Outbox
Inbox
Reconciliation
Compensating Operations
```

---

# 29. Event-driven architecture

Operações assíncronas podem utilizar eventos.

Exemplo:

```text
PaymentConfirmed
       │
       ├──────────────► Notification
       │
       ├──────────────► Ledger
       │
       ├──────────────► Settlement
       │
       └──────────────► Analytics
```

---

# 30. Banco de dados

O PostgreSQL é utilizado como principal banco relacional da arquitetura.

Entidades esperadas:

```text
users
roles
permissions

customers
merchants
accounts

payments
payment_attempts
payment_events

ledger_accounts
ledger_transactions
ledger_entries

fx_quotes
fx_transactions

settlements
settlement_items

reconciliation_runs
reconciliation_items

api_keys
applications
webhooks
webhook_deliveries

audit_logs
risk_cases
compliance_cases
```

---

# 31. Redis

Redis pode ser utilizado para:

```text
Caching
Rate Limiting
Distributed Locks
Session State
Short-lived Data
Idempotency
Queues auxiliares
```

---

# 32. RabbitMQ

RabbitMQ pode ser utilizado para processamento assíncrono:

```text
Payment Events
Settlement Jobs
Webhook Delivery
Reconciliation
Notifications
Retry Queues
```

---

# 33. Docker

O ambiente pode ser executado através de containers.

Arquitetura local:

```text
┌──────────────────────────────────────┐
│              Docker                  │
│                                      │
│  ┌────────┐ ┌────────┐ ┌─────────┐ │
│  │  Web   │ │  API   │ │ Worker  │ │
│  └────────┘ └────────┘ └─────────┘ │
│                                      │
│  ┌──────────┐ ┌──────────┐           │
│  │PostgreSQL│ │  Redis   │           │
│  └──────────┘ └──────────┘           │
│                                      │
│  ┌──────────┐                         │
│  │ RabbitMQ │                         │
│  └──────────┘                         │
└──────────────────────────────────────┘
```

---

# 34. Frontend

O frontend utiliza:

```text
Next.js
React
TypeScript
Tailwind CSS
Lucide
Recharts
React Hook Form
Zod
```

Princípios:

* componentes reutilizáveis;
* acessibilidade;
* responsividade;
* tipagem forte;
* separação de responsabilidades;
* design system;
* estados de loading;
* estados de erro;
* estados vazios;
* feedback operacional.

---

# 35. Design System

A identidade visual segue:

```text
Primary Blue
#0B5FFF

Blue
#2563EB

Light Blue
#60A5FA

Cyan
#06B6D4

White
#FFFFFF
```

Diretriz visual:

```text
White-first
Blue institutional
Cyan accents
Large whitespace
Clear hierarchy
Enterprise UI
```

O sistema deve evitar interfaces excessivamente carregadas.

---

# 36. Principais interfaces

## Public Website

```text
Home
Como funciona
Empresa
Preços
Contato
Documentação
Login
Cadastro
```

## Merchant

```text
Dashboard
Pagamentos
Transações
Liquidações
Carteira
Configurações
Clientes
API
Webhooks
```

## Developer

```text
Applications
API Keys
Sandbox
Documentation
Logs
Webhooks
Certification
Production
```

## Bank / Operations

```text
Dashboard
Customers
Accounts
Payments
Transfers
Ledger
Accounting
FX
Liquidity
Settlement
Reconciliation
Risk
Fraud
Compliance
Audit
Approvals
Users
Roles
Permissions
Integrations
Settings
```

---

# 37. Fluxo do lojista

```text
┌──────────────┐
│    Cadastro  │
└──────┬───────┘
       ▼
┌──────────────┐
│    Empresa   │
└──────┬───────┘
       ▼
┌──────────────┐
│    Carteira  │
└──────┬───────┘
       ▼
┌──────────────┐
│ Configuração │
└──────┬───────┘
       ▼
┌──────────────┐
│  Dashboard   │
└──────┬───────┘
       ▼
┌──────────────┐
│  Pagamentos  │
└──────┬───────┘
       ▼
┌──────────────┐
│ Liquidação   │
└──────────────┘
```

---

# 38. Fluxo do desenvolvedor

```text
Cadastro
   │
   ▼
Application
   │
   ▼
API Credentials
   │
   ▼
Sandbox
   │
   ▼
Documentation
   │
   ▼
Integration
   │
   ▼
Webhook
   │
   ▼
Certification
   │
   ▼
Production
```

---

# 39. Fluxo de pagamento

```text
Create Payment
      │
      ▼
Payment ID
      │
      ▼
QR Code
      │
      ▼
Pix Payment
      │
      ▼
Provider Confirmation
      │
      ▼
Payment Confirmed
      │
      ▼
FX
      │
      ▼
USDC
      │
      ▼
Settlement
      │
      ▼
Solana
      │
      ▼
Merchant Wallet
```

---

# 40. Estados de operação

```text
                     ┌──────────┐
                     │ CREATED  │
                     └────┬─────┘
                          │
                          ▼
                     ┌──────────┐
                     │ PENDING  │
                     └────┬─────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  PROCESSING  │
                   └──────┬───────┘
                          │
               ┌──────────┴──────────┐
               ▼                     ▼
        ┌─────────────┐       ┌─────────────┐
        │  CONFIRMED  │       │    FAILED   │
        └──────┬──────┘       └─────────────┘
               │
               ▼
        ┌─────────────┐
        │  SETTLING   │
        └──────┬──────┘
               │
               ▼
        ┌─────────────┐
        │   SETTLED   │
        └─────────────┘
```

---

# 41. Qualidade de software

O projeto deve seguir:

```text
Clean Architecture
DDD
SOLID
Clean Code
API First
Contract First
Event Driven Architecture
Result Pattern
Dependency Inversion
Separation of Concerns
```

---

# 42. Testes

Estratégia:

```text
Unit Tests
Integration Tests
Contract Tests
API Tests
E2E Tests
Security Tests
Load Tests
Reconciliation Tests
Idempotency Tests
```

Testes críticos:

```text
Payment Creation
Duplicate Payment
Payment Confirmation
Ledger Balance
Settlement
Reconciliation
Webhook Retry
Authorization
Approval
API Authentication
```

---

# 43. CI/CD

Pipeline esperado:

```text
Developer
    │
    ▼
Git Push
    │
    ▼
Lint
    │
    ▼
Typecheck
    │
    ▼
Unit Tests
    │
    ▼
Integration Tests
    │
    ▼
Build
    │
    ▼
Security Scan
    │
    ▼
Deploy
```

---

# 44. Git workflow

Branches recomendadas:

```text
main
develop
feature/*
fix/*
refactor/*
hotfix/*
```

Commits:

```text
feat:
fix:
refactor:
docs:
test:
chore:
security:
```

Exemplo:

```text
feat(payments): add idempotent payment creation
```

---

# 45. Desenvolvimento local

Requisitos:

```text
Node.js
pnpm
Git
Docker
PostgreSQL
Redis
RabbitMQ
```

Verificar:

```bash
node --version
pnpm --version
git --version
docker --version
```

Instalar dependências:

```bash
pnpm install
```

Executar frontend:

```bash
pnpm --filter web dev
```

Frontend:

```text
http://localhost:3000
```

---

# 46. Build

Executar:

```bash
pnpm build
```

Typecheck:

```bash
pnpm typecheck
```

Lint:

```bash
pnpm lint
```

Testes:

```bash
pnpm test
```

---

# 47. Sandbox

O ambiente sandbox deve permitir simular:

```text
Payment Created
Payment Pending
Payment Confirmed
Payment Failed
Webhook
Settlement
Settlement Failed
Refund
```

Nenhum fluxo sandbox deve ser interpretado como movimentação financeira real.

---

# 48. Documentação

A documentação deve ser dividida em:

```text
docs/
│
├── architecture/
├── api/
├── domain/
├── security/
├── compliance/
├── payments/
├── settlement/
├── reconciliation/
├── fx/
├── blockchain/
├── sandbox/
├── developer/
├── operations/
├── runbooks/
└── adr/
```

---

# 49. Architecture Decision Records

Decisões arquiteturais devem ser documentadas através de ADR.

Exemplo:

```text
ADR-001 — Monorepo Architecture
ADR-002 — Payment Domain
ADR-003 — Double Entry Ledger
ADR-004 — Idempotency
ADR-005 — Event Driven Processing
ADR-006 — Settlement Architecture
ADR-007 — Blockchain Abstraction
ADR-008 — API Versioning
ADR-009 — Authentication
ADR-010 — Authorization
```

---

# 50. Segurança de credenciais

Nunca versionar:

```text
.env
.env.local
API Keys
Private Keys
Wallet Secrets
Database Passwords
JWT Secrets
Webhook Secrets
```

Utilizar:

```text
.env.example
Secret Manager
Vault
Cloud Secret Manager
```

---

# 51. Princípio fundamental

O ViaPay deve separar:

```text
PRESENTATION
      │
APPLICATION
      │
DOMAIN
      │
INFRASTRUCTURE
```

Dependências devem apontar para dentro.

```text
Infrastructure ──────► Application
                           │
                           ▼
                         Domain
```

O domínio não deve depender diretamente de:

```text
Next.js
PostgreSQL
Redis
RabbitMQ
Solana
Provider
HTTP
```

Essas dependências devem ser abstraídas.

---

# 52. Status do projeto

O projeto está em desenvolvimento ativo.

É fundamental distinguir:

### Implementado

Componentes, interfaces, contratos e estruturas existentes no repositório.

### Sandbox

Funcionalidades destinadas à simulação e desenvolvimento.

### Em implementação

Componentes que possuem estrutura inicial, mas ainda precisam de integração completa.

### Planejado

Funcionalidades arquiteturalmente previstas, mas que ainda dependem de implementação, parceiros, infraestrutura ou requisitos regulatórios.

O status técnico real deve sempre ser confirmado pelo código, testes e ambiente de execução.

---

# 53. Roadmap

```text
PHASE 01
Foundation
████████████████████

PHASE 02
Payment Core
████████████████░░░░

PHASE 03
Ledger
██████████████░░░░░░

PHASE 04
Settlement
██████████░░░░░░░░░░

PHASE 05
FX
████████░░░░░░░░░░░░

PHASE 06
Blockchain
██████░░░░░░░░░░░░░░

PHASE 07
Compliance
████░░░░░░░░░░░░░░░░

PHASE 08
Production
██░░░░░░░░░░░░░░░░░░
```

---

# 54. Objetivo de produção

Antes de qualquer operação financeira real, o ViaPay deve possuir:

```text
[ ] Production infrastructure
[ ] Real payment providers
[ ] Banking relationships
[ ] FX providers
[ ] Liquidity providers
[ ] Compliance processes
[ ] KYC/KYB
[ ] AML
[ ] Risk engine
[ ] Security review
[ ] Penetration testing
[ ] Disaster recovery
[ ] Backup strategy
[ ] Observability
[ ] Reconciliation
[ ] Operational runbooks
[ ] Legal/regulatory validation
[ ] Production certification
```

---

# 55. Princípios de engenharia

O ViaPay deve seguir cinco princípios fundamentais:

```text
1. MONEY MUST BE TRACEABLE

Toda operação financeira deve ser rastreável.

2. STATE MUST BE EXPLICIT

Estados financeiros não devem depender de inferências.

3. OPERATIONS MUST BE IDEMPOTENT

Retries não podem criar operações duplicadas.

4. LEDGER MUST BE CONSISTENT

Débitos e créditos devem permanecer consistentes.

5. EVERYTHING CRITICAL MUST BE AUDITABLE

Operações críticas devem produzir evidências.
```

---

# 56. Visão final

O objetivo do ViaPay é evoluir de uma plataforma de pagamentos para uma infraestrutura modular capaz de conectar:

```text
                    ┌──────────────┐
                    │   MERCHANT   │
                    └──────┬───────┘
                           │
                           ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    BANKS     │────►│    VIAPAY    │◄────│   PROVIDERS  │
└──────────────┘     └──────┬───────┘     └──────────────┘
                             │
             ┌───────────────┼───────────────┐
             ▼               ▼               ▼
          PAYMENTS          FX           LIQUIDITY
             │               │               │
             └───────────────┼───────────────┘
                             ▼
                        SETTLEMENT
                             │
             ┌───────────────┼───────────────┐
             ▼               ▼               ▼
          LEDGER       RECONCILIATION      AUDIT
             │
             ▼
        DIGITAL ASSETS
             │
             ▼
          BLOCKCHAIN
             │
             ▼
        MERCHANT WALLET
```

---

# 57. Disclaimer técnico

O ViaPay é um projeto de infraestrutura tecnológica em desenvolvimento.

A existência de componentes de pagamento, settlement, FX, blockchain ou compliance no código não significa, por si só, autorização para operar como instituição financeira, instituição de pagamento, emissor de moeda eletrônica, provedor de ativos virtuais ou qualquer outra atividade regulada.

A entrada em produção deve depender de:

* análise jurídica;
* requisitos regulatórios;
* contratos com parceiros;
* licenciamento aplicável;
* políticas de compliance;
* segurança;
* certificações;
* controles operacionais;
* homologação;
* auditoria.

---

# 58. Licença

A licença definitiva do projeto deve ser definida conforme o modelo empresarial e de propriedade intelectual do ViaPay.

---

# ViaPay

<p align="center">
<strong>Payment Settlement Infrastructure</strong>
</p>

<p align="center">
Construindo uma camada moderna de infraestrutura para pagamentos,
liquidação e integração financeira.
</p>

<p align="center">
<sub>Engineering-first financial infrastructure.</sub>
</p>
---

# Propósito do ViaPay

O ViaPay nasceu de um problema concreto da infraestrutura global de pagamentos:

> Em muitos países, não existe uma experiência de pagamento instantâneo equivalente àquela proporcionada pelo Pix no Brasil, e transferências financeiras podem envolver múltiplos intermediários, diferentes sistemas, conversões cambiais e processos de liquidação que aumentam a complexidade e o tempo da operação.

O ViaPay foi concebido para construir uma infraestrutura capaz de conectar pagamentos locais à infraestrutura financeira global, buscando proporcionar uma experiência rápida, rastreável, segura e eficiente.

No Brasil, o Pix pode funcionar como um dos trilhos de entrada da operação. A infraestrutura ViaPay atua na camada de processamento e orquestração, podendo coordenar pagamento, ledger, FX, liquidez, compliance, settlement e reconciliation.

Em determinados fluxos internacionais, ativos digitais como USDC podem ser utilizados como mecanismo tecnológico de liquidação, quando permitido pelo produto, pelos parceiros envolvidos e pela legislação aplicável.

O propósito do ViaPay não é substituir sistemas nacionais de pagamento.

É construir uma camada tecnológica capaz de conectar diferentes sistemas financeiros, instituições, moedas, provedores de liquidez e redes de liquidação.

### Visão

**Conectar pagamentos locais à infraestrutura financeira global com velocidade, segurança, rastreabilidade e eficiência.**

### Princípio

**Payment Processing · Payment Orchestration · FX · Liquidity · Settlement · Reconciliation · Financial Infrastructure**

O ViaPay foi projetado para transformar fluxos financeiros complexos em operações tecnológicas estruturadas, auditáveis, interoperáveis e preparadas para integração institucional.

---

## Desenvolvido por

**2026 DEEVO Soluções Financeiras LTDA**  


Todos os direitos reservados.

ViaPay é uma plataforma de infraestrutura tecnológica para pagamentos, processamento, orquestração, liquidação e integração financeira.

**© 2026 DEEVO Soluções Financeiras LTDA — CNPJ: 63.187.175/0001-70. Todos os direitos reservados.**

