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
