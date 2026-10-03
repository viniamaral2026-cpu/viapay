
# Runbook — Reconciliation Mismatch

## Procedimento

1. identificar external_reference;
2. localizar transação interna;
3. comparar valor;
4. comparar moeda;
5. comparar timestamp;
6. verificar duplicidade;
7. preservar evidências;
8. abrir reconciliation case.

## Regra

Nunca alterar ledger diretamente para "fazer bater".

A divergência deve ser resolvida através de fluxo controlado.
