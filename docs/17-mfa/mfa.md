
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
