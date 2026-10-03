
# Identity and Access

## Authentication

Métodos possíveis:

* OIDC;
* OAuth2;
* SAML;
* MFA;
* hardware security key;
* service accounts.

## Service Account

Cada integração deve possuir identidade própria.

Nunca utilizar credencial compartilhada por vários serviços.

## Sessions

Sessões devem possuir:

* expiration;
* rotation;
* revocation;
* device context;
* audit trail.
  EOF

# ------------------------------------------------------------------------------

# RBAC ABAC

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/15-rbac-abac/rbac-abac.md" <<'EOF'

# RBAC / ABAC

## RBAC

Controle baseado em função.

Exemplos:

```text
SUPER_ADMIN
ADMIN
MANAGER
OPERATOR
COMPLIANCE
AUDITOR
SUPPORT
DEVELOPER
READ_ONLY
```

## ABAC

Controle baseado em atributos.

Exemplos:

* tenant;
* branch;
* country;
* transaction amount;
* currency;
* risk level;
* account;
* time;
* IP;
* device.

## Exemplo

Um operador pode iniciar pagamentos até determinado limite.

Um gerente pode aprovar operações dentro de sua alçada.

Um auditor pode visualizar registros, mas não alterá-los.

## Separation of Duties

A pessoa que cria uma operação de alto valor não deve necessariamente poder
aprová-la sozinha.
