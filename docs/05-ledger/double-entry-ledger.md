
# Double Entry Ledger

## Objetivo

Garantir consistência contábil transacional.

Toda transação financeira possui pelo menos duas partidas.

Exemplo:

Cliente compra produto por 109 BRL.

```text
Débito
Cliente:       -109 BRL

Crédito
Lojista:       +109 BRL
```

Se existir taxa:

```text
Débito
Cliente:       -109 BRL

Crédito
Lojista:       +106 BRL

Crédito
Conta de fees: +3 BRL
```

## Invariantes

Para cada moeda:

```text
SUM(debits) = SUM(credits)
```

## Imutabilidade

Ledger entries são append-only.

Não devem ser:

* UPDATE;
* DELETE.

Correções são feitas por lançamentos compensatórios.

## Atomicidade

A criação de uma transação e suas partidas deve ocorrer dentro da mesma
transação do banco de dados.

## Precisão

Valores monetários não devem utilizar floating point.

Usar:

* integer em unidade mínima; ou
* DECIMAL com precisão explicitamente definida.

## Exemplo

```text
amount_minor = 10900
currency = BRL
```

representa:

```text
R$ 109,00
```

