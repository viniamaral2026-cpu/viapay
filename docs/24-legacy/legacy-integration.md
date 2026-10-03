
# Legacy Integration

## Objetivo

Permitir integração com sistemas bancários existentes sem exigir substituição
imediata do core legado.

## Padrão

```text
Legacy Core
    │
    │ Adapter
    ▼
Integration Layer
    │
    ▼
Via Pay
```

## Estratégia

A plataforma deve suportar:

* REST;
* SOAP;
* MQ;
* files;
* SFTP;
* TCP;
* adapters proprietários.

## Anti-Corruption Layer

Sistemas legados não devem contaminar o modelo de domínio moderno.

O adapter converte:

```text
Legacy DTO
     ↓
Canonical DTO
     ↓
Domain Model
```

