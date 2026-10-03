#!/usr/bin/env bash

# ==============================================================================
# VIA PAY / DEEVO
# CORE BANKING & PAYMENT INFRASTRUCTURE
# DOCUMENTATION BOOTSTRAP
#
# Objetivo:
#   Criar uma base documental técnica, arquitetural e operacional completa para
#   uma plataforma de infraestrutura de pagamentos/core banking.
#
# Princípio:
#   NÃO apagar, sobrescrever ou destruir arquivos existentes.
#
# Uso:
#   chmod +x bootstrap-documentacao-core.sh
#   ./bootstrap-documentacao-core.sh
#
# Compatibilidade:
#   Linux / Ubuntu / macOS / WSL
# ==============================================================================

set -Eeuo pipefail

ROOT="$(pwd)"
DOCS="$ROOT/docs"

echo ""
echo "======================================================================"
echo " VIA PAY / DEEVO - DOCUMENTATION BOOTSTRAP"
echo "======================================================================"
echo ""
echo "Diretório:"
echo "  $ROOT"
echo ""

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

mkdir_safe() {
    mkdir -p "$1"
}

write_if_missing() {
    local file="$1"
    shift

    if [[ -f "$file" ]]; then
        echo "[EXISTE]  $file"
        return 0
    fi

    mkdir -p "$(dirname "$file")"

    cat > "$file"

    echo "[CRIADO]  $file"
}

# ------------------------------------------------------------------------------
# Estrutura documental
# ------------------------------------------------------------------------------

echo "[INFO] Criando estrutura documental..."

mkdir_safe "$DOCS/00-overview"
mkdir_safe "$DOCS/01-product"
mkdir_safe "$DOCS/02-architecture"
mkdir_safe "$DOCS/03-domain"
mkdir_safe "$DOCS/04-financial"
mkdir_safe "$DOCS/05-ledger"
mkdir_safe "$DOCS/06-payments"
mkdir_safe "$DOCS/07-cross-border"
mkdir_safe "$DOCS/08-fx"
mkdir_safe "$DOCS/09-settlement"
mkdir_safe "$DOCS/10-reconciliation"
mkdir_safe "$DOCS/11-accounts"
mkdir_safe "$DOCS/12-customers"
mkdir_safe "$DOCS/13-security"
mkdir_safe "$DOCS/14-identity-access"
mkdir_safe "$DOCS/15-rbac-abac"
mkdir_safe "$DOCS/16-approvals"
mkdir_safe "$DOCS/17-mfa"
mkdir_safe "$DOCS/18-audit"
mkdir_safe "$DOCS/19-compliance"
mkdir_safe "$DOCS/20-risk"
mkdir_safe "$DOCS/21-api"
mkdir_safe "$DOCS/22-events"
mkdir_safe "$DOCS/23-integrations"
mkdir_safe "$DOCS/24-legacy"
mkdir_safe "$DOCS/25-cobol"
mkdir_safe "$DOCS/26-blockchain"
mkdir_safe "$DOCS/27-solana"
mkdir_safe "$DOCS/28-webhooks"
mkdir_safe "$DOCS/29-observability"
mkdir_safe "$DOCS/30-testing"
mkdir_safe "$DOCS/31-devops"
mkdir_safe "$DOCS/32-database"
mkdir_safe "$DOCS/33-frontend"
mkdir_safe "$DOCS/34-backoffice"
mkdir_safe "$DOCS/35-operations"
mkdir_safe "$DOCS/36-disaster-recovery"
mkdir_safe "$DOCS/37-performance"
mkdir_safe "$DOCS/38-privacy"
mkdir_safe "$DOCS/39-governance"
mkdir_safe "$DOCS/40-adr"
mkdir_safe "$DOCS/41-runbooks"
mkdir_safe "$DOCS/42-api-contracts"
mkdir_safe "$DOCS/43-schemas"
mkdir_safe "$DOCS/44-diagrams"
mkdir_safe "$DOCS/45-roadmap"
mkdir_safe "$DOCS/46-glossary"

# ------------------------------------------------------------------------------
# Índice principal
# ------------------------------------------------------------------------------

write_if_missing "$DOCS/README.md" <<'EOF'
# VIA PAY / DEEVO — Documentação Técnica

## 1. Visão

Este diretório contém a documentação técnica, arquitetural, operacional,
financeira e de segurança da plataforma de infraestrutura de pagamentos
desenvolvida pela DEEVO.

O nome "Via Pay" representa o produto/projeto utilizado durante a fase de
desenvolvimento. A arquitetura foi desenhada para permitir operação como
infraestrutura tecnológica white-label para bancos, instituições financeiras,
PSPs, fintechs, governos e demais participantes autorizados.

A plataforma não deve assumir automaticamente o papel jurídico de instituição
financeira, banco, instituição de pagamento ou participante de sistema de
pagamentos. O papel operacional e regulatório depende da jurisdição,
licenciamento, contratos e modelo de integração adotado.

## 2. Princípios arquiteturais

- API First
- Domain Driven Design
- Clean Architecture
- Hexagonal Architecture
- SOLID
- Event Driven Architecture
- Idempotência
- Double-entry ledger
- Imutabilidade financeira
- Auditabilidade
- Least privilege
- Zero Trust
- Defense in depth
- Observabilidade
- Alta disponibilidade
- Disaster Recovery
- Segurança por padrão
- Separação entre domínio e infraestrutura

## 3. Macroarquitetura

```text
                         ┌─────────────────────┐
                         │ Banco / Governo     │
                         │ Fintech / PSP       │
                         └──────────┬──────────┘
                                    │
                              API / SDK / UI
                                    │
                         ┌──────────▼──────────┐
                         │ API Gateway / BFF   │
                         └──────────┬──────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
       ┌──────▼──────┐       ┌──────▼──────┐       ┌──────▼──────┐
       │ Identity    │       │ Payments    │       │ Customers   │
       └──────┬──────┘       └──────┬──────┘       └──────┬──────┘
              │                     │                     │
              └─────────────────────┼─────────────────────┘
                                    │
                         ┌──────────▼──────────┐
                         │ Transaction Engine  │
                         └──────────┬──────────┘
                                    │
                         ┌──────────▼──────────┐
                         │ Double Entry Ledger │
                         └──────────┬──────────┘
                                    │
                 ┌──────────────────┼──────────────────┐
                 │                  │                  │
          ┌──────▼─────┐    ┌──────▼─────┐    ┌──────▼─────┐
          │ Settlement │    │ Reconcile   │    │ Audit      │
          └────────────┘    └─────────────┘    └────────────┘
                 │
       ┌─────────┼─────────┐
       │         │         │
     Bank      PSP      Blockchain
````

## 4. Domínios principais

* Identity
* Customer
* Organization
* Account
* Ledger
* Transaction
* Payment
* FX
* Cross Border
* Settlement
* Reconciliation
* Risk
* Compliance
* Audit
* Integration
* Blockchain
* Administration

## 5. Regra financeira fundamental

Nenhuma transação financeira deve alterar saldo diretamente.

O saldo deve ser consequência dos lançamentos no ledger.

Exemplo:

```text
Conta A
Débito: 100 BRL

Conta B
Crédito: 100 BRL
```

Os lançamentos precisam fechar em:

```text
Total Débitos = Total Créditos
```

## 6. Fonte da verdade

O ledger é a fonte contábil transacional.

Caches, projeções, dashboards e saldos materializados são derivados.

## 7. Segurança

Toda operação sensível deve possuir:

* autenticação;
* autorização;
* contexto da organização;
* identificação do operador;
* correlation ID;
* idempotency key quando aplicável;
* auditoria;
* política de alçada;
* evidência de aprovação;
* timestamp;
* origem;
* resultado.

## 8. Documentos

A documentação está organizada por domínio para permitir evolução independente.

Cada novo módulo deve obrigatoriamente possuir:

1. visão funcional;
2. modelo de domínio;
3. contratos de API;
4. eventos;
5. regras de segurança;
6. testes;
7. observabilidade;
8. runbook operacional;
9. ADR quando houver decisão arquitetural relevante.
   EOF

# ------------------------------------------------------------------------------

# OVERVIEW

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/00-overview/system-overview.md" <<'EOF'

# System Overview

## Objetivo

A plataforma fornece infraestrutura tecnológica para processamento,
orquestração, registro e liquidação de pagamentos.

O sistema foi projetado para ser utilizado por instituições que desejem
integrar capacidades de pagamentos por API, SDK, interface web ou integração
com sistemas legados.

## Características

* multi-tenant;
* multi-moeda;
* multi-país;
* multi-instituição;
* API-first;
* ledger de dupla entrada;
* pagamentos síncronos e assíncronos;
* settlement;
* reconciliation;
* FX;
* webhooks;
* eventos;
* RBAC/ABAC;
* MFA;
* auditoria;
* integração bancária;
* integração com sistemas legados;
* integração opcional com blockchain.

## Não objetivos

A plataforma não assume por padrão:

* custódia de ativos;
* emissão de moeda;
* autorização regulatória;
* substituição de banco central;
* substituição automática de infraestrutura nacional de pagamentos.

Essas capacidades dependem do modelo jurídico, regulatório e técnico da
implementação final.
EOF

write_if_missing "$DOCS/00-overview/project-scope.md" <<'EOF'

# Project Scope

## Escopo

O projeto contempla uma infraestrutura tecnológica capaz de conectar:

* clientes;
* bancos;
* fintechs;
* PSPs;
* lojistas;
* sistemas de pagamento;
* sistemas legados;
* provedores de câmbio;
* redes blockchain;
* provedores de liquidação.

## Objetivo comercial

O objetivo principal é fornecer tecnologia white-label.

A instituição contratante pode manter sua marca, seus usuários, seus sistemas
de relacionamento e sua infraestrutura operacional, utilizando a plataforma
como camada tecnológica.

## Modelo

```text
Instituição
     │
     ├── Frontend próprio
     ├── Aplicativo próprio
     ├── Core Banking existente
     │
     ▼
Via Pay / DEEVO
     │
     ├── API
     ├── SDK
     ├── Ledger
     ├── Payment Engine
     ├── FX
     ├── Settlement
     └── Reconciliation
```

## Modelo de integração

A plataforma deve permitir:

* API;
* SDK;
* iframe quando apropriado;
* componentes embutíveis;
* webhooks;
* eventos;
* arquivos;
* mensageria;
* adapters para sistemas legados.
  EOF

# ------------------------------------------------------------------------------

# PRODUCT

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/01-product/product-requirements.md" <<'EOF'

# Product Requirements Document

## Problema

Sistemas financeiros frequentemente possuem infraestrutura fragmentada entre
core banking, processadores, adquirentes, bancos correspondentes, sistemas
legados e provedores internacionais.

Essa fragmentação aumenta:

* custo de integração;
* tempo de desenvolvimento;
* risco operacional;
* dificuldade de auditoria;
* duplicação de regras;
* complexidade de reconciliation.

## Solução

Criar uma camada tecnológica padronizada de pagamentos que possa ser
integrada aos sistemas existentes.

## Usuários

### Instituições

* bancos;
* fintechs;
* PSPs;
* financeiras;
* empresas de tecnologia financeira;
* instituições públicas autorizadas.

### Operadores

* administrador;
* operador financeiro;
* gerente;
* compliance;
* auditor;
* suporte;
* desenvolvedor;
* analista de reconciliation.

### Clientes finais

* pessoa física;
* pessoa jurídica;
* lojista;
* marketplace;
* empresa.

## Capacidades

### Core

* customer;
* account;
* ledger;
* transaction;
* payment.

### Financeiro

* FX;
* fee;
* tax;
* settlement;
* reconciliation.

### Segurança

* RBAC;
* ABAC;
* MFA;
* audit;
* approval workflow.

### Integrações

* APIs bancárias;
* sistemas legados;
* COBOL;
* blockchain;
* Solana;
* provedores FX;
* sistemas nacionais de pagamento.

## Requisitos não funcionais

* alta disponibilidade;
* baixa latência;
* rastreabilidade;
* idempotência;
* consistência financeira;
* segurança;
* observabilidade;
* recuperação de desastre;
* escalabilidade horizontal.
  EOF

# ------------------------------------------------------------------------------

# ARCHITECTURE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/02-architecture/architecture.md" <<'EOF'

# Architecture

## Arquitetura

A plataforma utiliza arquitetura hexagonal.

```text
                DOMAIN
                  │
        ┌─────────┴─────────┐
        │                   │
 Application             Ports
        │                   │
        └─────────┬─────────┘
                  │
             Adapters
                  │
      ┌───────────┼────────────┐
      │           │            │
 PostgreSQL     Bank        Blockchain
```

## Camadas

### Domain

Contém:

* entidades;
* value objects;
* aggregates;
* domain services;
* domain events;
* regras financeiras.

Não deve conhecer:

* HTTP;
* PostgreSQL;
* Redis;
* RabbitMQ;
* SDK externo;
* framework.

### Application

Contém:

* use cases;
* commands;
* queries;
* DTOs;
* orchestration;
* transaction boundaries.

### Infrastructure

Contém:

* database;
* message broker;
* APIs externas;
* blockchain adapters;
* legacy adapters;
* observability.

### Presentation

Contém:

* REST;
* GraphQL quando necessário;
* webhooks;
* SDK;
* controllers.

## Princípio

O domínio financeiro nunca deve depender diretamente de um provedor externo.

Provedores são adapters.

## Exemplo

```text
PaymentService
      │
      ▼
SettlementPort
      │
      ├── BankSettlementAdapter
      ├── PSPSettlementAdapter
      └── BlockchainSettlementAdapter
```

EOF

write_if_missing "$DOCS/02-architecture/hexagonal-architecture.md" <<'EOF'

# Hexagonal Architecture

## Objetivo

Permitir que o núcleo financeiro permaneça independente de tecnologia externa.

## Ports

Exemplos:

* AccountRepository
* LedgerRepository
* PaymentProvider
* FXProvider
* SettlementProvider
* IdentityProvider
* BlockchainProvider
* LegacyBankingProvider

## Adapters

Implementações possíveis:

* PostgreSQLAccountRepository;
* BancoXPaymentAdapter;
* PSPPaymentAdapter;
* SolanaSettlementAdapter;
* LegacyCobolAdapter.

## Benefício

Um banco pode trocar o provedor externo sem alterar as regras do domínio.

## Regra

Nenhum adapter deve implementar regra financeira de negócio que pertença ao
domínio.
EOF

write_if_missing "$DOCS/02-architecture/multi-tenancy.md" <<'EOF'

# Multi-Tenancy

## Modelo

A plataforma deve suportar múltiplas instituições.

Cada requisição autenticada deve possuir um tenant context.

```text
TenantContext
├── tenant_id
├── organization_id
├── actor_id
├── roles
├── permissions
├── scopes
└── correlation_id
```

## Isolamento

Todas as entidades tenant-aware devem possuir:

```text
tenant_id
```

A aplicação deve impedir acesso cruzado entre tenants.

## Estratégias

### Shared database

Mais simples e eficiente inicialmente.

### Schema per tenant

Maior isolamento, maior custo operacional.

### Database per tenant

Maior isolamento e custo.

A estratégia final deve considerar requisitos regulatórios e volume.
EOF

# ------------------------------------------------------------------------------

# DOMAIN

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/03-domain/domain-model.md" <<'EOF'

# Domain Model

## Bounded Contexts

### Identity

Responsável por:

* usuários;
* autenticação;
* MFA;
* sessões;
* credenciais.

### Customer

Responsável por:

* pessoas;
* empresas;
* KYC;
* dados cadastrais.

### Account

Responsável por:

* contas;
* status;
* moeda;
* titularidade.

### Ledger

Responsável por:

* lançamentos;
* partidas;
* saldos;
* períodos.

### Payments

Responsável por:

* instruções;
* processamento;
* estados;
* idempotência.

### Settlement

Responsável por:

* liquidação;
* batches;
* provedores;
* confirmação.

### Reconciliation

Responsável por:

* matching;
* divergências;
* ajustes;
* fechamento.

## Agregados

Principais aggregates:

* Customer;
* Account;
* Payment;
* LedgerTransaction;
* SettlementBatch;
* ReconciliationCase;
* ApprovalRequest.
  EOF

# ------------------------------------------------------------------------------

# FINANCIAL

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/04-financial/financial-model.md" <<'EOF'

# Financial Model

## Princípio

O sistema financeiro deve separar:

1. intenção de pagamento;
2. autorização;
3. movimentação;
4. contabilização;
5. liquidação;
6. reconciliação.

## Estados

```text
CREATED
   ↓
AUTHORIZED
   ↓
PROCESSING
   ↓
POSTED
   ↓
SETTLED
   ↓
RECONCILED
```

Estados de erro:

```text
FAILED
REVERSED
CANCELLED
EXPIRED
```

## Regra

Uma transação POSTED não deve ser apagada.

Correções devem ocorrer por meio de novas transações compensatórias.
EOF

# ------------------------------------------------------------------------------

# LEDGER

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/05-ledger/double-entry-ledger.md" <<'EOF'

# Double Entry Ledger

## Objetivo

Garantir consistência contábil transacional.

Toda transação financeira possui pelo menos duas partidas.

Exemplo:

Cliente compra produto por 109 BRL.

```text
Débito
Cliente:       -109 BRL

Crédito
Lojista:       +109 BRL
```

Se existir taxa:

```text
Débito
Cliente:       -109 BRL

Crédito
Lojista:       +106 BRL

Crédito
Conta de fees: +3 BRL
```

## Invariantes

Para cada moeda:

```text
SUM(debits) = SUM(credits)
```

## Imutabilidade

Ledger entries são append-only.

Não devem ser:

* UPDATE;
* DELETE.

Correções são feitas por lançamentos compensatórios.

## Atomicidade

A criação de uma transação e suas partidas deve ocorrer dentro da mesma
transação do banco de dados.

## Precisão

Valores monetários não devem utilizar floating point.

Usar:

* integer em unidade mínima; ou
* DECIMAL com precisão explicitamente definida.

## Exemplo

```text
amount_minor = 10900
currency = BRL
```

representa:

```text
R$ 109,00
```

EOF

write_if_missing "$DOCS/05-ledger/ledger-invariants.md" <<'EOF'

# Ledger Invariants

1. Todo lançamento possui uma moeda.
2. Toda transação possui tenant.
3. Toda transação possui identificador único.
4. Toda transação possui timestamp.
5. Toda transação possui origem.
6. Débitos e créditos devem fechar.
7. Ledger é imutável.
8. Correção ocorre por compensação.
9. Nenhuma API externa pode alterar ledger diretamente.
10. Saldo derivado deve ser verificável contra o ledger.
11. Reprocessamento deve ser idempotente.
12. Eventos financeiros devem possuir correlation ID.
    EOF

# ------------------------------------------------------------------------------

# PAYMENTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/06-payments/payment-engine.md" <<'EOF'

# Payment Engine

## Responsabilidade

O Payment Engine orquestra a execução de uma instrução de pagamento.

Ele não deve assumir que o transporte financeiro é:

* banco;
* PIX;
* cartão;
* blockchain;
* transferência internacional.

Esses são mecanismos de settlement.

## Pipeline

```text
Create Payment
      ↓
Validate
      ↓
Risk
      ↓
Authorize
      ↓
Approval
      ↓
Quote FX
      ↓
Reserve
      ↓
Post Ledger
      ↓
Submit Settlement
      ↓
Receive Confirmation
      ↓
Reconcile
```

## Idempotência

Toda operação de criação deve aceitar:

```http
Idempotency-Key
```

A mesma chave não pode gerar duas operações financeiras.

## Payment ID

Exemplo:

```text
pay_01JXXXXXXXXXXXX
```

## Estados

```text
CREATED
AUTHORIZED
PENDING_APPROVAL
PROCESSING
POSTED
SETTLEMENT_PENDING
SETTLED
RECONCILED
FAILED
REVERSED
```

EOF

write_if_missing "$DOCS/06-payments/payment-state-machine.md" <<'EOF'

# Payment State Machine

## CREATED

Pagamento recebido.

## AUTHORIZED

Regras básicas aprovadas.

## PENDING_APPROVAL

Necessita aprovação conforme alçada.

## PROCESSING

Processamento iniciado.

## POSTED

Ledger contabilizado.

## SETTLEMENT_PENDING

Aguardando liquidação externa.

## SETTLED

Provedor confirmou liquidação.

## RECONCILED

Liquidação conciliada com registros externos.

## FAILED

Processamento falhou antes de conclusão.

## REVERSED

Uma transação anteriormente contabilizada foi compensada.

## Regras

Estados não podem ser alterados arbitrariamente.

Cada transição deve possuir:

* actor;
* timestamp;
* motivo;
* correlation ID;
* audit event.
  EOF

# ------------------------------------------------------------------------------

# CROSS BORDER

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/07-cross-border/cross-border-payments.md" <<'EOF'

# Cross-Border Payments

## Objetivo

Permitir que uma instrução originada em uma moeda possa ser liquidada em outra
moeda.

Exemplo conceitual:

```text
Cliente
USD
  │
  ▼
Payment API
  │
  ▼
FX Quote
  │
  ▼
Ledger
  │
  ▼
Settlement Network
  │
  ▼
Beneficiário
BRL
```

## Importante

O blockchain pode ser utilizado como rail de settlement, mas não deve ser
confundido com conversão cambial.

FX e settlement são responsabilidades distintas.

## Componentes

* FX provider;
* liquidity provider;
* payment provider;
* settlement provider;
* compliance;
* ledger;
* reconciliation.

## Resultado

O beneficiário recebe a moeda definida pela instituição e pelo contrato da
operação.
EOF

# ------------------------------------------------------------------------------

# FX

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/08-fx/fx-engine.md" <<'EOF'

# FX Engine

## Objetivo

Gerenciar cotações e conversões cambiais.

## Quote

Uma cotação deve possuir:

* quote_id;
* base_currency;
* quote_currency;
* rate;
* spread;
* fee;
* timestamp;
* expiration;
* provider;
* source.

## Exemplo

```text
USD → BRL

Market rate:
5.40

Spread:
0.02

Effective rate:
5.42
```

## Regras

Cotações expiram.

Não reutilizar cotação vencida.

## Auditoria

Registrar:

* cotação apresentada;
* cotação aceita;
* taxa aplicada;
* provider;
* horário;
* usuário;
* transaction ID.
  EOF

# ------------------------------------------------------------------------------

# SETTLEMENT

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/09-settlement/settlement.md" <<'EOF'

# Settlement

## Objetivo

Representar a liquidação efetiva de uma obrigação financeira.

## Settlement não é Ledger

Ledger registra obrigação e movimentação contábil.

Settlement confirma movimentação através de uma rede ou instituição externa.

## Fluxo

```text
Payment
  ↓
Ledger Posting
  ↓
Settlement Instruction
  ↓
Provider
  ↓
External Confirmation
  ↓
Settlement Record
  ↓
Reconciliation
```

## Providers

* banco;
* PSP;
* payment network;
* blockchain;
* liquidity provider.

## Idempotência

Settlement submissions devem possuir identificador externo e interno.

## Retry

Retries devem utilizar backoff e nunca criar duplicidade financeira.
EOF

# ------------------------------------------------------------------------------

# RECONCILIATION

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/10-reconciliation/reconciliation.md" <<'EOF'

# Reconciliation

## Objetivo

Comparar registros internos contra registros externos.

## Fontes

* ledger;
* settlement provider;
* banco;
* PSP;
* blockchain;
* arquivos de liquidação.

## Matching

Critérios:

* external_reference;
* transaction_id;
* amount;
* currency;
* date;
* account.

## Estados

```text
MATCHED
UNMATCHED_INTERNAL
UNMATCHED_EXTERNAL
AMOUNT_MISMATCH
CURRENCY_MISMATCH
DUPLICATE
MANUAL_REVIEW
RESOLVED
```

## Regra

Diferenças nunca devem ser simplesmente ignoradas.

Toda exceção deve possuir:

* caso;
* responsável;
* motivo;
* evidência;
* resolução;
* auditoria.
  EOF

# ------------------------------------------------------------------------------

# ACCOUNTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/11-accounts/accounts.md" <<'EOF'

# Accounts

## Tipos

* customer account;
* settlement account;
* fee account;
* suspense account;
* treasury account;
* clearing account.

## Estados

```text
PENDING
ACTIVE
BLOCKED
FROZEN
CLOSED
```

## Regras

Conta fechada não pode receber novas operações.

Conta bloqueada não pode iniciar determinadas operações.

Conta congelada deve seguir política de compliance.

## Multi-currency

Uma conta pode:

1. possuir uma moeda;
2. possuir subcontas por moeda.

A decisão deve ser definida pelo modelo regulatório e operacional da
instituição.
EOF

# ------------------------------------------------------------------------------

# CUSTOMERS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/12-customers/customers.md" <<'EOF'

# Customers

## Pessoa Física

Campos conceituais:

* customer_id;
* legal_name;
* document;
* country;
* date_of_birth;
* status;
* risk_profile.

## Pessoa Jurídica

Campos:

* organization_id;
* legal_name;
* tax_identifier;
* country;
* representatives;
* beneficial owners;
* risk_profile.

## KYC

O domínio deve permitir:

* pending;
* verified;
* rejected;
* review.

Documentos sensíveis devem possuir políticas específicas de retenção e acesso.
EOF

# ------------------------------------------------------------------------------

# SECURITY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/13-security/security-architecture.md" <<'EOF'

# Security Architecture

## Princípios

* Zero Trust;
* least privilege;
* defense in depth;
* secure by default;
* separation of duties.

## Controles

* MFA;
* RBAC;
* ABAC;
* rate limiting;
* encryption;
* secrets management;
* audit logs;
* session management;
* device controls;
* IP policies;
* anomaly detection.

## Dados

Dados sensíveis devem ser criptografados em trânsito e em repouso.

## Segredos

Nunca armazenar:

* API keys;
* passwords;
* private keys;
* signing secrets;

no código-fonte.
EOF

# ------------------------------------------------------------------------------

# IDENTITY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/14-identity-access/identity.md" <<'EOF'

# Identity and Access

## Authentication

Métodos possíveis:

* OIDC;
* OAuth2;
* SAML;
* MFA;
* hardware security key;
* service accounts.

## Service Account

Cada integração deve possuir identidade própria.

Nunca utilizar credencial compartilhada por vários serviços.

## Sessions

Sessões devem possuir:

* expiration;
* rotation;
* revocation;
* device context;
* audit trail.
  EOF

# ------------------------------------------------------------------------------

# RBAC ABAC

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/15-rbac-abac/rbac-abac.md" <<'EOF'

# RBAC / ABAC

## RBAC

Controle baseado em função.

Exemplos:

```text
SUPER_ADMIN
ADMIN
MANAGER
OPERATOR
COMPLIANCE
AUDITOR
SUPPORT
DEVELOPER
READ_ONLY
```

## ABAC

Controle baseado em atributos.

Exemplos:

* tenant;
* branch;
* country;
* transaction amount;
* currency;
* risk level;
* account;
* time;
* IP;
* device.

## Exemplo

Um operador pode iniciar pagamentos até determinado limite.

Um gerente pode aprovar operações dentro de sua alçada.

Um auditor pode visualizar registros, mas não alterá-los.

## Separation of Duties

A pessoa que cria uma operação de alto valor não deve necessariamente poder
aprová-la sozinha.
EOF

# ------------------------------------------------------------------------------

# APPROVAL

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/16-approvals/approval-workflow.md" <<'EOF'

# Approval Workflow

## Objetivo

Implementar alçadas financeiras e operacionais.

## Exemplo

```text
0 - 1.000
Operador

1.000 - 10.000
Gerente

10.000 - 100.000
Gerente + Diretor

100.000+
Múltiplas aprovações
```

Os valores acima são exemplos arquiteturais e devem ser configurados pela
instituição.

## Approval Request

Campos:

* approval_id;
* transaction_id;
* required_role;
* required_amount;
* actor;
* status;
* expires_at;
* approved_at;
* rejected_at.

## Estados

```text
PENDING
APPROVED
REJECTED
EXPIRED
CANCELLED
```

## Código de aprovação

Quando requerido, o código deve ser:

* temporário;
* de uso único;
* protegido contra brute force;
* auditado;
* vinculado ao contexto da operação.

Nunca armazenar o código em texto puro.
EOF

# ------------------------------------------------------------------------------

# MFA

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/17-mfa/mfa.md" <<'EOF'

# Multi-Factor Authentication

## Métodos

* TOTP;
* WebAuthn;
* passkey;
* hardware key;
* push;
* SMS apenas quando necessário e conforme política de risco.

## Operações de alto risco

Podem exigir step-up authentication.

Exemplos:

* alteração de alçada;
* criação de usuário administrador;
* alteração de conta bancária;
* criação de API key;
* pagamento acima de limite;
* alteração de configuração de settlement.

## Auditoria

Cada desafio MFA deve registrar:

* method;
* actor;
* timestamp;
* result;
* risk context.
  EOF

# ------------------------------------------------------------------------------

# AUDIT

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/18-audit/audit.md" <<'EOF'

# Audit

## Objetivo

Registrar ações relevantes do sistema.

## Evento

```json
{
  "audit_id": "aud_x",
  "tenant_id": "tenant_x",
  "actor_id": "user_x",
  "action": "PAYMENT_APPROVED",
  "resource_type": "payment",
  "resource_id": "pay_x",
  "timestamp": "2026-01-01T00:00:00Z",
  "ip": "masked",
  "result": "SUCCESS",
  "correlation_id": "cor_x"
}
```

## Imutabilidade

Logs financeiros e de segurança devem ser protegidos contra alteração.

## Retenção

A retenção deve obedecer:

* legislação;
* contratos;
* política interna;
* requisitos regulatórios.
  EOF

# ------------------------------------------------------------------------------

# COMPLIANCE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/19-compliance/compliance.md" <<'EOF'

# Compliance Architecture

## Objetivo

Disponibilizar controles técnicos para que a instituição implemente seus
requisitos regulatórios.

## Capacidades

* KYC;
* KYB;
* AML;
* sanctions screening;
* transaction monitoring;
* suspicious activity workflow;
* audit;
* retention;
* case management.

## Importante

A plataforma não deve afirmar automaticamente que uma operação é
"compliant". Ela fornece controles e evidências.

A avaliação jurídica e regulatória depende da jurisdição e da instituição
responsável.
EOF

# ------------------------------------------------------------------------------

# RISK

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/20-risk/risk-engine.md" <<'EOF'

# Risk Engine

## Objetivo

Classificar risco transacional.

## Sinais possíveis

* valor;
* frequência;
* país;
* moeda;
* dispositivo;
* IP;
* histórico;
* beneficiary;
* velocity;
* comportamento;
* blacklist;
* sanctions.

## Resultado

```text
ALLOW
REVIEW
BLOCK
```

## Decisão

Cada decisão deve ser explicável através dos sinais e regras aplicados.

Não registrar somente um score sem contexto.
EOF

# ------------------------------------------------------------------------------

# API

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/21-api/api-guidelines.md" <<'EOF'

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
EOF

# ------------------------------------------------------------------------------

# INTEGRATIONS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/23-integrations/integration-architecture.md" <<'EOF'

# Integration Architecture

## Adapters

A plataforma deve tratar integrações externas como adapters.

## Categorias

* banking;
* payment networks;
* FX;
* identity;
* compliance;
* blockchain;
* legacy;
* notification.

## Timeout

Toda chamada externa deve possuir timeout explícito.

## Retry

Retries devem ser:

* limitados;
* exponenciais;
* idempotentes.

## Circuit Breaker

Integrações críticas devem possuir circuit breaker.

## Fallback

Fallback nunca pode causar duplicidade financeira.
EOF

# ------------------------------------------------------------------------------

# LEGACY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/24-legacy/legacy-integration.md" <<'EOF'

# Legacy Integration

## Objetivo

Permitir integração com sistemas bancários existentes sem exigir substituição
imediata do core legado.

## Padrão

```text
Legacy Core
    │
    │ Adapter
    ▼
Integration Layer
    │
    ▼
Via Pay
```

## Estratégia

A plataforma deve suportar:

* REST;
* SOAP;
* MQ;
* files;
* SFTP;
* TCP;
* adapters proprietários.

## Anti-Corruption Layer

Sistemas legados não devem contaminar o modelo de domínio moderno.

O adapter converte:

```text
Legacy DTO
     ↓
Canonical DTO
     ↓
Domain Model
```

EOF

# ------------------------------------------------------------------------------

# COBOL

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/25-cobol/cobol-integration.md" <<'EOF'

# COBOL / Mainframe Integration

## Objetivo

Permitir integração com core banking tradicional.

A plataforma não precisa substituir COBOL.

Ela pode funcionar como camada moderna de APIs e orquestração.

## Arquitetura

```text
Bank Application
       │
       ▼
Modern API
       │
       ▼
Integration Adapter
       │
       ▼
MQ / CICS / API / File
       │
       ▼
COBOL Core
```

## Possíveis mecanismos

* CICS;
* IBM MQ;
* batch;
* VSAM;
* DB2;
* SOAP;
* REST gateway;
* arquivos estruturados.

## Regra

O modelo COBOL não deve ser exposto diretamente ao frontend.

Deve existir um contrato canônico.
EOF

# ------------------------------------------------------------------------------

# BLOCKCHAIN

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/26-blockchain/blockchain-architecture.md" <<'EOF'

# Blockchain Architecture

## Papel

Blockchain é um possível rail de settlement.

Não deve ser tratado como substituto universal de:

* banco;
* ledger;
* compliance;
* FX;
* sistema de pagamento nacional.

## Fluxo

```text
Payment
  ↓
Risk
  ↓
FX
  ↓
Ledger
  ↓
Blockchain Adapter
  ↓
Network
  ↓
Confirmation
  ↓
Settlement
  ↓
Reconciliation
```

## Custódia

A arquitetura deve suportar:

* custodial;
* non-custodial;
* institutional custody.

O modelo final depende do produto e da jurisdição.
EOF

# ------------------------------------------------------------------------------

# SOLANA

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/27-solana/solana-adapter.md" <<'EOF'

# Solana Adapter

## Objetivo

Disponibilizar uma integração desacoplada com a rede Solana quando utilizada
como rail de settlement.

## Interface conceitual

```text
BlockchainProvider

createTransfer()
getTransaction()
getBalance()
estimateFee()
waitConfirmation()
```

## Segurança

Chaves privadas nunca devem ficar:

* no frontend;
* em variáveis expostas;
* em logs;
* em bancos sem proteção adequada.

## Custódia

Para produção institucional, utilizar arquitetura apropriada de key
management/HSM/MPC conforme o modelo de custódia.

## Confirmação

Uma transação blockchain só deve ser marcada como settlement concluído após
cumprir a política de confirmação definida pelo sistema.
EOF

# ------------------------------------------------------------------------------

# WEBHOOKS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/28-webhooks/webhooks.md" <<'EOF'

# Webhooks

## Objetivo

Notificar sistemas externos sobre mudanças de estado.

## Eventos

```text
payment.created
payment.processing
payment.settled
payment.failed
payment.reconciled
```

## Segurança

Webhook deve possuir:

* assinatura;
* timestamp;
* replay protection;
* event ID.

## Receiver

O cliente deve responder rapidamente e processar de forma assíncrona.

## Retry

O provedor deve tentar novamente quando houver falha temporária.

Nunca assumir que um webhook será entregue apenas uma vez.
EOF

# ------------------------------------------------------------------------------

# OBSERVABILITY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/29-observability/observability.md" <<'EOF'

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
EOF

# ------------------------------------------------------------------------------

# DATABASE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/32-database/database.md" <<'EOF'

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
EOF

# ------------------------------------------------------------------------------

# FRONTEND

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/33-frontend/frontend-architecture.md" <<'EOF'

# Frontend Architecture

## Objetivo

Fornecer interface institucional para operadores financeiros.

## Princípios

* acessibilidade;
* consistência;
* segurança;
* baixa densidade cognitiva;
* feedback explícito;
* confirmação de ações críticas.

## Áreas

### Dashboard

* volume;
* liquidação;
* falhas;
* reconciliation;
* risco.

### Payments

* lista;
* detalhe;
* timeline;
* approval;
* settlement.

### Accounts

* contas;
* saldo;
* extrato;
* bloqueios.

### Operations

* settlement;
* reconciliation;
* exceptions.

### Security

* usuários;
* roles;
* permissions;
* MFA;
* audit.

## Ações críticas

Nunca devem ser executadas com um único clique sem confirmação adequada.
EOF

# ------------------------------------------------------------------------------

# BACKOFFICE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/34-backoffice/backoffice.md" <<'EOF'

# Backoffice

## Perfis

### Operator

Executa operações permitidas.

### Manager

Aprova operações dentro de alçada.

### Compliance

Analisa casos de risco e compliance.

### Auditor

Visualiza evidências.

### Administrator

Configura parâmetros administrativos.

## Princípio

Interface administrativa nunca deve ignorar as regras do backend.

Esconder um botão no frontend não é mecanismo de segurança.

Toda autorização deve ser validada no backend.
EOF

# ------------------------------------------------------------------------------

# OPERATIONS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/35-operations/operations.md" <<'EOF'

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
EOF

# ------------------------------------------------------------------------------

# PERFORMANCE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/37-performance/performance.md" <<'EOF'

# Performance

## Objetivo

Garantir previsibilidade de latência sem comprometer consistência financeira.

## Estratégias

* caching de dados não financeiros;
* connection pooling;
* async processing;
* queues;
* batching;
* indexes;
* read replicas;
* horizontal scaling.

## Regra

Não utilizar cache como fonte de verdade para saldo financeiro.

## Load Testing

Cenários:

* criação de pagamentos;
* consultas de saldo;
* webhooks;
* reconciliation;
* settlement batch.
  EOF

# ------------------------------------------------------------------------------

# PRIVACY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/38-privacy/privacy.md" <<'EOF'

# Privacy

## Princípios

* minimização;
* finalidade;
* necessidade;
* controle de acesso;
* retenção limitada;
* rastreabilidade.

## Dados sensíveis

Devem possuir:

* classificação;
* política de retenção;
* controle de acesso;
* criptografia;
* auditoria.

## LGPD

Para operações no Brasil, a arquitetura deve ser compatível com os princípios
da LGPD e com as responsabilidades atribuídas aos participantes da operação.

Requisitos jurídicos devem ser validados com profissionais especializados.
EOF

# ------------------------------------------------------------------------------

# GOVERNANCE

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/39-governance/governance.md" <<'EOF'

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
EOF

write_if_missing "$DOCS/40-adr/0002-double-entry-ledger.md" <<'EOF'

# ADR 0002 — Double Entry Ledger

## Status

Accepted

## Contexto

Operações financeiras precisam ser auditáveis e consistentes.

## Decisão

Utilizar ledger de dupla entrada.

## Consequências

Toda movimentação financeira possuirá partidas balanceadas.

Correções serão realizadas através de compensações.
EOF

write_if_missing "$DOCS/40-adr/0003-hexagonal-architecture.md" <<'EOF'

# ADR 0003 — Hexagonal Architecture

## Status

Accepted

## Decisão

O domínio não dependerá de frameworks ou provedores externos.

Adapters implementarão ports definidos pelo domínio/application layer.
EOF

write_if_missing "$DOCS/40-adr/0004-blockchain-as-settlement-rail.md" <<'EOF'

# ADR 0004 — Blockchain as Settlement Rail

## Status

Accepted

## Decisão

Blockchain será tratado como adapter/rail de settlement.

Não será considerado automaticamente substituto do ledger interno,
compliance, FX ou infraestrutura bancária.
EOF

write_if_missing "$DOCS/40-adr/0005-legacy-adapter.md" <<'EOF'

# ADR 0005 — Legacy Adapter

## Status

Accepted

## Decisão

Sistemas legados, incluindo COBOL/mainframe, serão integrados por adapters e
anti-corruption layers.

O domínio moderno não dependerá do modelo interno do legado.
EOF

# ------------------------------------------------------------------------------

# RUNBOOKS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/41-runbooks/payment-failure.md" <<'EOF'

# Runbook — Payment Failure

## Sintoma

Pagamento permanece FAILED ou PROCESSING acima do SLA.

## Diagnóstico

1. localizar payment_id;
2. consultar correlation_id;
3. verificar payment attempts;
4. verificar provider;
5. verificar ledger;
6. verificar settlement;
7. verificar reconciliation.

## Ações

Não repetir manualmente uma operação financeira sem verificar idempotência.

## Escalonamento

Se existir dúvida sobre duplicidade, bloquear novo processamento e abrir caso
operacional.
EOF

write_if_missing "$DOCS/41-runbooks/reconciliation-mismatch.md" <<'EOF'

# Runbook — Reconciliation Mismatch

## Procedimento

1. identificar external_reference;
2. localizar transação interna;
3. comparar valor;
4. comparar moeda;
5. comparar timestamp;
6. verificar duplicidade;
7. preservar evidências;
8. abrir reconciliation case.

## Regra

Nunca alterar ledger diretamente para "fazer bater".

A divergência deve ser resolvida através de fluxo controlado.
EOF

write_if_missing "$DOCS/41-runbooks/settlement-failure.md" <<'EOF'

# Runbook — Settlement Failure

## Diagnóstico

Verificar:

* provider;
* status;
* timeout;
* external reference;
* retry count;
* ledger state.

## Regra

Antes de retry:

```text
Confirmar se provider processou a operação.
```

Somente depois executar novo attempt com idempotência.
EOF

# ------------------------------------------------------------------------------

# API CONTRACTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/42-api-contracts/payment-api.md" <<'EOF'

# Payment API Contract

## Create Payment

```http
POST /api/v1/payments
Idempotency-Key: idem_123
```

### Request

```json
{
  "source_account_id": "acc_source",
  "destination_account_id": "acc_destination",
  "amount": {
    "value": 10900,
    "currency": "BRL"
  },
  "description": "Purchase",
  "metadata": {}
}
```

### Response

```json
{
  "data": {
    "id": "pay_123",
    "status": "CREATED"
  },
  "meta": {
    "request_id": "req_123"
  }
}
```

## Get Payment

```http
GET /api/v1/payments/{payment_id}
```

## Approve Payment

```http
POST /api/v1/payments/{payment_id}/approval
```

## Cancel Payment

```http
POST /api/v1/payments/{payment_id}/cancel
```

## Reversal

```http
POST /api/v1/payments/{payment_id}/reverse
```

EOF

write_if_missing "$DOCS/42-api-contracts/accounts-api.md" <<'EOF'

# Accounts API

## Create Account

```http
POST /api/v1/accounts
```

## Get Account

```http
GET /api/v1/accounts/{account_id}
```

## Balance

```http
GET /api/v1/accounts/{account_id}/balance
```

## Statement

```http
GET /api/v1/accounts/{account_id}/transactions
```

Saldo é uma projeção verificável contra o ledger.
EOF

write_if_missing "$DOCS/42-api-contracts/customers-api.md" <<'EOF'

# Customers API

## Create Customer

```http
POST /api/v1/customers
```

## Get Customer

```http
GET /api/v1/customers/{customer_id}
```

## KYC Status

```http
GET /api/v1/customers/{customer_id}/kyc
```

## Update

Alterações em dados críticos devem ser auditadas.
EOF

write_if_missing "$DOCS/42-api-contracts/settlement-api.md" <<'EOF'

# Settlement API

## Create Instruction

```http
POST /api/v1/settlements
```

## Status

```http
GET /api/v1/settlements/{settlement_id}
```

## Retry

```http
POST /api/v1/settlements/{settlement_id}/retry
```

Retry deve respeitar idempotência e política operacional.
EOF

# ------------------------------------------------------------------------------

# SCHEMAS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/43-schemas/payment.schema.json" <<'EOF'
{
"$schema": "[https://json-schema.org/draft/2020-12/schema](https://json-schema.org/draft/2020-12/schema)",
"$id": "[https://viapay.example/schemas/payment.json](https://viapay.example/schemas/payment.json)",
"title": "Payment",
"type": "object",
"required": [
"source_account_id",
"destination_account_id",
"amount"
],
"properties": {
"source_account_id": {
"type": "string"
},
"destination_account_id": {
"type": "string"
},
"amount": {
"type": "object",
"required": [
"value",
"currency"
],
"properties": {
"value": {
"type": "integer",
"minimum": 1
},
"currency": {
"type": "string",
"minLength": 3,
"maxLength": 3
}
}
}
}
}
EOF

write_if_missing "$DOCS/43-schemas/event.schema.json" <<'EOF'
{
"$schema": "[https://json-schema.org/draft/2020-12/schema](https://json-schema.org/draft/2020-12/schema)",
"$id": "[https://viapay.example/schemas/event.json](https://viapay.example/schemas/event.json)",
"title": "Event Envelope",
"type": "object",
"required": [
"event_id",
"event_type",
"version",
"occurred_at",
"tenant_id",
"correlation_id",
"data"
],
"properties": {
"event_id": {
"type": "string"
},
"event_type": {
"type": "string"
},
"version": {
"type": "integer"
},
"occurred_at": {
"type": "string",
"format": "date-time"
},
"tenant_id": {
"type": "string"
},
"correlation_id": {
"type": "string"
},
"data": {
"type": "object"
}
}
}
EOF

# ------------------------------------------------------------------------------

# DIAGRAMS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/44-diagrams/system.mmd" <<'EOF'
flowchart TB

```
CLIENT[Cliente]
BANK[Banco / Fintech / PSP]
API[API Gateway]
AUTH[Identity]
PAYMENT[Payment Engine]
RISK[Risk Engine]
FX[FX Engine]
LEDGER[Double Entry Ledger]
SETTLEMENT[Settlement Engine]
RECON[Reconciliation]
BANKADAPTER[Bank Adapter]
BLOCKCHAIN[Blockchain Adapter]
LEGACY[Legacy / COBOL Adapter]

CLIENT --> BANK
BANK --> API
API --> AUTH
API --> PAYMENT
PAYMENT --> RISK
PAYMENT --> FX
PAYMENT --> LEDGER
LEDGER --> SETTLEMENT
SETTLEMENT --> BANKADAPTER
SETTLEMENT --> BLOCKCHAIN
BANKADAPTER --> LEGACY
SETTLEMENT --> RECON
LEDGER --> RECON
```

EOF

write_if_missing "$DOCS/44-diagrams/payment-sequence.mmd" <<'EOF'
sequenceDiagram

```
participant Client
participant API
participant Payment
participant Risk
participant Ledger
participant Settlement
participant Provider

Client->>API: Create Payment
API->>Payment: Validate
Payment->>Risk: Evaluate
Risk-->>Payment: ALLOW
Payment->>Ledger: Post Transaction
Ledger-->>Payment: Posted
Payment->>Settlement: Create Instruction
Settlement->>Provider: Submit
Provider-->>Settlement: Confirmation
Settlement-->>Payment: Settled
Payment-->>API: Success
```

EOF

# ------------------------------------------------------------------------------

# ROADMAP

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/45-roadmap/roadmap.md" <<'EOF'

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
EOF

# ------------------------------------------------------------------------------

# DOCUMENTAÇÃO DE IMPLEMENTAÇÃO

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/IMPLEMENTATION-GUIDE.md" <<'EOF'

# Implementation Guide

## Ordem obrigatória

A implementação não deve começar pelo frontend.

Ordem recomendada:

1. infraestrutura;
2. database;
3. identity;
4. tenant;
5. customer;
6. account;
7. ledger;
8. transaction;
9. payment;
10. approval;
11. settlement;
12. reconciliation;
13. FX;
14. integrations;
15. blockchain adapters;
16. frontend;
17. backoffice;
18. observability;
19. performance;
20. production hardening.

## Regra

Nenhuma tela deve simular uma regra financeira como se fosse real.

O frontend deve consumir:

* API;
* mocks explicitamente identificados;
* ambientes de teste.

## Regra de produção

Antes de produção:

* testes automatizados;
* threat modeling;
* penetration test;
* disaster recovery test;
* reconciliation test;
* ledger invariant test;
* load test;
* contract tests.
  EOF

# ------------------------------------------------------------------------------

# CHECKLIST

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/PRODUCTION-CHECKLIST.md" <<'EOF'

# Production Readiness Checklist

## Architecture

* [ ] Domain isolated
* [ ] Ports and adapters
* [ ] API contracts
* [ ] Event contracts

## Financial

* [ ] Double-entry ledger
* [ ] Immutable entries
* [ ] Idempotency
* [ ] Reversal
* [ ] Settlement
* [ ] Reconciliation

## Security

* [ ] MFA
* [ ] RBAC
* [ ] ABAC
* [ ] Secrets management
* [ ] Encryption
* [ ] Audit
* [ ] Rate limiting

## Operations

* [ ] Monitoring
* [ ] Alerts
* [ ] Runbooks
* [ ] Incident response
* [ ] Backup
* [ ] Restore test

## Testing

* [ ] Unit
* [ ] Integration
* [ ] Contract
* [ ] E2E
* [ ] Load
* [ ] Security

## Compliance

* [ ] KYC
* [ ] KYB
* [ ] AML
* [ ] Sanctions
* [ ] Data retention
* [ ] Privacy

## Integrations

* [ ] Banking adapter
* [ ] Legacy adapter
* [ ] COBOL integration
* [ ] FX provider
* [ ] Settlement provider
* [ ] Blockchain adapter
  EOF

# ------------------------------------------------------------------------------

# AI CONTEXT

# ------------------------------------------------------------------------------

write_if_missing "$ROOT/AI_PROJECT_CONTEXT.md" <<'EOF'

# AI PROJECT CONTEXT — VIA PAY / DEEVO

## Instrução principal

Você é um engenheiro de software principal trabalhando na implementação da
plataforma de infraestrutura financeira Via Pay / DEEVO.

Não destrua funcionalidades existentes.

Não substitua arquitetura existente sem justificativa.

Não crie mocks que pareçam produção.

Quando uma integração externa ainda não existir, implemente uma interface/port,
um adapter fake claramente identificado para testes e documente o ponto de
integração.

## Arquitetura

Utilizar:

* Clean Architecture;
* DDD;
* SOLID;
* Hexagonal Architecture;
* API First;
* Event Driven Architecture;
* Result Pattern;
* idempotency;
* observability.

## Domínio financeiro

Implementar:

* accounts;
* customers;
* transactions;
* double-entry ledger;
* payments;
* FX;
* settlement;
* reconciliation;
* approval;
* audit.

## Segurança

Implementar:

* authentication;
* authorization;
* RBAC;
* ABAC;
* MFA;
* audit;
* least privilege;
* tenant isolation.

## Regra crítica

Nunca alterar saldo diretamente.

Saldo é consequência do ledger.

Nunca apagar lançamento financeiro.

Correção ocorre através de transação compensatória.

## Integrações

Preparar ports/adapters para:

* bancos;
* PSPs;
* FX;
* sistemas legados;
* COBOL;
* MQ;
* SFTP;
* blockchain;
* Solana;
* sistemas nacionais de pagamentos.

## Frontend

O frontend deve ser institucional, profissional e preparado para operação
bancária.

Não implementar segurança apenas através do frontend.

Toda autorização deve ocorrer no backend.

## Documentação

Toda feature relevante deve atualizar:

* documentação funcional;
* arquitetura;
* API;
* eventos;
* segurança;
* testes;
* observabilidade;
* runbook;
* ADR quando necessário.

## Proibição

Não:

* apagar código existente;
* substituir arquivos sem necessidade;
* inventar integração real;
* afirmar que uma API externa está conectada quando não está;
* tratar blockchain como substituto automático de sistema bancário;
* colocar segredo no frontend;
* colocar chave privada blockchain no frontend;
* usar float para dinheiro;
* alterar ledger diretamente.

## Resultado esperado

O projeto deve evoluir para uma infraestrutura financeira modular,
auditável, segura, multi-tenant, multi-moeda e preparada para integração
enterprise.
EOF

# ------------------------------------------------------------------------------

# MANIFEST

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/DOCUMENTATION-MANIFEST.md" <<'EOF'

# Documentation Manifest

Esta documentação cobre:

* visão do produto;
* escopo;
* arquitetura;
* DDD;
* Clean Architecture;
* Hexagonal Architecture;
* multi-tenancy;
* domínio financeiro;
* ledger;
* double-entry;
* payments;
* cross-border;
* FX;
* settlement;
* reconciliation;
* accounts;
* customers;
* security;
* identity;
* RBAC;
* ABAC;
* approval workflow;
* MFA;
* audit;
* compliance;
* risk;
* APIs;
* events;
* integrations;
* legacy;
* COBOL;
* blockchain;
* Solana;
* webhooks;
* observability;
* testing;
* DevOps;
* database;
* frontend;
* backoffice;
* operations;
* disaster recovery;
* performance;
* privacy;
* governance;
* ADRs;
* runbooks;
* API contracts;
* schemas;
* diagrams;
* roadmap;
* glossary.

A documentação deve evoluir junto com o código.

Nenhuma funcionalidade financeira crítica deve ser considerada concluída sem
documentação, testes e evidência operacional.
EOF

# ------------------------------------------------------------------------------

# Gitignore documental

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/.gitkeep" <<'EOF'
EOF

# ------------------------------------------------------------------------------

# FINAL

# ------------------------------------------------------------------------------

echo ""
echo "======================================================================"
echo " DOCUMENTAÇÃO CRIADA"
echo "======================================================================"
echo ""

find "$DOCS" -type f | sort

echo ""
echo "======================================================================"
echo " CONTAGEM"
echo "======================================================================"

TOTAL="$(find "$DOCS" -type f | wc -l | tr -d ' ')"

echo "Arquivos documentais: $TOTAL"

echo ""
echo "======================================================================"
echo " CONTEXTO DA IA"
echo "======================================================================"
echo ""
echo "Criado:"
echo "  AI_PROJECT_CONTEXT.md"
echo ""
echo "Esse arquivo deve ser fornecido à IA responsável pela implementação."
echo ""

echo "======================================================================"
echo " PRÓXIMO PASSO"
echo "======================================================================"
echo ""
echo "1. Revisar docs/"
echo "2. Revisar AI_PROJECT_CONTEXT.md"
echo "3. Implementar primeiro o domínio + ledger."
echo "4. Depois Payment/Settlement/Reconciliation."
echo "5. Depois integrações."
echo "6. Depois frontend/backoffice."
echo ""
echo "Nenhum arquivo existente foi sobrescrito."
echo ""
echo "Bootstrap documental concluído."
echo ""

