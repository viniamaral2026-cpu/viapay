# VIAPAY — DATABASE GAPS
# Database Gap Analysis: Schema vs Financial Requirements

**Data:** 2026-10-03  
**Objective:** Identify gaps between database schema and financial/infrastructure requirements

---

## 1. PRISMA SCHEMA INVENTORY

### 1.1 Models Identificados

| Model | Campos Identificados | Status | Gap |
|-------|----------------------|--------|-----|
| $enum | — | ✅ Basics | — |
| User | id, email, name, password, role, createdAt, updatedAt | ⚠️ Partial | Falta: institutionId, MFA fields, lastLogin, failedAttempts |
| Account | id, name, number, type, currency, createdAt, updatedAt | ⚠️ Partial | Falta: ledger balance fields, status, tenantId, bankId |
| Payment | id, amount, currency, status, provider, providerReference, createdAt, updatedAt | ✅ Good | Falta: idempotencyKey, externalId, metadata, settlementStatus |
| Transaction | id, amount, currency, status, createdAt, updatedAt | ⚠️ Partial | Falta: debit/credit fields para ledger, reference, externalId |
| Settlement | id, grossAmount, netAmount, currency, status, createdAt | ⚠️ Partial | Falta: fees breakdown, settlementBatchId, destinationDetails |
| Reconciliation | id, status, mismatchDetails, createdAt | ❌ Missing | Entidade ainda não criada |
| WebhookEvent | id, eventType, status, attempt, createdAt | ⚠️ Partial | Falta: idempotencyKey, signature, payload hash, retryCount |
| IdempotencyKey | ❌ Missing | Entidade ainda não criada | Criar tabela para garantir idempotência |
| AuditLog | ❌ Missing | Entidade ainda não criada | Criar para auditoria financeira |
| FXQuote | ❌ Missing | Entidade ainda não criada | Criar para armazenar cotações |
| Institution | ⚠️ Partial | Existe base; falta: onboarding, config fields, settings |
| Merchant | ⚠️ Partial | Existe base; falta: business fields, compliance, limits |
| LedgerEntry | ❌ Missing | Crítico para double-entry | Criar com: debit, credit, currency, amount, reference, transactionId, createdAt |
| PaymentMethod | ⚠️ Partial | Existe tipos básicos; falta: details por tipo, status, provider |

### 1.2 Relacionamentos (Foreign Keys)

| Relação | Status | Gap |
|---------|--------|-----|
| User ↔ Institution | ⚠️ Partial | institutionId existe mas pode não ter constraint |
| User ↔ Merchant | ⚠️ Partial | possibly missing |
| Payment ↔ Merchant | ✅ Identificado | merchantId no schema |
| Payment ↔ User/Customer | ⚠️ Partial | customerId exists but pode não ter relation |
| Settlement ↔ Payment | ❌ Missing | Não existe relation no schema |
| Reconciliation ↔ Payment | ❌ Missing | Não existe |
| WebhookEvent ↔ Payment | ⚠️ Partial | paymentId possibly exists |
| User ↔ Institution (1:N) | ⚠️ Partial | possibly missing constraint |

---

## 2. CRITICAL DATABASE GAPS (🔴 CRITICAL)

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| DB-001 | Ledger Double-Entry | Tabela LedgerEntry **não existe** no schema Prisma | 🔴 CRÍTICO | Criar entidade LedgerEntry com: debit Decimal, credit Decimal, currency String, amount Decimal, reference String, transactionId String, createdAt DateTime |
| DB-002 | Idempotência | Tabela IdempotencyKey **não existe** | 🔴 CRÍTICO | Criar entidade com: key String (unique), paymentId String, responseHash String, expiresAt DateTime, used Boolean |
| DB-003 | Audit Log | Tabela AuditLog **não existe** | 🔴 CRÍTICO | Criar entidade com: actor String, action String, resource String, resourceId String, before JSON, after JSON, timestamp DateTime, ip String, correlationId String, requestId String |
| DB-004 | FX Quotes | Tabela FXQuote **não existe** | 🔴 CRÍTICO | Criar entidade com: originalAmount Decimal, originalCurrency String, exchangeRate Decimal, convertedAmount Decimal, targetCurrency String, spread Decimal, fees Decimal, rateTimestamp DateTime, provider String, status String |
| DB-005 | Settlement | Tabela Settlement **parcial** (poucos campos) | 🔴 CRÍTICO | Estender com: grossAmount, netAmount, fees breakdown, settlementBatchId, destination, status, completedAt |
| DB-006 | Reconciliation | Tabela Reconciliation **não existe** | 🔴 CRÍTICO | Criar entidade com: paymentId, externalId, internalAmount, externalAmount, mismatchType, status, reviewedAt, resolvedAt |
| DB-007 | Institution Config | Tabela Institution **insuficiente** para configurações completas | 🟠 ALTO | Estender com: currenciesSupported, corridors, fxSpread, settlementLimits, fees, complianceSettings |
| DB-008 | Merchant Config | Tabela Merchant **insuficiente** para configurações completas | 🟠 ALTO | Estender com: businessName, taxId, settlementSchedule, payoutSchedule, riskLimits, complianceComplete |
| DB-009 | Payment Attempt | Registro de tentativas de pagamento não rastreado | 🟠 ALTO | Adicionar fields ou criar tabela PaymentAttempt: attemptNumber, status, errorDetails, startedAt, completedAt |
| DB-010 | Transaction Status History | Histórico de status transactions não rastreado | 🟠 ALTO | Adicionar tabela TransactionStatusHistory ou adicionar fields statusHistory no Transaction |

---

## 3. HIGH DATABASE GAPS (🟠 ALTO)

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| DB-011 | Tenant Isolation | Campo tenantId não está em todas tabelas críticas | 🟠 ALTO | Adicionar tenantId em: Payment, Transaction, Settlement, Reconciliation, WebhookEvent, AuditLog; garantir RLS (Row Level Security) por tenant |
| DB-012 | Indexes Críticos | Índices essenciais não existirem para performance | 🟠 ALTO | Adicionar índices: paymentId, merchantId, customerId, status, createdAt, providerReference, tenantId em todas tabelas grandes |
| DB-013 | Unique Constraints | Constraints únicas necessárias não existem | 🟠 ALTO | Adicionar: UNIQUE(providerReference) em Payment, UNIQUE(key) em IdempotencyKey, UNIQUE(correlationId) em AuditLog |
| DB-014 | Foreign Keys Constraints | Constraints FK podem não estar definidas corretamente | 🟠 ALTO | Revisar e adicionar FKs: User→Institution, Payment→Merchant, Settlement→Payment, etc. |
| DB-015 | Soft Delete | estratégia de soft delete inconsistente across modelos | 🟡 MÉDIA | Definir política: usar deletedAt em algumas entidades; outras devem ser hardening deletes (audit log em vez de deletar) |
| DB-016 | Timestamps Consistentes | createdAt/updatedAt podem não estar em todas entidades | 🟡 MÉDIA | Garantir que todas entidades tenham: createdAt DateTime (não nullable), updatedAt DateTime (on update) |
| DB-016 | Decimal Precisão para Money | Campos de valor monetário podem usar tipo errado | 🟠 ALTO | Garantir todos campos de valor monetário usam Decimal (prisma Decimal) e NÃO Float; definir precision/scale adequados |
| DB-017 | Currency Field | Campo currency pode não ser consistente | 🟡 MÉDIA | Garantir que todas entidades tiverem campo currency String(3) (ISO 4217) quando aplicável |
| DB-018 | Enum Fields | Enums no Prisma podem não cobrir todos valores necessários | 🟡 MÉDIA | Revisar enums: PaymentStatus, TransactionStatus, SettlementStatus, WebhookEventStatus; adicionar estados faltantes |
| DB-016 | Composite Keys | Chaves compostas necessárias não existem | 🟡 MÉDIA | Considerar composite keys para tabelas de junção/relacionamento many-to-many |

---

## 4. MEDIUM DATABASE GAPS (🟡 MÉDIA)

| GAP ID | Área | Gap Descrição | Impacto | Correção Necessária |
|--------|------|---------------|---------|---------------------|
| DB-017 | Migrations Versionamento | Histórico de migrations pode não estar documentado | 🟡 MÉDIA | Documentar cada migration com: número, data, o que mudou, rollback strategy |
| DB-018 | Database Views | Views necessárias para relatórios não existem | 🟡 MÉDIA | Criar views: vw_payment_summary, vw_settlement_report, vw_reconciliation_status |
| DB-019 | Stored Procedures | Procedimentos armazenados para lógica complexa não existem | 🟡 MÉDIA | Considerar para: cálculo de juros, validações complexas, reconciliation rules |
| DB-020 | Triggers | Triggers para auditoria automática ou consistência não existem | 🟡 MÉDIA | Considerar triggers: audit log automático ao alterar payment status, atualizar ledger balance |
| DB-020 | Particionamento | Tabelas grandes podem não estar particionadas | 🟡 MÉDIA | Considerar particionamento por tenantId ou createdAt para tables grandes (payments, transactions) |
| DB-021 | Backup Strategy | Estratégia de backup não definida no schema | 🟡 MÉDIA | Documentar: frequência, retention, testes de restore |
| DB-022 | Read Replicas | Configuração de read replicas para scaling não existe | 🟡 MÉDIA | Considerar para ambiente de produção leitura intensiva |
| DB-023 | Connection Pool | Pool de conexões PostgreSQL configurado adequadamente | 🟡 MÉDIA | Garantir pool size adequado ao tráfego; usar pgBouncer ou equivalente |
| DB-024 | Audit Trigger | Trigger automática para logar mudanças críticas | 🟡 MÉDIA | Criar trigger que inser em AuditLog automaticamente quando payment/transaction/status alterado |
| DB-025 | Column Encryption | Dados sensíveis (CPF, chaves) não criptografados no nível de coluna | 🟡 MÉDIA | Considerar pgcrypto ou application-level encryption para dados altamente sensíveis |

---

## 5. INDEX STRATEGY REQUERIDA

| Tabela | Campo(s) | Tipo de Index | Prioridade |
|--------|----------|---------------|------------|
| Payment | status | Index normal | CRÍTICO (listagem por status) |
| Payment | merchantId | Index normal | CRÍTICO (listagem por merchant) |
| Payment | providerReference | Unique Index | CRÍTICO (não duplicatas) |
| Payment | tenantId | Index normal | ALTO (isolamento tenant) |
| Payment | createdAt | Index composto | ALTO (ordenação por data) |
| Transaction | status | Index normal | CRÍTICO |
| Transaction | paymentId | Index normal | ALTO |
| Transaction | tenantId | Index normal | ALTO |
| Settlement | status | Index normal | ALTO |
| Settlement | paymentId | Index normal | ALTO |
| Settlement | tenantId | Index normal | ALTO |
| Reconciliation | paymentId | Index normal | CRÍTICO (busca por payment) |
| WebhookEvent | status | Index normal | ALTO |
| WebhookEvent | processedAt | Index normal | ALTO |
| AuditLog | createdAt | Index normal | ALTO (queries temporais) |
| AuditLog | correlationId | Unique Index | ALTO (não duplicatas) |
| User | tenantId | Index normal | ALTO (RLS) |
| User | email | Unique Index | CRÍTICO (login) |
| Institution | cnpj/taxId | Unique Index | CRÍTICO (identificação) |
| Merchant | taxId | Unique Index | CRÍTICO (identificação) |

---

## 5. MIGRATIONS GAPS

| Migration ID | Descrição | Status | Ação |
|--------------|-----------|--------|------|
| 20261003111032_init | Migration inicial | ✅ Existente | Revisar se todas entidades necessárias estão incluídas |
| 20261003115412_add_settlements | Adiciona settlements | ✅ Existente | Verificar se campos são suficientes para settlement completo |
| Próximas migrations necessárias | — | ❌ Não existirem | Criar migrations para: LedgerEntry, IdempotencyKey, AuditLog, FXQuote, Reconciliation, adicionar campos críticos em tabelas existentes |

---

## 6. RELATIONSHIP GAPS VISUAL

```
User ──┐
       ├── Institution (1:N) ⚠️ Partial
       ├── Merchant (1:N) ⚠️ Partial
       └── Payment (1:N) ✅

Merchant ──┐
          ├── Payment (1:N) ✅
          └── Settlement (1:N) ❌ Missing

Payment ──┐
          ├── Transaction (1:N) ⚠️ Partial
          ├── Settlement (1:1) ❌ Missing
          ├── Reconciliation (1:1) ❌ Missing
          └── WebhookEvent (1:N) ⚠️ Partial

FXQuote (❌ Missing) - standalone, not connected

LedgerEntry (❌ Missing) - independent, relates to Payment/Transaction via transactionId

IdempotencyKey (❌ Missing) - links to Payment for idempotência

AuditLog (❌ Missing) - relates to all critical entities via resourceId/resourceType
```

---

## 7. ACTION PLAN DATABASE

### Fase 1 - Imediata (1 semana)

- [ ] DB-001: Criar LedgerEntry entity com fields debit/credit
- [ ] DB-002: Criar IdempotencyKey entity
- [ ] DB-003: Criar AuditLog entity
- [ ] DB-004: Criar FXQuote entity
- [ ] DB-005: Estender Settlement entity com fields completos
- [ ] DB-006: Criar Reconciliation entity
- [ ] DB-011: Adicionar tenantId em tabelas críticas + RLS policy
- [ ] DB-015: Garantir Decimal tipo em todos campos monetários
- [ ] Criar migrations necessárias
- [ ] Aplicar índices strategy

### Fase 2 - Alta (Semana 2-3)

- [ ] DB-011: Completer tenant isolation em todas tabelas
- [ ] DB-012: Aplicar todos índices strategy
- [ ] DB-013: Adicionar unique constraints necessárias
- [ ] DB-014: Revisar e corrigir foreign keys constraints
- [ ] DB-015: Definir política consistente de soft delete
- [ ] DB-016: Garantir enum fields cobrem todos valores necessários

### Fase 3 - Média (Semana 4-4)

- [ ] DB-017: Documentar migrations strategy
- [ ] DB-018: Criar views para reports essenciais
- [ ] DB-019: Considerar stored procedures para lógica complexa
- [ ] DB-020: Criar triggers para audit automática
- [ ] DB-021: Definir backup strategy documentada
- [ ] DB-022: Avaliar read replicas necessidade
- [ ] DB-023: Revisar connection pool configuração
- [ ] DB-024: Implementar column encryption para dados sensíveis se necessário

---
**FIM DO DATABASE_GAPS.md**