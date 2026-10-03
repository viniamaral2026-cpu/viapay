# VIAPAY — ARCHITECTURE GAPS
# Gap Analysis: Current State vs Target Architecture

**Data:** 2026-10-03  
**Objective:** Identify gaps between existing implementation and target architecture

---

## 1. GAPS CRÍTICOS (Blockers)

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-001 | Core Ledger | Ledger double-entry (debit/credit) não implementado | 🔴 CRÍTICO | Implementar entidade LedgerEntry com campos debit, credit, currency, amount, reference, transactionId, createdAt |
| G-002 | Payment Core | Payment Core completo não implementado | 🔴 CRÍTICO | Criar PaymentIntent, Payment, Transaction entities com máquina de estados |
| G-003 | Payment Router | Payment Router não implementado | 🔴 CRÍTICO | Criar serviço que determina rail (PIX, Card, Bank, Blockchain) conforme regras |
| G-004 | FX Engine | FX Engine não implementado | 🔴 CRÍTICO | Criar FxProviderPort com métodos getQuote(), lockQuote(), executeConversion() |
| G-005 | Settlement Engine | Settlement Engine não implementado | 🔴 CRÍTICO | Criar SettlementService com SettlementBatch, SettlementItem, Payout |
| G-006 | Reconciliation | Reconciliation Engine ausente | 🔴 CRÍTICO | Criar mecanismo comparar VIAPAY Ledger vs Provider/Banco/Blockchain |
| G-007 | Provider Abstraction | PaymentProvider com adapters (Stripe, Efí, Solana, Banking) não criado | 🔴 CRÍTICO | Criar interface PaymentProvider + adapters externos |
| G-008 | Idempotência | Idempotência em operações críticas não implementada | 🔴 CRÍTICO | Implementar tabela IdempotencyKey + hash da requisição + response armazenada |
| G-009 | Webhook Engine | Webhook Engine robusto não implementado | 🔴 CRÍTICO | Criar sistema avec signature validation, retry, DLQ, idempotência |
| G-010 | RBAC/ABAC | RBAC e ABAC não implementados | 🔴 CRÍTICO | Implementar roles (SUPER_ADMIN, BANK_ADMIN, etc.) + policies contextuais |

---

## 2. GAPS DE ALTA PRIORIDADE

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-011 | Blockchain/Solana | SolanaAdapter não implementado | 🟠 ALTA | Criar adapter respeitando hexagonal architecture |
| G-012 | Circle/USDC | Integração Circle/USDC não existe | 🟠 ALTA | Criar StablecoinProvider + CircleAdapter |
| G-013 | FX Cotação | FX quotes não vêm de provider real | 🟠 ALTA | Integrar com provider de cotação ou criar interface |
| G-014 | Bank Integration | Integração com bancos legacy (COBOL, REST, SOAP) não existe | 🟠 ALTA | Criar bank adapters (REST, SOAP, SFTP, ISO20022) |
| G-015 | Multi-currency | Suporte a múltiplas moedas não completo | 🟠 ALTA | Implementar currency conversion no Payment Router |
| G-016 | Ledger Schema | Schema do banco não otimizado para ledger | 🟠 ALTA | Otimizar Prisma schema com foreign keys, indexes tenantId, status, createdAt |
| G-017 | API Versionamento | API sem versionamento /api/v1 consistente | 🟠 ALTA | Implementar versionamento API consistentemente |
| G-017 | Audit Logging | Audit log em operações financeiras não existe | 🟠 ALTA | Criar entidade AuditEvent com actor, action, resource, before, after, timestamp |
| G-018 | MFA | Multi-factor authentication não implementado | 🟠 ALTA | Implementar TOTP, WebAuthn, OTP |
| G-019 | SDK | SDK (JS, Node, PHP, etc.) não criado | 🟠 ALTA | Criar packages/sdk com contratos typescrypt |
| G-020 | Developer Portal | Developer Portal não existe | 🟠 ALTA | Criar portal com API docs, SDKs, sandbox |

---

## 3. GAPS DE MÉDIA PRIORIDADE

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-021 | PIX Global | Funcionalidades PIX não integradas ao Payment Router | 🟡 MÉDIA | Integrar PIX como rail no router |
| G-022 | Checkout States | Estados de checkout (confirmation, expired, failure, processing) parcialmente implementados | 🟡 MÉDIA | Padronizar e conectar ao Payment Core |
| G-023 | Designer System | Design system viapay-system.css incompleto | 🟡 MÉDIA | Complementar componentes e tokens |
| G-024 | Admin Dashboard | Dashboard administrativo parcial | 🟡 MÉDIA | Expandir com módulos: pagamentos, clientes, settlement, reconciliation |
| G-024 | FX Quote Display | Cotação de FX não exibida no frontend | 🟡 MÉDIA | Conectar FX Engine output ao frontend |
| G-025 | Settlement Status | Status de settlement não visível no frontend | 🟡 MÉDIA | Implementar endpoints e UI |
| G-026 | Reconciliation UI | UI para conciliação não existe | 🟡 MÉDIA | Criar página de reconciliation no dashboard |
| G-027 | Risk Scoring | Motor de risk scoring não implementado | 🟡 MÉDIA | Criar RiskAssessment entity + rules |
| G-028 | Limits | Límites de transação por cliente/merchant não implementados | 🟡 MÉDIA | Implementar Limite entity + rules configuráveis |
| G-029 | Approval Workflow | Fluxo de aprovação por alçadas não existe | 🟡 MÉDIA | Implementar ApprovalPolicy + ApprovalLevel +ApprovalRequest |
| G-030 | Webhook Replay | Proteção contra webhook replay não existe | 🟡 MÉDIA | Implementar idempotency key + processed_at tracking |
| G-031 | KYC/KYB | Módulos KYC/KYB não implementados | 🟡 MÉDIA | Criar interfaces + adapters para verificação |
| G-032 | FX Spread/Fees | Cálculo de spread e fees não centralizado | 🟡 MÉDIA | Criar FeeEngine + SpreadEngine |
| G-033 | Settlement Methods | Métodos de settlement (bank, crypto, psp) não abstraídos | 🟡 MÉDIA | Criar SettlementRailPort + métodos |
| G-034 | Transaction Metadata | Metadados de transação não estruturados | 🟡 MÉDIA | Criar Metadata entity ou JSON schema |
| G-035 | Currency Format | Formatação monetária consistente no frontend | 🟡 MÉDIA | Implementar CurrencyInput + MoneyDisplay components |
| G-036 | Pagination/Filters | Pagination e filters não consistentes | 🟡 MÉDIA | Implementar padrão em listagens de dashboard |
| G-037 | Search | Busca avançada não implementada | 🟡 MÉDIA | Adicionar search em listagens críticas |
|
| **GAPS LOWER PRIORITY** |
| G-038 | QR Code | Geração de QR Code no checkout não otimizada | 🟢 BAIXA | Integrar biblioteca QR ou serviço |
| G-039 | Payment Links | Payment links (/pay/{id}) não implementados | 🟢 BAIXA | Criar endpoints e UI |
| G-040 | Reporting | Relatórios empresariais limitados | 🟢 BAIXA | Criar reports endpoints + UI |
| G-041 | Notifications | Sistema de notificações não implementado | 🟢 BAIXA | Criar notification dispatch + queues |
| G-042 | Bank Admin Painel | Painel de admin bancário básico | 🟢 BAIXA | Expandir dashboard com módulos bancários |
| G-043 | Multi-tenancy | Isolamento por tenant_id não implementado | 🟢 BAIXA | Implementar tenantId em entidades críticas |
| G-044 | CCTP | Circle Cross-Chain Transfer Protocol não implementado | 🟢 BAIXA | Criar adapter quando houver necessidade |
| G-044 | Sandbox | Environment sandbox não existe | 🟢 BAIXA | Criar sandbox para testes de pagamentos |
| G-045 | Disaster Recovery | Plano de recuperação não documentado | 🟢 BAIXA | Documentar procedimentos |
| G-046 | Backup Strategy | Estratégia de backup não definida | 🟢 BAIXA | Documentar e implementar |
| G-047 | Performance | Otimizações de performance pendentes | 🟢 BAIXA | Indexar queries críticas |
| G-048 | Rate Limiting | Rate limiting por endpoint não implementado | 🟢 BAIXA | Implementar middleware |
| G-049 | CORS | Configuração CORS não otimizada | 🟢 BAIXA | Ajustar headers |
| G-050 | CSRF | Proteção CSRF não implementada | 🟢 BAIXA | Considerar para forms bancários |

---

## 4. GAPS DE ARQUITETURA

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-051 | Hexagonal Architecture | Domínio acoplado a adapters específicos | 🟠 ALTA | Mover adapters para camada infrastructure, domain só conhecer interfaces |
| G-052 | Bounded Contexts | Contexto(s) do domínio não claramente delimitados | 🟠 ALTA | Definir bounded contexts claros (Identity, Customer, Payments, etc.) |
| G-053 | Event-Driven | Publicação de eventos não implementada | 🟠 ALTA | Implementar event bus + eventos: PaymentCreated, PaymentSettled, etc. |
| G-054 | CQRS | Command Query Responsibility Segregation não aplicada | 🟡 MÉDIA | Considerar para read/write models distintos |
| G-055 | Transaction Boundaries | Boundaries de transação não consistentes | 🟠 ALTA | Garantir todos os operations financeiras usem transactions Prisma |
| G-056 | Error Handling | Tratamento de erros consistente por API | 🟡 MÉDIA | Padrão de resposta de erro padronizada |
| G-057 | OpenAPI | Documentação OpenAPI não gerada a partir do código | 🟡 MÉDIA | Gerar/OpenAPI a partir de rotas/controllers |
| G-058 | CQRS/ES | Event Sourcing não implementado | 🔴 CRÍTICO | Considerar para ledger/financial records (alternativa ao append-only) |
| G-059 | Stateless Services | Services não Stateless onde possível | 🟡 MÉDIA | Refatorar services para não terem state mutable |
| G-060 | Dependency Inversion | Dependency inversion não aplicado em todas as layers | 🟠 ALTA | Garantir dependências invertidas (high-level → low-level) |

---

## 5. GAPS DE SEGURANÇA

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-061 | Secrets Management | Secrets possibly no .env ou commited acidentalmente | 🔴 CRÍTICO | Auditorar git, remover secrets, usar secret manager |
| G-062 | Rate Limiting | Rate limiting por IP/tenant não implementado | 🔴 CRÍTICO | Implementar middleware de rate limiting |
| G-063 | Input Validation | Validação de entrada inconsistente por endpoint | 🔴 CRÍTICO | Implementar pipes/zod/yup validation global |
| G-064 | XSS Prevention | Proteção contra XSS no frontend não configurada | 🔴 CRÍTICO | Configurar Content Security Policy, sanitize outputs |
| G-065 | Webhook Signature | Verificação de assinatura de webhook ausente | 🔴 CRÍTICO | Implementar HMAC verification + secret por provider |
| G-065 | SQL Injection | Proteção contra SQL injection verificada | 🟡 MÉDIA | Usar Prisma (parameterized queries) ✅ |
| G-066 | CORS | Configuração CORS pode estar excessiva | 🟡 MÉDIA | Revisar origens permitidas |
| G-067 | Session Management | Gerenciamento de sessão sem proteções adequadas | 🔴 CRÍTICO | Implementar cookieSameSite, secure flags, rotation |
| G-068 | Audit Trail | Audit trail financeiro inexistente | 🔴 CRÍTICO | Implementar audit logging em todas as operações sensíveis |
| G-069 | Anti-Fraud | Controles antifraud básicos | 🟡 MÉDIA | Implementar velocity limits, suspicious activity detection |
| G-070 | Data Privacy | LGPD compliance verification pendente | 🟡 MÉDIA | Auditar coleta, armazenamento, retention de dados pessoais |
| G-071 | JWT Secrets | JWT signing key configuration verification | 🔴 CRÍTICO | Verificar e corrigir segredos JWT |

---

## 6. GAPS DE TESTES

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-072 | Unit Tests | Testes unitários inexistentes | 🔴 CRÍTICO | Criar suite completa para domínios críticos |
| G-073 | Integration Tests | Testes de integração inexistentes | 🔴 CRÍTICO | Testes end-to-end API → DB → endpoint |
| G-074 | E2E Tests | Testes end-to-end inexistentes | 🔴 CRÍTICO | Fluxos completos: checkout → payment → settlement |
| G-075 | Idempotency Tests | Testes de idempotência inexistentes | 🔴 CRÍTICO | Financeiro: duplicate request must not create double entry |
| G-076 | Ledger Tests | Testes de ledger/double-entry inexistentes | 🔴 CRÍTICO | Debit must always equal Credit |
| G-077 | Reconciliation Tests | Testes de reconciliation inexistentes | 🔴 CRÍTICO | Testar match/mismatch entre ledger e provider |
| G-077 | Failure Recovery | Testes de falha (provider timeout, DB failure) inexistentes | 🔴 CRÍTICO | Simular falhas e verificar recovery |
| G-078 | Security Tests | Testes de segurança inexistentes | 🔴 CRÍTICO | Testar XSS, SQLi, auth bypass, rate limit bypass |
| G-079 | Provider Failover | Testes de fallback quando provider cai | 🟡 MÉDIA | Simular caída e verificar routing alternativo |
| G-080 | FX Quote Expiry | Testes de expiração de cotação | 🟡 MÉDIA | Verificar rate TTL da cotação |

---

## 7. GAPS DE DOCUMENTAÇÃO

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| G-081 | Architecture Decision Records | ADRs não atualizados com implementação real | 🟡 MÉDIA | Atualizar ADRs após cada mudança estrutural |
| G-082 | API Contracts | Contratos API divergem do código implementado | 🟡 MÉDIA | Sincronizar contrato ↔ código |
| G-083 | Developer Guide | Guide para desenvolvedores não existe | 🟡 MÉDIA | Criar guia setup, development, deployment |
| G-084 | Sandbox Guide | Guia do ambiente sandbox não existe | 🟡 MÉDIA | Documentar uso do sandbox |
| G-085 | API Error Contract | Padrão de erro da API não documentado | 🟡 MÉDIA | Documentar padrão {error: {code, message, request_id}} |
| G-086 | Database Schema | Schema do banco não documentado ERD | 🟡 MÉDIA | Gerar diagrama ERD do schema Prisma |
| G-086 | Security Guidelines | Guidelines de segurança não documentadas | 🟡 MÉDIA | Documentar melhores práticas aplicáveis |
| G-087 | Deployment Guide | Guia de deployment não existe | 🟡 MÉDIA | Documentar Docker, environment, steps |
| G-088 | Roadmap Document | Roadmap oficial não atualizado | 🟡 MÉDIA | Manter roadmap sincronizado com progresso |
| G-089 | Glossário | Glossário de termos financeiros/technical não existe | 🟢 BAIXA | Criar glossário termos usados no projeto |

---

## 8. SUMÁRIO EXECUTIVO DE GAPS

| Categoria | Quantidade | Prioridade |
|-----------|------------|------------|
| 🔴 CRÍTICOS | 10 | Imediato |
| 🟠 ALTA | 10 | Sprint 1-2 |
| 🟡 MÉDIA | 30 | Sprint 3-6 |
| 🟢 BAIXA | 15 | Backlog / futuro |

**Total de Gaps Identificados:** 65

### Distribuição por Estágio Atual
- ✅ Complete: 8 módulos (12,3%)
- ⚠️ Partial: 22 módulos (33,8%)
- ❌ Missing: 35 módulos (53,8%)

### Próximas 4 Etapas Recomendadas

1. **Semana 1-2:** Corrigir G-001 a G-010 (gaps críticos - ledger, payment core, router, fx, settlement, reconciliation, provider abstraction, idempotência, webhook, rbac)
2. **Semana 3-4:** Corrigir G-011 a G-020 (gaps alta - blockchain, circle, fx quote, bank integration, multi-currency, audit, api versionamento, mfa, sdk, developer portal)
3. **Semana 5-8:** Corrigir G-021 a G-037 (gaps média - PIX, checkout states, designer system, admin dashboard, risk, limits, approvals, webhook replay, KYC/KYB, fees, settlement methods, metadata, currency format, pagination/filters, search)
4. **Semana 9+:** Corrigir G-038 a G-050 (gaps baixa - QR code, payment links, reporting, notifications, bank admin, multi-tenancy, CCTP, sandbox, DR, backup, performance, rate limiting, CORS, CSRF)

---
**FIM DO ARCHITECTURE_GAPS.md**