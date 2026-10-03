#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

echo "============================================================"
echo " VIA PAY — CORE IMPLEMENTATION + FRONTEND TEST BOOTSTRAP"
echo "============================================================"
echo

if [[ ! -d "$ROOT" ]]; then
    echo "ERRO: projeto não encontrado:"
    echo "$ROOT"
    exit 1
fi

cd "$ROOT"

echo "[1/12] Validando ambiente"
echo "------------------------------------------------------------"

command -v node >/dev/null 2>&1 || {
    echo "ERRO: Node.js não encontrado."
    exit 1
}

command -v pnpm >/dev/null 2>&1 || {
    echo "ERRO: pnpm não encontrado."
    exit 1
}

echo "Node:"
node --version

echo "PNPM:"
pnpm --version

echo

echo "[2/12] Identificando workspace"
echo "------------------------------------------------------------"

if [[ -f package.json ]]; then
    echo "package.json encontrado."
else
    echo "ERRO: package.json não encontrado."
    exit 1
fi

if [[ -d apps/web ]]; then
    WEB="$ROOT/apps/web"
elif [[ -d apps/frontend ]]; then
    WEB="$ROOT/apps/frontend"
elif [[ -d web ]]; then
    WEB="$ROOT/web"
else
    echo "AVISO: frontend padrão não encontrado."
    echo "Será utilizada a estrutura apps/web."
    WEB="$ROOT/apps/web"
    mkdir -p "$WEB"
fi

echo "Frontend:"
echo "$WEB"

echo

echo "[3/12] Criando diretórios funcionais ausentes"
echo "------------------------------------------------------------"

mkdir -p \
    "$ROOT/apps/bank-core" \
    "$ROOT/apps/bank-core/src" \
    "$ROOT/apps/bank-core/src/modules" \
    "$ROOT/apps/bank-core/src/modules/payment" \
    "$ROOT/apps/bank-core/src/modules/ledger" \
    "$ROOT/apps/bank-core/src/modules/router" \
    "$ROOT/apps/bank-core/src/modules/fx" \
    "$ROOT/apps/bank-core/src/modules/settlement" \
    "$ROOT/apps/bank-core/src/modules/reconciliation" \
    "$ROOT/apps/bank-core/src/modules/webhooks" \
    "$ROOT/apps/bank-core/src/modules/compliance" \
    "$ROOT/apps/bank-core/src/modules/auth" \
    "$ROOT/apps/bank-core/src/shared" \
    "$ROOT/apps/bank-core/src/http" \
    "$ROOT/apps/bank-core/src/config" \
    "$ROOT/apps/bank-core/src/infrastructure" \
    "$ROOT/apps/bank-core/tests" \
    "$ROOT/apps/bank-core/tests/integration" \
    "$ROOT/apps/bank-core/tests/e2e" \
    "$ROOT/packages/domain/src/payment" \
    "$ROOT/packages/domain/src/ledger" \
    "$ROOT/packages/domain/src/account" \
    "$ROOT/packages/domain/src/transaction" \
    "$ROOT/packages/domain/src/settlement" \
    "$ROOT/packages/domain/src/fx" \
    "$ROOT/packages/application/src/payment" \
    "$ROOT/packages/application/src/ledger" \
    "$ROOT/packages/application/src/router" \
    "$ROOT/packages/application/src/settlement" \
    "$ROOT/packages/application/src/reconciliation" \
    "$ROOT/packages/infrastructure/src/payment" \
    "$ROOT/packages/infrastructure/src/ledger" \
    "$ROOT/packages/infrastructure/src/fx" \
    "$ROOT/packages/infrastructure/src/settlement" \
    "$ROOT/packages/infrastructure/src/reconciliation" \
    "$ROOT/sandbox/api" \
    "$ROOT/sandbox/fixtures" \
    "$ROOT/sandbox/scenarios" \
    "$ROOT/sandbox/simulator"

echo "Diretórios funcionais preparados."

echo

echo "[4/12] Criando especificação operacional do Core"
echo "------------------------------------------------------------"

mkdir -p "$ROOT/docs/implementation"

cat > "$ROOT/docs/implementation/CORE_EXECUTION_MODEL.md" <<'EOF'
# ViaPay — Core Execution Model

## Objetivo

O ViaPay é uma infraestrutura de pagamentos e financial orchestration
destinada a instituições financeiras, bancos, fintechs e entidades
governamentais.

O produto não depende de um único rail.

O Core deve abstrair:

- PIX
- Bank Transfer
- Card
- Open Banking
- FX Provider
- Liquidity Provider
- Blockchain / DLT
- Stablecoin rails
- Cross-border providers
- Settlement providers

## Fluxo

Client
-> Payment Intent
-> Compliance
-> Authorization
-> Payment Core
-> Payment Router
-> Selected Rail
-> Ledger
-> Settlement
-> Reconciliation
-> Webhook

## Princípios

- Double-entry ledger
- Idempotency
- Immutable financial events
- Audit trail
- RBAC
- ABAC
- MFA
- Approval workflows
- Correlation ID
- Distributed tracing
- Reconciliation
- Provider adapters
- Sandbox first

## Regra

O domínio nunca deve depender diretamente de:

- banco específico
- provider específico
- blockchain específica
- FX provider específico

Esses componentes devem ser adapters.

EOF

cat > "$ROOT/docs/implementation/IMPLEMENTATION_ORDER.md" <<'EOF'
# ViaPay — Implementation Order

1. Workspace
2. Domain
3. Ledger
4. Payment Intent
5. Payment Core
6. Payment Router
7. Sandbox Rail
8. FX Engine
9. Settlement
10. Reconciliation
11. Webhooks
12. Compliance
13. RBAC
14. ABAC
15. MFA
16. Provider adapters
17. Frontend
18. E2E
19. Observability
20. Production hardening

EOF

echo

echo "[5/12] Criando contratos de domínio"
echo "------------------------------------------------------------"

create_if_missing() {
    local file="$1"

    if [[ -e "$file" ]]; then
        echo "[PRESERVADO] $file"
        return
    fi

    mkdir -p "$(dirname "$file")"
    cat > "$file"
    echo "[CRIADO] $file"
}

create_if_missing \
"$ROOT/packages/domain/src/payment/payment.types.ts" <<'EOF'
export type PaymentStatus =
  | "CREATED"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLED"
  | "FAILED"
  | "REVERSED"
  | "CANCELLED";

export type PaymentRail =
  | "SANDBOX"
  | "PIX"
  | "BANK"
  | "CARD"
  | "THUNES"
  | "SOLANA"
  | "BLOCKCHAIN";

export interface Money {
  amount: string;
  currency: string;
}

export interface PaymentIntent {
  id: string;
  idempotencyKey: string;
  status: PaymentStatus;
  rail: PaymentRail;
  source: Money;
  destination: Money;
  merchantId: string;
  customerId: string;
  createdAt: string;
  updatedAt: string;
}
EOF

create_if_missing \
"$ROOT/packages/domain/src/ledger/ledger.types.ts" <<'EOF'
export type LedgerDirection = "DEBIT" | "CREDIT";

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: LedgerDirection;
  amount: string;
  currency: string;
  createdAt: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: string;
}
EOF

create_if_missing \
"$ROOT/packages/domain/src/router/router.types.ts" <<'EOF'
import type { PaymentIntent } from "../payment/payment.types";

export interface PaymentRoute {
  rail: string;
  provider: string;
  priority: number;
  enabled: boolean;
}

export interface PaymentRouter {
  resolve(payment: PaymentIntent): Promise<PaymentRoute>;
}
EOF

create_if_missing \
"$ROOT/packages/domain/src/fx/fx.types.ts" <<'EOF'
export interface FxQuote {
  id: string;
  baseCurrency: string;
  quoteCurrency: string;
  rate: string;
  sourceAmount: string;
  destinationAmount: string;
  provider: string;
  expiresAt: string;
}
EOF

echo

echo "[6/12] Criando Payment Router"
echo "------------------------------------------------------------"

create_if_missing \
"$ROOT/packages/application/src/router/payment-router.ts" <<'EOF'
import type {
  PaymentIntent,
  PaymentRail,
} from "../../../domain/src/payment/payment.types";

import type {
  PaymentRoute,
  PaymentRouter,
} from "../../../domain/src/router/router.types";

const routes: Record<PaymentRail, PaymentRoute> = {
  SANDBOX: {
    rail: "SANDBOX",
    provider: "viapay-sandbox",
    priority: 1,
    enabled: true,
  },

  PIX: {
    rail: "PIX",
    provider: "bank-pix-adapter",
    priority: 10,
    enabled: true,
  },

  BANK: {
    rail: "BANK",
    provider: "bank-transfer-adapter",
    priority: 20,
    enabled: true,
  },

  CARD: {
    rail: "CARD",
    provider: "card-adapter",
    priority: 30,
    enabled: true,
  },

  THUNES: {
    rail: "THUNES",
    provider: "thunes-adapter",
    priority: 40,
    enabled: true,
  },

  SOLANA: {
    rail: "SOLANA",
    provider: "solana-adapter",
    priority: 50,
    enabled: true,
  },

  BLOCKCHAIN: {
    rail: "BLOCKCHAIN",
    provider: "blockchain-adapter",
    priority: 60,
    enabled: true,
  },
};

export class DefaultPaymentRouter implements PaymentRouter {
  async resolve(payment: PaymentIntent): Promise<PaymentRoute> {
    const route = routes[payment.rail];

    if (!route || !route.enabled) {
      throw new Error(`No payment route available for ${payment.rail}`);
    }

    return route;
  }
}
EOF

echo

echo "[7/12] Criando Sandbox operacional"
echo "------------------------------------------------------------"

create_if_missing \
"$ROOT/sandbox/api/payment-simulator.ts" <<'EOF'
export interface SandboxPaymentRequest {
  amount: string;
  currency: string;
  rail: string;
  customerId: string;
  merchantId: string;
  idempotencyKey: string;
}

export interface SandboxPaymentResponse {
  id: string;
  status: "AUTHORIZED" | "PROCESSING" | "SETTLED";
  amount: string;
  currency: string;
  rail: string;
  createdAt: string;
}

export function simulatePayment(
  request: SandboxPaymentRequest,
): SandboxPaymentResponse {
  return {
    id: `pay_sandbox_${Date.now()}`,
    status: "AUTHORIZED",
    amount: request.amount,
    currency: request.currency,
    rail: request.rail,
    createdAt: new Date().toISOString(),
  };
}
EOF

create_if_missing \
"$ROOT/sandbox/api/index.ts" <<'EOF'
export * from "./payment-simulator";
EOF

echo

echo "[8/12] Preparando frontend"
echo "------------------------------------------------------------"

mkdir -p \
    "$WEB/components/viapay" \
    "$WEB/lib/viapay"

create_if_missing \
"$WEB/lib/viapay/demo-data.ts" <<'EOF'
export const dashboardData = {
  balance: "R$ 1.284.530,42",
  available: "R$ 1.104.320,18",
  processing: "R$ 180.210,24",
  todayVolume: "R$ 483.920,10",
  transactions: 1284,
};

export const payments = [
  {
    id: "PAY-000001",
    customer: "Cliente Sandbox",
    merchant: "Merchant Demo",
    amount: "R$ 109,00",
    currency: "BRL",
    rail: "SANDBOX",
    status: "AUTHORIZED",
  },
  {
    id: "PAY-000002",
    customer: "Customer China",
    merchant: "Merchant Brasil",
    amount: "¥ 156,00",
    currency: "CNY",
    rail: "CROSS-BORDER",
    status: "PROCESSING",
  },
  {
    id: "PAY-000003",
    customer: "Customer UK",
    merchant: "Merchant Brasil",
    amount: "£ 20,00",
    currency: "GBP",
    rail: "THUNES",
    status: "SETTLED",
  },
];
EOF

create_if_missing \
"$WEB/components/viapay/status-badge.tsx" <<'EOF'
"use client";

export function StatusBadge({ status }: { status: string }) {
  return (
    <span
      style={{
        display: "inline-flex",
        padding: "5px 10px",
        borderRadius: 999,
        background: "#eff6ff",
        color: "#1d4ed8",
        fontSize: 12,
        fontWeight: 700,
      }}
    >
      {status}
    </span>
  );
}
EOF

create_if_missing \
"$WEB/components/viapay/sidebar.tsx" <<'EOF'
"use client";

const items = [
  "Dashboard",
  "Customers",
  "Accounts",
  "Payments",
  "Transactions",
  "Ledger",
  "Payment Router",
  "FX",
  "Settlement",
  "Reconciliation",
  "Compliance",
  "Risk",
  "Approvals",
  "Users & Roles",
  "Audit",
  "Sandbox",
  "API",
];

export function Sidebar() {
  return (
    <aside
      style={{
        width: 250,
        minHeight: "100vh",
        borderRight: "1px solid #e5e7eb",
        background: "#ffffff",
        padding: 24,
        boxSizing: "border-box",
      }}
    >
      <div style={{ marginBottom: 32 }}>
        <div
          style={{
            fontSize: 24,
            fontWeight: 800,
            color: "#0b5fff",
          }}
        >
          ViaPay
        </div>

        <div
          style={{
            fontSize: 12,
            color: "#64748b",
            marginTop: 4,
          }}
        >
          Banking Infrastructure
        </div>
      </div>

      <nav style={{ display: "grid", gap: 4 }}>
        {items.map((item, index) => (
          <div
            key={item}
            style={{
              padding: "10px 12px",
              borderRadius: 8,
              background: index === 0 ? "#eff6ff" : "transparent",
              color: index === 0 ? "#0b5fff" : "#334155",
              fontWeight: index === 0 ? 700 : 500,
              fontSize: 14,
            }}
          >
            {item}
          </div>
        ))}
      </nav>
    </aside>
  );
}
EOF

create_if_missing \
"$WEB/components/viapay/dashboard.tsx" <<'EOF'
"use client";

import { dashboardData, payments } from "../../lib/viapay/demo-data";
import { StatusBadge } from "./status-badge";

function Card({
  title,
  value,
  description,
}: {
  title: string;
  value: string;
  description: string;
}) {
  return (
    <div
      style={{
        background: "#ffffff",
        border: "1px solid #e5e7eb",
        borderRadius: 14,
        padding: 20,
      }}
    >
      <div
        style={{
          color: "#64748b",
          fontSize: 13,
          fontWeight: 600,
        }}
      >
        {title}
      </div>

      <div
        style={{
          marginTop: 10,
          fontSize: 25,
          fontWeight: 800,
          color: "#0f172a",
        }}
      >
        {value}
      </div>

      <div
        style={{
          marginTop: 8,
          color: "#94a3b8",
          fontSize: 12,
        }}
      >
        {description}
      </div>
    </div>
  );
}

export function Dashboard() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: "#f8fafc",
        padding: 32,
      }}
    >
      <div
        style={{
          maxWidth: 1500,
          margin: "0 auto",
        }}
      >
        <header
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: 28,
          }}
        >
          <div>
            <h1
              style={{
                margin: 0,
                fontSize: 30,
                fontWeight: 800,
                color: "#0f172a",
              }}
            >
              Banking Console
            </h1>

            <p
              style={{
                marginTop: 8,
                color: "#64748b",
              }}
            >
              ViaPay Financial Infrastructure
            </p>
          </div>

          <div
            style={{
              padding: "8px 14px",
              borderRadius: 999,
              background: "#ecfdf5",
              color: "#047857",
              fontSize: 13,
              fontWeight: 700,
            }}
          >
            Sandbox Online
          </div>
        </header>

        <section
          style={{
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit, minmax(220px, 1fr))",
            gap: 16,
          }}
        >
          <Card
            title="Ledger Balance"
            value={dashboardData.balance}
            description="Saldo contabilizado"
          />

          <Card
            title="Available Balance"
            value={dashboardData.available}
            description="Disponível para settlement"
          />

          <Card
            title="Processing"
            value={dashboardData.processing}
            description="Transações em processamento"
          />

          <Card
            title="Today's Volume"
            value={dashboardData.todayVolume}
            description={`${dashboardData.transactions} transações`}
          />
        </section>

        <section
          style={{
            marginTop: 28,
            background: "#ffffff",
            border: "1px solid #e5e7eb",
            borderRadius: 14,
            overflow: "hidden",
          }}
        >
          <div
            style={{
              padding: 20,
              borderBottom: "1px solid #e5e7eb",
              fontWeight: 800,
              color: "#0f172a",
            }}
          >
            Recent Payments
          </div>

          <div style={{ overflowX: "auto" }}>
            <table
              style={{
                width: "100%",
                borderCollapse: "collapse",
              }}
            >
              <thead>
                <tr
                  style={{
                    textAlign: "left",
                    color: "#64748b",
                    fontSize: 12,
                  }}
                >
                  <th style={{ padding: 16 }}>Payment</th>
                  <th style={{ padding: 16 }}>Customer</th>
                  <th style={{ padding: 16 }}>Merchant</th>
                  <th style={{ padding: 16 }}>Amount</th>
                  <th style={{ padding: 16 }}>Rail</th>
                  <th style={{ padding: 16 }}>Status</th>
                </tr>
              </thead>

              <tbody>
                {payments.map((payment) => (
                  <tr
                    key={payment.id}
                    style={{
                      borderTop: "1px solid #f1f5f9",
                      fontSize: 13,
                    }}
                  >
                    <td style={{ padding: 16, fontWeight: 700 }}>
                      {payment.id}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.customer}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.merchant}
                    </td>

                    <td style={{ padding: 16, fontWeight: 700 }}>
                      {payment.amount}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.rail}
                    </td>

                    <td style={{ padding: 16 }}>
                      <StatusBadge status={payment.status} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section
          style={{
            marginTop: 28,
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit, minmax(260px, 1fr))",
            gap: 16,
          }}
        >
          {[
            ["Payment Router", "PIX / Bank / Card / Blockchain"],
            ["FX Engine", "Multi-currency quotation"],
            ["Settlement", "Batch and real-time settlement"],
            ["Reconciliation", "Ledger versus providers"],
          ].map(([title, description]) => (
            <div
              key={title}
              style={{
                background: "#ffffff",
                border: "1px solid #e5e7eb",
                borderRadius: 14,
                padding: 20,
              }}
            >
              <div
                style={{
                  fontWeight: 800,
                  color: "#0f172a",
                }}
              >
                {title}
              </div>

              <div
                style={{
                  marginTop: 8,
                  color: "#64748b",
                  fontSize: 13,
                }}
              >
                {description}
              </div>
            </div>
          ))}
        </section>
      </div>
    </main>
  );
}
EOF

echo

echo "[9/12] Criando rota visual de teste"
echo "------------------------------------------------------------"

if [[ -d "$WEB/app" ]]; then

    mkdir -p "$WEB/app/viapay"

    create_if_missing \
    "$WEB/app/viapay/page.tsx" <<'EOF'
import { Sidebar } from "../../components/viapay/sidebar";
import { Dashboard } from "../../components/viapay/dashboard";

export default function ViaPayPage() {
  return (
    <div
      style={{
        display: "flex",
        minHeight: "100vh",
        background: "#f8fafc",
      }}
    >
      <Sidebar />
      <div style={{ flex: 1 }}>
        <Dashboard />
      </div>
    </div>
  );
}
EOF

elif [[ -d "$WEB/src/app" ]]; then

    mkdir -p "$WEB/src/app/viapay"

    create_if_missing \
    "$WEB/src/app/viapay/page.tsx" <<'EOF'
import { Sidebar } from "../../../components/viapay/sidebar";
import { Dashboard } from "../../../components/viapay/dashboard";

export default function ViaPayPage() {
  return (
    <div
      style={{
        display: "flex",
        minHeight: "100vh",
        background: "#f8fafc",
      }}
    >
      <Sidebar />
      <div style={{ flex: 1 }}>
        <Dashboard />
      </div>
    </div>
  );
}
EOF

else
    echo "AVISO: App Router não identificado."
fi

echo

echo "[10/12] Criando documentação de integração"
echo "------------------------------------------------------------"

create_if_missing \
"$ROOT/docs/implementation/FRONTEND_TEST.md" <<'EOF'
# ViaPay Frontend Test

## URL

Após iniciar o frontend:

http://localhost:3000/viapay

## Console

A página representa a Banking Console inicial.

## Módulos exibidos

- Dashboard
- Customers
- Accounts
- Payments
- Transactions
- Ledger
- Payment Router
- FX
- Settlement
- Reconciliation
- Compliance
- Risk
- Approvals
- Users & Roles
- Audit
- Sandbox
- API

## Observação

Os dados exibidos inicialmente são dados de Sandbox.

Nenhuma movimentação financeira real é realizada.

EOF

echo

echo "[11/12] Instalando dependências"
echo "------------------------------------------------------------"

if [[ -f "$ROOT/pnpm-lock.yaml" ]]; then
    pnpm install --frozen-lockfile || pnpm install
else
    pnpm install
fi

echo

echo "[12/12] Validação"
echo "------------------------------------------------------------"

echo "Executando diagnóstico do workspace..."

if pnpm exec tsc --noEmit >/tmp/viapay-typecheck.log 2>&1; then
    echo "TypeScript: OK"
else
    echo "TypeScript: existem erros."
    echo "Log:"
    tail -n 40 /tmp/viapay-typecheck.log || true
fi

echo
echo "============================================================"
echo " VIA PAY — BOOTSTRAP CONCLUÍDO"
echo "============================================================"
echo
echo "Frontend:"
echo "$WEB"
echo
echo "Rota de teste:"
echo "http://localhost:3000/viapay"
echo
echo "Para iniciar:"
echo
echo "cd $ROOT"
echo "pnpm dev"
echo
echo "Depois abra:"
echo
echo "http://localhost:3000/viapay"
echo
echo "IMPORTANTE:"
echo "Os dados atuais são Sandbox."
echo "Nenhuma transação financeira real será executada."
echo
echo "Próxima implementação:"
echo "Payment Router -> FX -> Settlement -> Reconciliation"
echo
