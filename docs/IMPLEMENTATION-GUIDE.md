
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
