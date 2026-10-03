
# Reconciliation

## Objetivo

Comparar registros internos contra registros externos.

## Fontes

* ledger;
* settlement provider;
* banco;
* PSP;
* blockchain;
* arquivos de liquidação.

## Matching

Critérios:

* external_reference;
* transaction_id;
* amount;
* currency;
* date;
* account.

## Estados

```text
MATCHED
UNMATCHED_INTERNAL
UNMATCHED_EXTERNAL
AMOUNT_MISMATCH
CURRENCY_MISMATCH
DUPLICATE
MANUAL_REVIEW
RESOLVED
```

## Regra

Diferenças nunca devem ser simplesmente ignoradas.

Toda exceção deve possuir:

* caso;
* responsável;
* motivo;
* evidência;
* resolução;
* auditoria.
  EOF

# ------------------------------------------------------------------------------

# ACCOUNTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/11-accounts/accounts.md" <<'EOF'

# Accounts

## Tipos

* customer account;
* settlement account;
* fee account;
* suspense account;
* treasury account;
* clearing account.

## Estados

```text
PENDING
ACTIVE
BLOCKED
FROZEN
CLOSED
```

## Regras

Conta fechada não pode receber novas operações.

Conta bloqueada não pode iniciar determinadas operações.

Conta congelada deve seguir política de compliance.

## Multi-currency

Uma conta pode:

1. possuir uma moeda;
2. possuir subcontas por moeda.

A decisão deve ser definida pelo modelo regulatório e operacional da
instituição.
