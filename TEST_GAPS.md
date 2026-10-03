# VIAPAY — TEST GAPS
# Test Gap Analysis: Coverage vs Requirements

**Data:** 2026-10-03  
**Objective:** Identify gaps between test coverage and requirements for a payment infrastructure

---

## 1. TEST INVENTORY OVERVIEW

| Test Type | Total Expected | Total Found | Gap | Status |
|-----------|----------------|-------------|-----|--------|
| Unit Tests | 50+ | 0 | ❌ 50+ missing | Critical |
| Integration Tests | 30+ | 0 | ❌ 30+ missing | Critical |
| E2E Tests | 20+ | 0 | ❌ 20+ missing | Critical |
| Contract Tests | 15+ | 0 | ❌ 15+ missing | Critical |
| Idempotency Tests | 10+ | 0 | ❌ 10+ missing | Critical |
| Ledger Tests | 8+ | 0 | ❌ 8+ missing | Critical |
| Reconciliation Tests | 8+ | 0 | ❌ 8+ missing | Critical |
| Security Tests | 12+ | 0 | ❌ 12+ missing | Critical |
| Failure Recovery Tests | 10+ | 0 | ❌ 10+ missing | Critical |
| Provider Failover Tests | 8+ | 0 | ❌ 8+ missing | High |
| FX Quote Expiry Tests | 5+ | 0 | ❌ 5+ missing | High |
| Webhook Tests | 12+ | 0 | ❌ 12+ missing | High |
| Provider Timeout Tests | 6+ | 0 | ❌ 6+ missing | High |
| Duplicate Request Tests | 5+ | 0 | ❌ 5+ missing | High |
| Refund Tests | 6+ | 0 | ❌ 6+ missing | Medium |
| Refund Tests | Chargeback Tests | 4+ | 0 | ❌ 4+ missing | Medium |
| Settlement Tests | 6+ | 0 | ❌ 6+ missing | Medium |
| Currency Conversion Tests | 5+ | 0 | ❌ 5+ missing | Medium |
| Pagination Tests | 4+ | 0 | ❌ 4+ missing | Low |
| Error Handling Tests | 8+ | 0 | ❌ 8+ missing | Medium |

**Total:** ~225 tests esperados vs 0 implementados = ❌ 100% gap

---

## 2. CRITICAL TEST GAPS (🔴 CRITICAL - Financial Infrastructure)

| GAP ID | Área | Gap Descrição | Impacto | Caso de Teste Essencial |
|--------|------|---------------|---------|------------------------|
| T-001 | Idempotência | Testes de idempotência inexistentes | 🔴 CRÍTICO | Enviar mesma requisição de criação de pagamento 2x; verificar que apenas 1 transação financeira é criada (Ledger: Debit = Credit) |
| T-002 | Ledger Double-Entry | Testes de ledger/double-entry inexistentes | 🔴 CRÍTICO | Verificar após cada operação: total de debitos = total de créditos em ledger após payment/create, capture, refund, settlement |
| T-003 | Estados de Payment | Testes de transições de estado inexistentes | 🔴 CRÍTICO | Testar todas transitions validas/invalidadas: CREATED→PENDING→AUTHORIZED→PROCESSING→SETTLEMENT_PENDING→SETTLED, FAILED, CANCELLED, REFUNDED, EXPIRED |
| T-004 | Webhook Replay | Testes de proteção contra replay de webhook inexistentes | 🔴 CRÍTICO | Enviar mesmo webhook 2x; verificar que segunda entrega é rejeitada/idempotentemente processada |
| T-005 | Falha de Provider | Testes de falha de provider (timeout, error) inexistentes | 🔴 CRÍTICO | Simular timeout no provider; verificar retry, backoff, DLQ, fallback para rota alternativo |
| T-006 | Cotação FX Expiração | Testes de expiração de cotação FX inexistentes | 🔴 CRÍTICO | Criar cotação com expiry time; verificar que expirada retorna erro apropriado e não é usada |
| T-007 | Reconciliation Mismatch | Testes de divergência de reconciliação inexistentes | 🔴 CRÍTICO | Criar cenário onde provider reporta amount diferente; verificar que ReconciliationCase é aberto e não é ignorado |
| T-008 | Settlement Failure | Testes de falha de settlement inexistentes | 🔴 CRÍTICO | Simular falha de settlement; verificar que estado é SETTLEMENT_FAILED; possibilidade de retry; não marcar settlement.completed erroneamente |
| T-009 | Refund Processing | Testes de processamento de reembolso inexistentes | 🔴 CRÍTICO | Testar criação de refund; verificar ledger: reversal entry; status atualização; tempo de processamento |
| T-010 | Cancelamento de Payment | Testes de cancelamento de payment inexistentes | 🔴 CRÍTICO | Testar cancelamento em estados adequados (ex: PENDING, CREATED); verificar que estado fica CANCELLED; ledger reversal se já houver settlement |
| T-011 | Webhook Signature | Testes de verificação de assinatura de webhook inexistentes | 🔴 CRÍTICO | Testar webhook com signature inválida; rejeitar e registrar evento failed validation |
| T-011 | Duplicate Payment | Testes de pagamento duplicado inexistentes | 🔴 CRÍTICO | Testar situação onde mesma instrução é enviada via rotas diferentes; verificar que sistema detecta e rejeita/retorna resultado idêntico |

---

## 3. HIGH TEST GAPS (🟠 ALTO - Integração e Funcionalidade)

| GAP ID | Área | Gap Descrição | Impacto | Caso de Teste Essencial |
|--------|------|---------------|---------|------------------------|
| T-012 | Integração API → DB | Testes de integração API → Service → Repository → DB inexistentes | 🟠 ALTO | Fluxo completo: POST /payment-intents → service → repository → Prisma create → retorno API confirmatory |
| T-013 | Criação de Cliente/Merchant | Testes de criação de customer/merchant do início ao fim inexistentes | 🟠 ALTO | Testar POST /customers/mérchants com validação, salvamento, recuperação |
| T-014 | FX Quote Flow | Testes do fluxo completo de cotação FX inexistentes | 🟠 ALTO | Criar quote → aplicar taxa → converter amount → mostrar no frontend → validar conversão |
| T-015 | PIX Integration | Testes de integração PIX do checkout à confirmação inexistentes | 🟠 ALTO | Fluxo: criar cobrança PIX → gerar QR → cliente paga → webhook recebido → status atualizado → settlement |
| T-016 | Settlement Flow | Testes do fluxo complete de settlement inexistentes | 🟠 ALTO | Fluxo: payment criado → captured → settlement processado → settled status → ledger entries conferidas |
| T-017 | Reconciliation Flow | Testes do fluxo de reconciliação do início ao fim inexistentes | 🟠 ALTO | Fluxo: ledger entries → comparar com provider statement → identificar mismatches → abrir reconciliation case → resolver |
| T-018 | MFA Flow | Testes do fluxo de autenticação multifator inexistentes | 🟠 ALTO | Fluxo: login → desafio MFA (TOTP) → validação → sessão criada → operações protegidas |
| T-019 | RBAC/ABAC Authorization | Testes de autorização por role/policy inexistentes | 🟠 ALTO | Testar operações com diferentes roles; verificar que usuários só podem operações permitidas por alçada |
| T-019 | Rate Limiting | Testes de rate limiting funcionando corretamente inexistentes | 🟡 MÉDIA | Testar envio de N+1 requisições; verificar retorno 429 e headers de rate limit |
| T-019 | API Error Handling | Testes de handling de errors da API inexistentes | 🟡 MÉDIA | Testar cenários de erro: validação falha, not found, conflict; verificar padrão {error: {code, message, request_id}} |
| T-020 | Provider Fallback | Testes de fallover quando provider principal cai inexistentes | 🟡 MÉDIA | Simular queda do provider principal; verificar que Payment Router seleciona provider alternativo; operação continua ou falha controlada |

---

## 3. MEDIUM TEST GAPS (🟡 MÉDIA - Qualidade e Edge Cases)

| GAP ID | Área | Gap Descrição | Impacto | Caso de Teste Essencial |
|--------|------|---------------|---------|------------------------|
| T-021 | Concurrent Payments | Testes de pagamentos concorrentes (simultâneos) inexistentes | 🟡 MÉDIA | Enviar 2 requisições de criação de payment idênticas simultaneamente; verificar consistência do ledger e estado final |
| T-022 | Edge Cases Financeiras | Testes de casos edge financeiros inexistentes | 🟡 MÉDIA | Testar: pagamento exatamente no limite, pagamento com centavos, pagamento com currency diferente do cadastro, pagamento com taxa zero |
| T-023 | Provider Availability | Testes quando provider está indisponível inexistentes | 🟡 MÉDIA | Simular provider down; verificar que Payment Router tenta alternativa; operação falha gracefully |
| T-024 | Cancelamento Temporário | Testes de cancelamento temporário / expirado inexistentes | 🟡 MÉDIA | Testar payment com expiry time; verificar que estado fica EXPIRED após timeout; usuário consegue reactivar ou recriar |
| T-025 | Dados Nulos/Inválidos | Testes com dados nulos/inválidos nos endpoints inexistentes | 🟡 MÉDIA | Testar envio de payloads vazios, campos faltando, tipos errados; verificar mensagens de erro adequadas |
| T-026 | Localization / Currency | Testes de formatação monetária por locale inexistentes | 🟢 BAIXA | Testar exibição de valores: BRL 109,00 vs USD 109,00 vs EUR 109,00; formatacao consistente |
| T-027 | Search e Filtros | Testes de busca e filtros em listagens inexistentes | 🟢 BAIXA | Testar filtros por status, data, merchant, valor; verificar que retornam resultados esperados |
| T-027 | Export/Relatórios | Testes de exportação de relatórios inexistentes | 🟢 BAIXA | Testar exportação CSV/JSON de: payments, transactions, settlements por período |
| T-028 | Notificações | Testes de sistema de notificações inexistentes | 🟢 BAIXA | Testar dispatch de notificações após eventos: payment.created, payment.settled, etc. |
| T-029 | Integração Sandbox | Testes no environment sandbox inexistentes | 🟢 BAIXA | Testar todos flows no sandbox (modo simulado); verificar que nenhum dinheiro real movimentado |
| T-030 | Performance Baseline | Testes de performance/baseline inexistentes | 🟢 BAIXA | Medir response times endpoints críticos; estabelecer benchmarks para regressão |

---

## 4. TEST STRATEGY REQUERIDA

### 3 Levels de Teste Necessários

| Nível | Objetivo | Cobertura Alvo | Ferramentas |
|-------|----------|----------------|-------------|
| **Unit** | Testes de funções/domain isolates | 80%+ das funções services/repositories | Jest/MS Vitest + Testcontainers (mock DB) |
| **Integration** | API → Service → Repository → DB | 70%+ dos endpoints críticos | Supertest + Prisma direct |
| **E2E** | Fluxos completos usuário→banco→settlement | 50%+ dos flows críticos | Cypress / Playwright com banco de teste |

### Test Pyramid Recommendation

```
        E2E (5-10% dos testes)
         ↓
    Integration (15-25% dos testes)
         ↓
    Unit (70-85% dos testes)
```

### Test Data Management

- Utilizar **test databases** isolados (não produzir dados reais)
- Utilizar **fixtures** para dados de teste consistentes
- Utilizar **factories** (ex: faker.js) para dados variados
- **Never usar dados de produção** em testes
- **Cleanup** após cada teste suite (rollback transactions)

### Mock Strategy

| O Que Mockar | Como |
|--------------|------|
| Provider Externos (Stripe, Efí, Circle) | Mock com respostas realistas; usar `msw` ou `jest.mock` |
| Database | Utilizar banco de teste efêmero (Testcontainers Prisma schema) |
| Webhooks | Mock delivery; controlar timeline de retry |
| Cotas FX | Mock cotação com valores fixos e expiry |
| SMS/Email OTP | Mock serviço de envio; validar apenas que OTP foi solicitado |

---

## 4. TEST SUITE ESSENCIAL (MVP)

Este conjunto mínimo de testes deve ser implementado antes de considerar qualquer funcionalidade "production-ready":

| # | Módulo | Testes Essenciais | Prioridade |
|---|--------|-------------------|------------|
| 1 | **Idempotência** | 3 testes: create duplicate, verify 1 transaction, verify ledger balance | 🔴 CRÍTICO |
| 2 | **Ledger Double-Entry** | 4 testes: create payment, verify debit, verify credit, verify balance = 0 initially | 🔴 CRÍTICO |
| 3 | **Payment States** | 6 testes: all valid transitions, 2 invalid transitions blocked | 🔴 CRÍTICO |
| 4 | **Webhook Security** | 3 testes: valid signature accepted, invalid rejected, replay rejected | 🔴 CRÍTICO |
| 5 | **Refund Processing** | 3 testes: create refund, verify ledger reversal, verify status updated | 🔴 CRÍTICO |
| 6 | **Settlement Flow** | 4 tests: create→capture→settle→settled, verify ledger after each step | 🔴 CRÍTICO |
| 7 | **Provider Failover** | 2 tests: primary provider down, fallback provider selected | 🟠 ALTO |
| 8 | **FX Quote Expiry** | 2 tests: quote valid, quote expired rejected | 🟠 ALTO |
| 8 | **RBAC/Authorization** | 3 tests: admin can, operator cannot, read-only cannot | 🟠 ALTO |
| 9 | **Payment Creation Validation** | 3 tests: missing fields rejected, invalid amount rejected, invalid currency rejected | 🟡 MÉDIA |
| 10 | **Error Standardization** | 3 tests: error response format consistent, error codes mapped correctly | 🟡 MÉDIA |

**Total de testes essenciais: 31 testes críticos/altos**

---

## 5. TEST AUTOMATION PIPELINE

| Etapa | Ferramenta | O que validar |
|-------|------------|---------------|
| `git push` | Husky + lint | Code style, type errors |
| `pull request` | GitHub Actions | Run unit + integration tests |
| `merge to main` | GitHub Actions | Run E2E tests + full suite |
| `deployment` | GitHub Actions + smoke test | Validar deployment health checks |
| **Daily** | Cron job | Rodar suite completa + coverage report |
| **Weekly** | Security scan | Rodar `npm audit` + security tests |

---

## 6. COVERAGE METRICS OBJETIVO

| Métrica | Objetivo MVP | Objetivo Production |
|---------|--------------|---------------------|
| Unit Test Coverage | 80% | 90%+ |
| Integration Test Coverage | 70% | 85%+ |
| E2E Test Coverage | 50% dos flows críticos | 80%+ dos flows |
| Critical Path Coverage | 100% dos gaps T-001 a T-011 | 100% |
| Security Test Coverage | 0% (início) | 100% dos gaps S-001 a S-030 |

---
**FIM DO TEST_GAPS.md**