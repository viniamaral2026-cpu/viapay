
# Domain Model

## Bounded Contexts

### Identity

Responsável por:

* usuários;
* autenticação;
* MFA;
* sessões;
* credenciais.

### Customer

Responsável por:

* pessoas;
* empresas;
* KYC;
* dados cadastrais.

### Account

Responsável por:

* contas;
* status;
* moeda;
* titularidade.

### Ledger

Responsável por:

* lançamentos;
* partidas;
* saldos;
* períodos.

### Payments

Responsável por:

* instruções;
* processamento;
* estados;
* idempotência.

### Settlement

Responsável por:

* liquidação;
* batches;
* provedores;
* confirmação.

### Reconciliation

Responsável por:

* matching;
* divergências;
* ajustes;
* fechamento.

## Agregados

Principais aggregates:

* Customer;
* Account;
* Payment;
* LedgerTransaction;
* SettlementBatch;
* ReconciliationCase;
* ApprovalRequest.
  EOF

# ------------------------------------------------------------------------------

# FINANCIAL

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/04-financial/financial-model.md" <<'EOF'

# Financial Model

## Princípio

O sistema financeiro deve separar:

1. intenção de pagamento;
2. autorização;
3. movimentação;
4. contabilização;
5. liquidação;
6. reconciliação.

## Estados

```text
CREATED
   ↓
AUTHORIZED
   ↓
PROCESSING
   ↓
POSTED
   ↓
SETTLED
   ↓
RECONCILED
```

Estados de erro:

```text
FAILED
REVERSED
CANCELLED
EXPIRED
```

## Regra

Uma transação POSTED não deve ser apagada.

Correções devem ocorrer por meio de novas transações compensatórias.
