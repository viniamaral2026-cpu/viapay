# Sandbox Security Model

## Authentication

Todas as APIs devem exigir autenticação.

Métodos previstos:

- API Key
- OAuth 2.0
- Client Credentials
- JWT quando aplicável

## API Keys

As chaves devem possuir:

- key_id
- secret
- environment
- merchant_id
- scopes
- created_at
- expires_at
- revoked_at

## Nunca armazenar

Nunca armazenar secrets em texto puro.

Utilizar hash ou secret manager conforme o mecanismo adotado.

## RBAC

Papéis previstos:

- developer
- merchant_admin
- integration_admin
- auditor

## Scopes

Exemplos:

payments:read
payments:write
transfers:read
transfers:write
fx:read
fx:write
webhooks:read
webhooks:write
sandbox:admin

## Rate limiting

O Sandbox deve possuir limites próprios.

Nunca compartilhar limites com produção.

## Audit

Registrar:

actor
action
timestamp
request_id
ip
resource
resource_id
result
