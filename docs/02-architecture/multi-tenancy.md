
# Multi-Tenancy

## Modelo

A plataforma deve suportar múltiplas instituições.

Cada requisição autenticada deve possuir um tenant context.

```text
TenantContext
├── tenant_id
├── organization_id
├── actor_id
├── roles
├── permissions
├── scopes
└── correlation_id
```

## Isolamento

Todas as entidades tenant-aware devem possuir:

```text
tenant_id
```

A aplicação deve impedir acesso cruzado entre tenants.

## Estratégias

### Shared database

Mais simples e eficiente inicialmente.

### Schema per tenant

Maior isolamento, maior custo operacional.

### Database per tenant

Maior isolamento e custo.

A estratégia final deve considerar requisitos regulatórios e volume.
