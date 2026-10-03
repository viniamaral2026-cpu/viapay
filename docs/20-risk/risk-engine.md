
# Risk Engine

## Objetivo

Classificar risco transacional.

## Sinais possíveis

* valor;
* frequência;
* país;
* moeda;
* dispositivo;
* IP;
* histórico;
* beneficiary;
* velocity;
* comportamento;
* blacklist;
* sanctions.

## Resultado

```text
ALLOW
REVIEW
BLOCK
```

## Decisão

Cada decisão deve ser explicável através dos sinais e regras aplicados.

Não registrar somente um score sem contexto.
