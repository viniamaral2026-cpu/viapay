# Reconciliation Sandbox

Simular divergências entre:

- Payment;
- Ledger;
- Blockchain;
- FX;
- Settlement.

Cenários:

MATCHED
MISSING_TRANSACTION
AMOUNT_MISMATCH
CURRENCY_MISMATCH
DUPLICATE
SETTLEMENT_MISMATCH

Uma divergência deve gerar:

reconciliation_case

Nunca corrigir alterando registros históricos.

Utilizar lançamento compensatório quando aplicável.
