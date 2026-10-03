
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

