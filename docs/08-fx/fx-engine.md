
# FX Engine

## Objetivo

Gerenciar cotações e conversões cambiais.

## Quote

Uma cotação deve possuir:

* quote_id;
* base_currency;
* quote_currency;
* rate;
* spread;
* fee;
* timestamp;
* expiration;
* provider;
* source.

## Exemplo

```text
USD → BRL

Market rate:
5.40

Spread:
0.02

Effective rate:
5.42
```

## Regras

Cotações expiram.

Não reutilizar cotação vencida.

## Auditoria

Registrar:

* cotação apresentada;
* cotação aceita;
* taxa aplicada;
* provider;
* horário;
* usuário;
* transaction ID.
  EOF

# ------------------------------------------------------------------------------

# SETTLEMENT

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/09-settlement/settlement.md" <<'EOF'

# Settlement

## Objetivo

Representar a liquidação efetiva de uma obrigação financeira.

## Settlement não é Ledger

Ledger registra obrigação e movimentação contábil.

Settlement confirma movimentação através de uma rede ou instituição externa.

## Fluxo

```text
Payment
  ↓
Ledger Posting
  ↓
Settlement Instruction
  ↓
Provider
  ↓
External Confirmation
  ↓
Settlement Record
  ↓
Reconciliation
```

## Providers

* banco;
* PSP;
* payment network;
* blockchain;
* liquidity provider.

## Idempotência

Settlement submissions devem possuir identificador externo e interno.

## Retry

Retries devem utilizar backoff e nunca criar duplicidade financeira.
