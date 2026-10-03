
# Runbook — Payment Failure

## Sintoma

Pagamento permanece FAILED ou PROCESSING acima do SLA.

## Diagnóstico

1. localizar payment_id;
2. consultar correlation_id;
3. verificar payment attempts;
4. verificar provider;
5. verificar ledger;
6. verificar settlement;
7. verificar reconciliation.

## Ações

Não repetir manualmente uma operação financeira sem verificar idempotência.

## Escalonamento

Se existir dúvida sobre duplicidade, bloquear novo processamento e abrir caso
operacional.
