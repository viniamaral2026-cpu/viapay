
# Payment State Machine

## CREATED

Pagamento recebido.

## AUTHORIZED

Regras básicas aprovadas.

## PENDING_APPROVAL

Necessita aprovação conforme alçada.

## PROCESSING

Processamento iniciado.

## POSTED

Ledger contabilizado.

## SETTLEMENT_PENDING

Aguardando liquidação externa.

## SETTLED

Provedor confirmou liquidação.

## RECONCILED

Liquidação conciliada com registros externos.

## FAILED

Processamento falhou antes de conclusão.

## REVERSED

Uma transação anteriormente contabilizada foi compensada.

## Regras

Estados não podem ser alterados arbitrariamente.

Cada transição deve possuir:

* actor;
* timestamp;
* motivo;
* correlation ID;
* audit event.
  EOF

# ------------------------------------------------------------------------------

# CROSS BORDER

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/07-cross-border/cross-border-payments.md" <<'EOF'

# Cross-Border Payments

## Objetivo

Permitir que uma instrução originada em uma moeda possa ser liquidada em outra
moeda.

Exemplo conceitual:

```text
Cliente
USD
  │
  ▼
Payment API
  │
  ▼
FX Quote
  │
  ▼
Ledger
  │
  ▼
Settlement Network
  │
  ▼
Beneficiário
BRL
```

## Importante

O blockchain pode ser utilizado como rail de settlement, mas não deve ser
confundido com conversão cambial.

FX e settlement são responsabilidades distintas.

## Componentes

* FX provider;
* liquidity provider;
* payment provider;
* settlement provider;
* compliance;
* ledger;
* reconciliation.

## Resultado

O beneficiário recebe a moeda definida pela instituição e pelo contrato da
operação.
