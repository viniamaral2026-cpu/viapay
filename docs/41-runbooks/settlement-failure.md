
# Runbook — Settlement Failure

## Diagnóstico

Verificar:

* provider;
* status;
* timeout;
* external reference;
* retry count;
* ledger state.

## Regra

Antes de retry:

```text
Confirmar se provider processou a operação.
```

Somente depois executar novo attempt com idempotência.
