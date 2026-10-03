# VIAPAY — API GAPS
# API Gap Analysis: Contracts vs Implementation

**Data:** 2026-10-03  
**Objective:** Identify gaps between API contracts/specifications and actual implementation

---

## 1. API ENDPOINTS INVENTORY

### 1.1 Expected vs Found Endpoints

| Category | Expected Endpoints | Found Endpoints | Gap | Status |
|----------|-------------------|-----------------|-----|--------|
| Payments | 15 | 5 | ❌ 10 missing | Critical |
| Payment Intents | 8 | 2 | ❌ 6 missing | Critical |
| Cards | 6 | 1 | ❌ 5 missing | Critical |
| PIX | 8 | 3 | ❌ 5 missing | Critical |
| Transfers | 6 | 1 | ❌ 5 missing | Critical |
| Settlements | 6 | 1 | ❌ 5 missing | Critical |
| Reconciliation | 5 | 0 | ❌ 5 missing | Critical |
| FX | 6 | 1 | ❌ 5 missing | Critical |
| Webhooks | 8 | 2 | ❌ 6 missing | Critical |
| Customers | 6 | 2 | ❌ 4 missing | High |
| Merchants | 6 | 2 | ❌ 4 missing | High |
| Accounts | 6 | 1 | ❌ 5 missing | High |
| Institutions | 5 | 0 | ❌ 5 missing | High |
| Subscriptions | 4 | 0 | ❌ 4 missing | Medium |
| Refunds | 5 | 1 | ❌ 4 missing | Medium |
| Charges | 4 | 0 | ❌ 4 missing | Medium |
| Payouts | 4 | 0 | ❌ 4 missing | Medium |
| Webhook Events | 10 | 2 | ❌ 8 missing | High |
| Identity | 5 | 1 | ❌ 4 missing | Medium |
| Onboarding | 4 | 0 | ❌ 4 missing | Medium |
| Settings | 5 | 1 | ❌ 4 missing | Medium |

**Total:** 122 expected vs 33 found = ❌ 89 gaps (73% missing)

---

## 2. API CONTRACT GAPS

### 2.1 Versionamento

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-001 | Nenhum versionamento /api/v1 visível no código | 🔴 CRÍTICO | Implementar prefixo /api/v1 em todas rotas; documentar versionamento |
| API-002 | OpenAPI não versionada | 🔴 CRÍTICO | Gerar/openapi.yaml versionado junto com releases |
| API-003 | Routes não têm versionamento consistente | 🔴 CRÍTICO | Garantir todas routes começam com /api/v1 ou /api/v2 |

### 2.2 Padrão de Request/Response

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-004 | Padrão de resposta { data, meta, error } não aplicado consistentemente | 🔴 CRÍTICO | Definir e aplicar padrão em todos endpoints; criar middleware de resposta padronizado |
| API-005 | Erros seguem { error: { code, message, request_id, correlation_id } } | 🔴 CRÍTICO | Implementar handler global de erro seguindo padrão |
| API-006 | Request validation não consistente | 🟠 ALTO | Implementar validação global (Zod/Yup) com schemas por endpoint |
| API-007 | Parâmetros oppcionais/m Obrigatórios não definidos em contrato | 🟠 ALTO | Definir schemas OpenAPI/TypeScript para todos endpoints |

### 2.3 Authentication & Authorization

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-008 | Nenhuma auth middleware global implementada | 🔴 CRÍTICO | Criar middleware de auth que verifica API Key / JWT em todas rotas protegidas |
| API-009 | Authorization por recurso inexistente | 🔴 CRÍTICO | Implementar policy-based authorization guards |
| API-010 | MFA não integrada em API endpoints | 🟠 ALTO | Integrar validação MFA em rotinas sensíveis |
| API-011 | Rate limiting por endpoint não implementado | 🟠 ALTO | Implementar middleware rate-limit global |
| API-012 | API Keys management não existe | 🟠 ALTO | Criar sistema de API Key generation, validation, rotation, revocation |

### 2.4 Payment-Specific Endpoints

| GAP ID | Endpoint | Status | Gap Details |
|--------|----------|--------|-------------|
| API-013 | POST /api/v1/payment-intents | ❌ Missing | Não encontrado no código; criar conforme spec |
| API-014 | GET /api/v1/payment-intents/{id} | ❌ Missing | Não encontrado; criar para consultar status |
| API-015 | POST /api/v1/payment-intents/{id}/confirm | ❌ Missing | Não encontrado; flow de confirmação |
| API-016 | POST /api/v1/payments/{id}/refund | ❌ Missing | Não encontrado; processar reembolso |
| API-017 | GET /api/v1/payments/{id} | ❌ Missing | Não encontrado; consultar payment details |
| API-018 | POST /api/v1/settlements | ❌ Missing | Não encontrado; processar settlement |
| API-019 | GET /api/v1/settlements/{id} | ❌ Missing | Não encontrado; status settlement |
| API-020 | POST /api/v1/webhooks | ❌ Missing | Não encontrado; registrar webhook |
| API-021 | GET /api/v1/webhooks/{id}/deliveries | ❌ Missing | Não_found; histórico deliveries |
| API-022 | POST /api/v1/payments/{id}/cancel | ❌ Missing | Não encontrado; cancelar payment |
| API-023 | GET /api/v1/quotes | ❌ Missing | Não encontrado; cotação FX |
| API-024 | GET /api/v1/reconciliation | ❌ Missing | Não encontrado; dashboard reconciliation |
| API-025 | GET /api/v1/transactions | ❌ Missing | Não encontrado; listagem transactions |
| API-026 | POST /api/v1/customers | ⚠️ Partial | Existente mas incompleto |
| API-027 | GET /api/v1/customers/{id} | ⚠️ Partial | Existente mas incompleto |
| API-028 | POST /api/v1/merchants | ⚠️ Partial | Existente mas incompleto |
| API-029 | GET /api/v1/merchants/{id} | ⚠️ Partial | Existente mas incompleto |

---

## 3. OPENAPI/SWAGGER GAPS

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-013 | Nenhum arquivo openapi.yaml ou openapi.json encontrado no repositório | 🔴 CRÍTICO | Gerar especificação OpenAPI a partir de annotations/routes |
| API-014 | Documentação Swagger UI não existe em ambiente nenhum | 🔴 CRÍTICO | Criar endpoint /api-docs ou servir spec via Swagger |
| API-015 | Exemplos de request/response por endpoint não documentados | 🟠 ALTO | Adicionar examples em openapi spec |
| API-016 | Codes de erro listing não existe | 🟠 ALTO | Catalogar todos codes de erro possíveis e seus significados |
| API-017 | Tags por endpoint não consistentes | 🟡 MÉDIA | Padronizar tags em openapi (payments, fx, settlement, etc.) |
| API-018 | Servidores (servers) não definidos em spec | 🟡 MÉDIA | Definir servers base URL por ambiente (dev, staging, production) |

---

## 4. AUTENTICAÇÃO API GAPS

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-019 | Nenhum middleware de auth global no apps/api | 🔴 CRÍTICO | Criar middleware que verifica authentication em todas rotas protected |
| API-020 | API Keys não implementadas | 🟠 ALTO | Criar sistema: generate key, validate key, rotate key, revoke key |
| API-021 | OAuth2 / client-credentials não implementado | 🟠 ALTO | Implementar flow OAuth2 onde aplicável (b2b integrations) |
| API-023 | MFA validation em API | 🟠 ALTO | Integrar validação MFA para operações sensíveis |
| API-024 | Rate limiting por tenant/IP não existe | 🟠 ALTO | Implementar middleware com contador Redis por tenant/IP |
| API-024 | Tokens JWT expiração não definida consistentemente | 🟡 MÉDIA | Definir TTL consistente; usar refresh tokens flow |

---

## 5. PARA-DE-ORDEM DE PRIORIDADES DA API

### P0 - Crítico (Imediato)

- [ ] Implementar versionamento /api/v1 em todas rotas
- [ ] Criar middleware de auth global (API Key / JWT verification)
- [ ] Padrão de resposta { data, meta, error }
- [ ] Padrão de erro { error: { code, message, request_id, correlation_id } }
- [ ] Implementar validação global de request (Zod/Yup)
- [ ] Criar endpoints essenciais: payment-intents, payments, settlements, webhooks

### P1 - Alta (Semana 1-2)

- [ ] Implementar remaining payment-specific endpoints
- [ ] Rate limiting por tenant/IP
- [ ] API Keys system
- [ ] Rate limiting middleware
- [ ] Consistência nos routes versionados

### P2 - Média (Semana 3-4)

- [ ] OpenAPI/Swagger specification gerada
- [ ] Documentação de cada endpoint com examples
- [ ] Error codes catalogado
- [ ] MFA integration em endpoints sensíveis
- [ ] Refresh token flow implementado

### P3 - Baixa (Semana 5+)

- [ ] Versionamento v2 planejado
- [ ] Deprecation policy para v1
- [ ] GraphQL alternative (opcional)
- [ ] API version migration guide

---

## 6. GAPS DE INTEgraÇÃO EXTERNA

| GAP ID | Provedor | Endpoints Esperados | Implementado | Ação |
|--------|----------|--------------------|--------------|------|
| API-030 | Stripe | 15+ endpoints | ❌ | Criar StripeAdapter + endpoints |
| API-031 | Efí | 10+ endpoints | ❌ | Criar EfiAdapter + endpoints |
| API-032 | Circle/USDC | 8+ endpoints | ❌ | Criar CircleAdapter + endpoints |
| API-033 | PIX | 8+ endpoints | ⚠️ Partial | Integrar no Payment Router; endpoints já parcialmente no frontend |
| API-034 | Bank (COBOL/REST/SOAP) | 12+ endpoints | ❌ | Criar bank adapters (REST, SOAP, SFTP, ISO20022) |

---

## 7. TESTES DE API

| GAP ID | Descrição | Impacto | Ação |
|--------|-----------|---------|------|
| API-035 | Nenhum teste de contrato (contract test) existe | 🔴 CRÍTICO | Criar suite de contrato tests comparando spec ↔ implementação |
| API-036 | Testes de integração API → DB inexistentes | 🔴 CRÍTICO | Criar testes que validem: request → service → repository → response |
| API-037 | Testes E2E API flow inexistentes | 🔴 CRÍTICO | Criar testes flows completos: checkout → payment → settlement |
| API-038 | Testes de rate limiting não existirem | 🟠 ALTO | Testar que endpoints retornam 429 quando limite excedido |
| API-039 | Testes de validação de erro não existirem | 🟠 ALTO | Testar que erros seguem padrão definido |
| API-040 | Mock de provedores externos não consistente | 🟡 MÉDIA | Garantir mocks refletem comportamento real dos providers |

---
**FIM DO API_GAPS.md**