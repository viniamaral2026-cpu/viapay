# VIAPAY — DOCUMENTATION GAPS
# Gap Analysis: Documentation vs Implementation

**Data:** 2026-10-03  
**Objective:** Identify gaps between documented architecture and actual code implementation

---

## 1. DOCUMENTATION INVENTORY

| Document Type | Total Expected | Total Found | Gap | Status |
|---------------|----------------|-------------|-----|--------|
| Master Vision/Strategy | 1 | 1 (VIAPAY-DOCUMENTO-MESTRE-IA.md) | ✅ | Complete |
| Architecture ADRs | 40+ | ~30 (docs/40-adr/) | ⚠️ 10+ missing | Partial |
| Product Specifications | 20+ | ~15 (docs/01-product/) | ⚠️ 5+ missing | Partial |
| API Contracts | 30+ | ~10 (docs/42-api-contracts/) | ❌ 20+ missing | Missing |
| Database Schemas | 10+ | ~5 (docs/32-database/) | ❌ 5+ missing | Missing |
| Security Guidelines | 10+ | ~3 (docs/13-security/, docs/38-privacy/) | ❌ 7+ missing | Missing |
| Compliance Docs | 15+ | ~5 (docs/19-compliance/) | ❌ 10+ missing | Missing |
| Testing Docs | 10+ | ~3 (docs/30-testing/) | ❌ 7+ missing | Missing |
| DevOps Docs | 10+ | ~3 (docs/31-devops/) | ❌ 7+ missing | Missing |
| Operation Guides | 20+ | ~8 (docs/35-operations/) | ❌ 12+ missing | Missing |
| Disaster Recovery | 5+ | ~1 | ❌ 4+ missing | Missing |
| Developer Portal Docs | 15+ | ~2 (docs/13-DEVELOPER-PORTAL/) | ❌ 13+ missing | Missing |
| Sandbox Documentation | 5+ | ~0 | ❌ 5+ missing | Missing |
| Glossário | 1 | ~0 | ❌ 1 missing | Missing |
| API Error Contract | 1 | ~0 | ❌ 1 missing | Missing |
| Architecture Overview | 1 | 1 (docs/02-architecture/) | ✅ | Complete |

**Total Gap Documentação:** ~75 documentos esperados vs ~70 encontrados  
**Gap Percentage:** ~40% dos documentos esperados têm lacunas significativas

---

## 2. GAPS CRÍTICOS DE DOCUMENTAÇÃO

| GAP ID | Área | Gap Descrição | Risco | Ação Corretiva |
|--------|------|---------------|-------|----------------|
| D-001 | API Contracts | Contratos API (rotos, DTOs, endpoints) divergem do código implementado | 🔴 ALTO | Scontrar código ↔ docs; gerar OpenAPI a partir de annotations |
| D-002 | Database Schema | Schema Prisma não acompanhado de documentação ERD atualizada | 🔴 ALTO | Gerar diagrama ERD do schema atual; manter em sincronia |
| D-003 | Architecture ADRs | ADRs (Architecture Decision Records) não refletem decisões de implementation recentes | 🔴 ALTO | Revisar todos os ADRs; atualizar status "implemented/proposed/deprecated" |
| D-004 | API Error Contract | Padrão de resposta de erro não documentadoconsistentemente | 🔴 ALTO | Documentar padrão {error: {code, message, request_id, correlation_id}} e aplicar em todos endpoints |
| D-005 | Developer Portal | Developer Portal documentado mas não existe implementação funcional | 🔴 ALTO | Criar portal ou remover referências da documentação |
| D-006 | Sandbox Guide | Referências a sandbox em docs sem implementação correspondente | 🟠 ALTO | Implementar sandbox ou remover da documentação |
| D-007 | API Versioning | Documentação não especifica versionamento /api/v1 vs /api/v2 | 🟠 ALTO | Adicionar especificação de versionamento em todos docs de API |
| D-008 | Security Guidelines | Guidelines de segurança não compilam decisões arquiteturais atuais | 🟠 ALTO | Revisar e documentar controls implementados vs necessários |
| D-009 | Compliance Docs | Documentos KYC/KYB/AML existem mas não mapeiam requisitos reais | 🟡 MÉDIA | Auditar requisitos regulatórios e atualizar docs |
| D-010 | Testing Strategy | Estratégia de testes documentada mas suite inexistente | 🟡 MÉDIA | Documentar strategy ou implementar testes conforme descrito |

---

## 3. GAPS DE DOCUMENTAÇÃO POR CAMADA

### 3.1 Domain Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| Entity Definitions | ⚠️ PARCIAL | Algumas entidades documentadas, outras não |
| Repository Interfaces | ❌ AUSENTE | Nenhum repositório tem documentação de contrato |
| Domain Events | ❌ AUSENTE | Nenhum evento domain documentado |
| Value Objects | ⚠️ PARCIAL | Alguns value objects têm documentação |

### 3.2 Application Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| Use Cases | ⚠️ PARCIAL | Alguns use cases documentados |
| DTOs | ❌ AUSENTE | Nenhum DTO tem documentação completa |
| Validation Rules | ❌ AUSENTE | Nenhuma regra de validação documentada |
| Mapping | ❌ AUSENTE | Mapeamento entity↔DTO não documentado |

### 3.3 Infrastructure Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| Repository Implementations | ❌ AUSENTE | Nenhum repository tem documentação |
| Adapters (Stripe, Efí, Solana) | ❌ AUSENTE | Nenhum adapter tem documentação |
| Database Migrations | ⚠️ PARCIAL | Algumas migrations têm comments |
| External APIs | ❌ AUSENTE | Integrações externas sem docs |

### 3.4 API Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| OpenAPI Specification | ❌ AUSENTE | Nenhum arquivo openapi.yaml/json encontrado |
| Endpoint Documentation | ❌ AUSENTE | Nenhum endpoint tem descrição |
| Request/Response Examples | ❌ AUSENTE | Nenhum exemplo de request/response |
| Error Codes Listing | ❌ AUSENTE | Nenhum código de erro catalogado |

### 3.5 Security Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| RBAC/ABAC Documentation | ❌ AUSENTE | Nenhum documento sobre roles/permissions |
| MFA Implementation | ❌ AUSENTE | Nenhum documento sobre autenticação multifator |
| Secrets Management | ❌ AUSENTE | Nenhum documento sobre gestão de segredos |
| Audit Logging | ❌ AUSENTE | Nenhum documento sobre what/when/how auditar |

### 3.6 Frontend Layer

| Documento | Status | Observação |
|-----------|--------|-----------|
| Component Library | ✅ BOA | 67 diretórios documentados visualmente |
| Page Conventions | ⚠️ PARCIAL | Algumas páginas seguem padrão, outras não |
| State Management | ❌ AUSENTE | Nenhum documento sobre gerenciamento de state |
| Accessibility | ⚠️ PARCIAL | Algumas partes consideram accessibility |
| Responsive Breakpoints | ⚠️ PARCIAL | Breakpoints não documentados consistentemente |

### 3.7 DevOps/Deployment

| Documento | Status | Observação |
|-----------|--------|-----------|
| Docker Configuration | ⚠️ PARCIAL | Dockerfile e docker-compose existentes |
| Environment Variables | ❌ AUSENTE | Lista de env vars não documentada |
| CI/CD Pipeline | ❌ AUSENTE | Nenhum pipeline documentado |
| Health Checks | ❌ AUSENTE | Nenhum health check definido |
| Deployment Steps | ❌ AUSENTE | Passo a passo não documentado |

### 3.8 Financeiro/Compliance

| Documento | Status | Observação |
|-----------|--------|-----------|
| Ledger Documentation | ❌ AUSENTE | Nenhum documento sobre contabilidade double-entry |
| FX Engine Documentation | ❌ AUSENTE | Nenhum doc sobre motor de câmbio |
| Fee/Commission Structure | ❌ AUSENTE | Taxas e comissões não documentadas |
| Settlement Workflow | ❌ AUSENTE | Workflow de settlement não documentado |
| Reconciliation Process | ❌ AUSENTE | Processo de reconciliação não documentado |

---

## 4. GAPS DE VERSIONAMENTO

| GAP ID | Problema | Impacto | Ação |
|--------|----------|---------|------|
| V-001 | Código não versionado semanticamente | Confusion sobre versão atual | Implementar versionamento semântico git tags |
| V-002 | OpenAPI não versionada | Contrato API diverge entre environments | Versionar OpenAPI junto com release |
| V-003 | Migrations não versionadas | Schema DB muda sem registro | Aplicar naming convention consistente em migrations |
| V-004 | Docs não versionadas | Atualizações de doc não rastreadas | Versionar docs junto com code changes |

---

## 5. GAPS DE CONSISTÊNCIA DOCUMENTO ↔ CÓDIGO

| GAP ID | Área | Tipo de Inconsistência | Severity |
|--------|------|------------------------|----------|
| C-001 | Rotas API | Documentos listam endpoints que não existem no código | 🔴 CRÍTICO |
| C-002 | Campos Entity | Documentos descrevem campos que não estão no schema Prisma | 🔴 CRÍTICO |
| C-003 | Estados Payment | Documentos listam estados que não são implementados no domínio | 🔴 CRÍTICO |
| C-004 | Camadas | Documentos descrevem arquitetura que não é implementada | 🔴 CRÍTICO |
| C-005 | Contratos | Contratos definidos em docs divergem do TypeScript types | 🟠 ALTO |
| C-006 | Fluxos | Documentos descrevem fluxos que não correspondem ao código | 🟠 ALTO |
| C-007 | Configurações | Documentos listam configurações que não são lidas pelo código | 🟡 MÉDIA |
| C-008 | Bibliotecas | Documentos recomendam bibliotecas que não são usadas | 🟡 MÉDIA |

---

## 6. REQUERIMENTOS MINIMOS DE DOCUMENTAÇÃO PARA PRODUÇÃO

Para considerar o VIAPAY pronto para estágio avançado, a documentação deve satisfazer:

| Requisito | Status Atual | Faltando |
|-----------|--------------|----------|
| Todo código tem comentário de propósito | ❌ | ~80% dos arquivos de service/controller |
| Toda API tem OpenAPI espec | ❌ | Do zero |
| Todo banco tem ERD atualizado | ❌ | Do zero |
| Todo ADR tem status implementado/pending/deprecated | ⚠️ | ~30% com status deficiente |
| Todo erro API tem código/mensagem consistente | ❌ | Do zero |
| Todo ambiente tem variáveis documentadas | ❌ | Lista completa |
| Todo fluxo crítico tem teste E2E | ❌ | Do zero |
| Sandbox tem guide documentada | ❌ | Do zero |
| Developer portal tem auth + SDKs | ❌ | Do zero |
| Compliance docs mapeiam requisitos reais | ❌ | Mapear KYC/KYB/AML requirements |

---

## 7. PRIORIZAÇÃO DE DOCUMENTAÇÃO

### Fase 1 - Crítica (Semana 1-2)
- [ ] D-001: Scontrar API contracts código ↔ docs
- [ ] D-002: Gerar ERD do schema Prisma
- [ ] D-003: Atualizar todos os ADRs com status corrente
- [ ] D-004: Documentar padrão de erro API

### Fase 2 - Alta (Semana 3-4)
- [ ] D-005: Implementar Developer Portal funcional ou remover refs
- [ ] D-006: Implementar sandbox + guide
- [ ] D-007: Especificar versionamento API
- [ ] D-008: Revisar security guidelines

### Fase 3 - Média (Semana 5-8)
- [ ] Documentação por camada (domain, application, infrastructure, API, security, frontend, devops)
- [ ] Documentação financeira (ledger, fx, fees, settlement, reconciliation)
- [ ] Documentação de compliance (KYC, KYB, AML)

### Fase 4 - Baixa (Semana 9+)
- [ ] Glossário
- [ ] Guias operacionais detalhadas
- [ ] Relatórios formatados
- [ ] Templates de comunicação

---
**FIM DO DOCUMENTATION_GAPS.md**