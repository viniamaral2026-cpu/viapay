# VIAPAY — SECURITY GAPS
# Security Gap Analysis

**Data:** 2026-10-03  
**Objective:** Identify security gaps and critical vulnerabilities

---

## 1. CRITICAL SECURITY GAPS (🔴 CRÍTICO - Immediate Action Required)

| GAP ID | Área | Descrição do Gap | Risco | Ação Imediata |
|--------|------|------------------|-------|---------------|
| S-001 | Secrets Management | Secrets/credentials possibly stored in.env files or git history | 🔴 EXTREMO | Auditoriar todo repositório em busca de secrets; remover imediatamente; implementar secret manager (Vault/Param Store) |
| S-002 | Hardcoded Credentials | Possível existência de credenciais hardcoded no código-fonte | 🔴 EXTREMO | Search: `password`, `secret`, `key`, `token` em todo código-fonte; rotação imediata de quaisquer credentials expostos |
| S-003 | JWT Configuration | Segredos JWT pode estar configurado de forma insegura | 🔴 ALTO | Revisar JWT secret key; garantir 256+ bits de entropy; usar ambiente seguro de geração |
| S-004 | Rate Limiting | Rate limiting por endpoint/ip não implementado | 🔴 ALTO | Implementar middleware de rate limiting (ex: express-rate-limit, redis-backed); política por IP e por tenant |
| S-005 | Webhook Signature Validation | Webhooks recebidos sem verificação de assinatura HMAC | 🔴 ALTO | Implementar verificação de signature por provider (Stripe, Efí, Circle); secrets por webhook |
| S-006 | Idempotency Key Validation | Operações financeiras não validam idempotency key | 🔴 ALTO | Validar idempotency key em create/payment/refund/capture; retornar resultado idêntico para mesma key |
| S-007 | Replay Protection | Proteção contra replay de webhooks/transações inexistente | 🔴 ALTO | Manter tabela de eventos processados com idempotency key + timestamp; rejeitar duplicates |
| S-008 | SQL Injection | Embora usando Prisma (parameterized), validação de entrada insuficiente em rotas customas | 🟠 MEDIUM | Garantir que todas queries usam prepared statements; audit code para raw SQL |
| S-009 | Session Management | Sessões sem configurações de segurança adequadas | 🟠 MEDIUM | Implementar cookieSameSite=strict, cookieSecure (HTTPS only), session timeout, rotation após login |
| S-010 | Anti-Fraud Controls | Controles antifraud básicos (velocity limits, suspicious detection) inexistentes | 🟠 MEDIUM | Implementar: max attempts por hora, bloqueio temporário, flags de risco transação |

---

## 2. HIGH SECURITY GAPS (🟠 ALTO - Próximas 2 Sprints)

| GAP ID | Área | Descrição do Gap | Risco | Ação Corretiva |
|--------|------|------------------|-------|----------------|
| S-011 | RBAC/ABAC Implementation | RBAC e ABAC não implementados no código | 🟠 ALTO | Criar roles (SUPER_ADMIN, BANK_ADMIN, OPERATIONS, COMPLIANCE, RISK, FINANCE, AUDITOR, SUPPORT, DEVELOPER, MERCHANT_ADMIN, MERCHANT_OPERATOR, READ_ONLY); implementar guards/filters por role |
| S-012 | MFA (Multi-Factor Authentication) | MFA não implementado em nenhum lugar | 🟠 ALTO | Implementar suporte: TOTP (Google Authenticator/Authy), WebAuthn/passkeys, OTP via e-mail/SMS; recovery codes |
| S-013 | API Authentication | Endpoints de API sem autenticação consistente | 🟠 ALTO | Implementar auth guard global: API Keys no header Authorization: Bearer <token> ou api-key <key>; OAuth2 client-credentials onde aplicável |
| S-014 | API Authorization | Autorização por recurso não implementada | 🟠 ALTO | Implementar policy-based authorization: usuário pode acessar recurso somente se: pertence à mesma institution, tem role adequada, MFA válido, operação permitida por alçada |
| S-015 | Input Validation | Validação de entrada inconsistente em endpoints | 🟠 ALTO | Implementar validação global usando Zod/Yup; schema por endpoint; rejeitar antes de processar |
| S-014 | CORS Configuration | Configuração CORS pode permitir origens indevidas | 🟠 ALTO | Revisar origins permitidas; especificar apenas origens da instituição; não usar wildcard em produção |
| S-016 | Content Security Policy | CSP não configurada no frontend | 🟠 ALTO | Implementar CSP header restrictindo sources (script-src, style-src, img-src, connect-src, font-data) |
| S-017 | Secrets in Frontend | Secrets/keys possibly acessíveis no frontend | 🟠 ALTO | Garantir que NADA de secrets esteja no frontend; API keys devem ser somente backend |
| S-018 | Encryption at Rest | Dados sensíveis possivelmente não criptografados no banco | 🟡 MEDIUM | Avaliar se dados sensíveis (CPF, chaves criptográficas) devem ser encrypted at rest; implementar se necessário |
| S-019 | Audit Log Completeness | Audit log não cobre todas operações financeiras críticas | 🟠 ALTO | Estender audit logging a: todas as criações/alterações de payment, transaction, settlement, refund, webhook, user auth, role change; incluir actor, timestamp, action, resource, changes (before/after) |
| S-020 | Data Classification | Dados não classificados (público, interno, confidencial, restrito) | 🟡 MEDIUM | Classificar dados sensíveis; aplicar controles diferentes por classificação; LGPD compliance |

---

## 3. MEDIUM SECURITY GAPS (🟡 MEDIUM - Backlog)

| GAP ID | Área | Descrição do Gap | Risco | Ação |
|--------|------|------------------|-------|------|
| S-021 | Database Encryption | Dados sensíveis podem não estar criptografados no PostgreSQL | 🟡 MEDIUM | Considerar pgp_sym_encrypt para dados altamente sensíveis; TDE (Transparent Data Encryption) do PostgreSQL |
| S-022 | Error Messages | Messages de erro podem vazar informações sensíveis | 🟡 MEDIUM | Padronizar messages de erro: nunca expor stack trace, dados de banco, credenciais; retornar apenas código + mensagem genérica |
| S-023 | Logging Sensitivity | Logs podem conter dados sensíveis (CPF, valores, tokens) | 🟡 MEDIUM | Implementar sanitização de logs; nunca logar dados financeiros completos; usar máscara em outputs de log |
| S-024 | Dependency Vulnerabilities | node_modules pode conter vulnerabilidades conhecidas | 🟡 MEDIUM | Executar `npm audit` regularmente; atualizar dependências; usar dependabot ou equivalente |
| S-025 | HTTPS/ TLS | Configuração TLS pode não ser ótima para ambiente de produção | 🟡 MEDIUM | Forçar TLS 1.2+; configurar ciphers seguros; renovar certificates automaticamente |
| S-026 | Security Headers | Headers de segurança HTTP não definidos | 🟡 MEDIUM | Adicionar headers: X-Content-Type-Options: nosniff, X-Frame-Options: DENY, X-XSS-Protection: 1; mode=block, Strict-Transport-Security |
| S-027 | Password Policy | Política de senha não definida nem aplicada | 🟡 MEDIUM | Definir política: min length 12, complexity requirements, expire after N days, breach check via HaveIBeenPwned |
| S-028 | Key Rotation | Chaves (API, JWT, encryption) não rotacionadas periodicament | 🟡 MEDIUM | Implementar schedule de rotação (30/60/90 days dependendo do tipo de key) |
| S-029 | Secure Headers | Headers de segurança ausentes em responses API | 🟡 MEDIUM | Middleware global que adiciona security headers em todas respostas |
| S-030 | Origin Validation | Validação de origin em webhooks pode ser fraca | 🟡 MEDIUM | Validar origin header em webhooks; rejeitar de origens não esperadas |

---

## 4. SECURITY TESTING GAPS

| GAP ID | Área | Descrição | Impacto |
|--------|------|-----------|---------|
| S-031 | Penetration Testing | Nenhum teste de penetração realizado no projeto | 🔴 CRÍTICO | Contratar/security firm realizar teste ou usar ferramentas automatizadas (OWASP ZAP, SonarQube) |
| S-032 | Security Headers Test | Testes de security headers não existirem | 🟠 ALTO | Criar testes que verificam presença de headers esperados em todas respostas |
| S-033 | Authentication Bypass Tests | Testes que tentam autenticação bypass não existirem | 🔴 CRÍTICO | Criar testes tentando bypass: headers faltando, tokens inválidos, roles inadequadas |
| S-034 | Rate Limiting Test | Testes de rate limiting não existirem | 🟡 MEDIUM | Testar que limites são aplicados e retornam 429 quando excedido |
| S-035 | Idempotency Tests | Testes de idempotência inexistentes (crítico financeiro) | 🔴 CRÍTICO | Testar: enviar mesma requisição 2x; verificar que apenas 1 operação financeira ocorre |
| S-036 | Webhook Security Tests | Testes de segurança de webhooks não existirem | 🟠 ALTO | Testar: signature inválida rejeitada, replay rejeitado, payload tampered rejeitado |
| S-037 | Penetration Testing | Nenhum teste de penetração realizado | 🔴 CRÍTICO | Agendar teste de segurança externo ou interno completo |

---

## 5. COMPLIANCE & REGULATORY GAPS

| GAP ID | Área | Descrição | Impacto | Status Regulatório |
|--------|------|-----------|---------|-------------------|
| S-037 | LGPD / GDPR | Conformidade com Lei Geral de Proteção de Dados não verificada | 🔴 CRÍTICO | Auditar: que dados são coletados, por que, por quanto tempo, como são armazenados/eliminados; Designar DPO se necessário |
| S-038 | KYC/KYB | Módulos KYC/KYB não implementados | 🔴 CRÍTICO | Implementar interfaces; integrar com provedores ou definir requisitos regulatórios |
| S-039 | AML/CFT | Anti-Money Laundering / Counter Financing of Terrorism não implementado | 🔴 CRÍTICO | Implementar transaction monitoring, risk scoring, velocity limits, suspicious activity reporting |
| S-040 | Sanctions Screening | Screenig de sanções não implementado | 🟠 ALTO | Integrar com provedor ou criar lista interna; verificar clientes/beneficiários contra listas internacionais |
| S-041 | Transaction Monitoring | Monitoramento de transações suspeitas não implementado | 🟠 ALTO | Criar regras de monitoring: valor atípico, frequência alta, padrões conhecidos de fraude |
| S-042 | Velocity Limits | Limites de velocidade (transações por período) não existirem | 🟡 MEDIUM | Implementar limits configuráveis por cliente/merchant/institution |
| S-043 | Geolocation Restrictions | Restrições geográficas não implementadas | 🟡 MEDIUM | Implementar country/region restrictions por merchant/institution |
| S-044 | Reporting Obligations | Obrigações de relatório regulatório não documentadas | 🟡 MEDIUM | Identificar requisitos regulatórios; criar reporting pipeline onde aplicável |

---

## 6. SECURITY BY DESIGN RECOMMENDATIONS

### 6.1 Princípios Obrigatórios

1. **Least Privilege:** Usuários/systems só devem ter acesso mínimo necessário
2. **Defense in Depth:** Múltiplas camadas de segurança (não confiar em uma única)
3. **Fail Securely:** Sistema deve falhar de maneira segura, não revelar informações sensíveis
4. **Keep it Simple:** Segurança complexa gera brechas; implementar o necessário e nada mais que o arrisque
5. **Verify Never Trust:** Sempre validar input, assinaturas, tokens, identities

### 6.2 Segregação por Ambiente

| Ambiente | Segredos | Acesso | Observações |
|----------|----------|--------|-------------|
| Development | .env com secrets | Acesso livre desenvolvedores | NÃO commitar .env com secrets |
| Test | Secrets simulados ou masked | Acesso time de testes | Usar secrets de test diferentes |
| Staging | Secrets de staging | Acesso restrito | Espelhando produção mínimamente |
| Production | Secrets gerenciados | Acesso restrito por necessidade | Usar secret manager (Vault, AWS Parameter Store, Azure Key Vault) |

### 6.3 Secrets Management

- Nunca commitar secrets no Git
- Usar variáveis de ambiente para desenvolvimento
- Usar secret manager para produção
- Rotacionar chaves periodicamente
- Fazer audit de acesso a secrets
- Nunca logar secrets

### 6.4 Data Protection

- Criptografar dados sensíveis at rest (PII, chaves, valores financeiros)
- Usar TLS 1.2+ para todos communications
- Implementar máscara/tokenização de dados sensíveis em logs
- Anonimizar dados em ambientes non-production
- Retention policy clara para dados pessoais (LGPD compliance)

### 6.5 Incident Response

- Documentar procedure de security incident
- Manter logs de segurança por período mínimo
- Definir escalation path
- Testar incident response procedure quarterly

---

## 7. SECURITY ROADMAP

| Fase | Atividades | Prazo |
|------|------------|-------|
| **Fase 1 - Imediata (1 semana)** | [S-001] Auditorar secrets no git; [S-002] Remover/rodar credentials expostas; [S-005] Implementar webhook signature validation; [S-006] Validar idempotency key; [S-011] Implementar RBAC básico | Semana 1 |
| **Fase 2 - Alta (2 semanas)** | [S-003] Corrigir JWT config; [S-004] Implementar rate limiting; [S-007] Implementar replay protection; [S-012] Implementar MFA; [S-013] Implementar auth global; [S-014] Implementar authorization policies; [S-015] Implementar input validation global; [S-016] Implementar CSP no frontend; [S-017] Garantir secrets no frontend; [S-019] Estender audit logging operações financeiras críticas | Semana 2-3 |
| **Fase 3 - Média (4 semanas)** | [S-018] Avaliar encryption at rest; [S-020] Classificar dados; [S-031] Agendar penetration testing; [S-032] Testes security headers; [S-033] Testes auth bypass; [S-034] Testes rate limiting; [S-035] Testes idempotência; [S-036] Testes webhook security; [S-037] Auditar LGPD compliance; [S-038] Implementar KYC/KYB interfaces; [S-039] Implementar AML/CFT básico | Semana 4-8 |
| **Fase 4 - Baixa (8+ semanas)** | [S-021] Database encryption evaluation; [S-022] Padronizar error messages; [S-023] Sanitizar logs; [S-024] Dependency vulnerability monitoring; [S-025] OTLS config otimization; [S-026] Security headers middleware; [S-027] Password policy implementation; [S-028] Key rotation schedule; [S-029] Global security headers middleware; [S-030] Origin validation webhooks | Semana 8+ |

---
**FIM DO SECURITY_GAPS.md**