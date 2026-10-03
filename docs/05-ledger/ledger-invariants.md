
# Ledger Invariants

1. Todo lançamento possui uma moeda.
2. Toda transação possui tenant.
3. Toda transação possui identificador único.
4. Toda transação possui timestamp.
5. Toda transação possui origem.
6. Débitos e créditos devem fechar.
7. Ledger é imutável.
8. Correção ocorre por compensação.
9. Nenhuma API externa pode alterar ledger diretamente.
10. Saldo derivado deve ser verificável contra o ledger.
11. Reprocessamento deve ser idempotente.
12. Eventos financeiros devem possuir correlation ID.
    EOF

# ------------------------------------------------------------------------------

# PAYMENTS

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/06-payments/payment-engine.md" <<'EOF'

# Payment Engine

## Responsabilidade

O Payment Engine orquestra a execução de uma instrução de pagamento.

Ele não deve assumir que o transporte financeiro é:

* banco;
* PIX;
* cartão;
* blockchain;
* transferência internacional.

Esses são mecanismos de settlement.

## Pipeline

```text
Create Payment
      ↓
Validate
      ↓
Risk
      ↓
Authorize
      ↓
Approval
      ↓
Quote FX
      ↓
Reserve
      ↓
Post Ledger
      ↓
Submit Settlement
      ↓
Receive Confirmation
      ↓
Reconcile
```

## Idempotência

Toda operação de criação deve aceitar:

```http
Idempotency-Key
```

A mesma chave não pode gerar duas operações financeiras.

## Payment ID

Exemplo:

```text
pay_01JXXXXXXXXXXXX
```

## Estados

```text
CREATED
AUTHORIZED
PENDING_APPROVAL
PROCESSING
POSTED
SETTLEMENT_PENDING
SETTLED
RECONCILED
FAILED
REVERSED
```

