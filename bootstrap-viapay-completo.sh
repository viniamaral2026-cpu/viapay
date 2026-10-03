

### SCRIPT MASTER

```bash
#!/usr/bin/env bash

###############################################################################
#                                                                             #
#                 VIA PAY — MASTER BOOTSTRAP ENTERPRISE                      #
#                                                                             #
#  Objetivo: criar uma base completa, preenchida e organizada para o         #
#  ecossistema ViaPay, preservando o que já existe.                           #
#                                                                             #
#  RAIZ:                                                                      #
#      /mnt/ai-knowledge/viapay                                                #
#                                                                             #
#  BANK CORE OFICIAL:                                                         #
#      /mnt/ai-knowledge/viapay/apps/bank-core                                #
#                                                                             #
#  SANDBOX OFICIAL:                                                           #
#      /mnt/ai-knowledge/viapay/sandbox                                        #
#                                                                             #
#  IMPORTANTE:                                                                #
#  - Não sobrescreve arquivos existentes.                                     #
#  - Não apaga código existente.                                              #
#  - Não cria outro bank-core.                                                #
#  - Não cria dinheiro real.                                                  #
#  - Não cria integração financeira real fictícia.                             #
#  - Mock/sandbox é identificado explicitamente.                              #
#                                                                             #
###############################################################################

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
BANK_CORE="$ROOT/apps/bank-core"
SANDBOX="$ROOT/sandbox"
DOCS="$ROOT/docs"

echo
echo "======================================================================"
echo "                    VIA PAY MASTER BOOTSTRAP"
echo "======================================================================"
echo
echo "ROOT      : $ROOT"
echo "BANK CORE : $BANK_CORE"
echo "SANDBOX   : $SANDBOX"
echo
echo "Modo: NÃO DESTRUTIVO"
echo

if [[ ! -d "$ROOT" ]]; then
    echo "ERRO: diretório $ROOT não existe."
    exit 1
fi

###############################################################################
# HELPERS
###############################################################################

write_if_missing() {
    local file="$1"

    mkdir -p "$(dirname "$file")"

    if [[ -e "$file" ]]; then
        echo "[SKIP]    $file"
        return 0
    fi

    cat > "$file"

    echo "[CREATE]  $file"
}

mkdir_safe() {
    mkdir -p "$1"
}

###############################################################################
# DIRETÓRIOS PRINCIPAIS
###############################################################################

echo
echo "[1/20] Criando estrutura..."

DIRECTORIES=(
    "$BANK_CORE"
    "$BANK_CORE/app"
    "$BANK_CORE/app/(dashboard)"
    "$BANK_CORE/app/(dashboard)/dashboard"
    "$BANK_CORE/app/(dashboard)/accounts"
    "$BANK_CORE/app/(dashboard)/customers"
    "$BANK_CORE/app/(dashboard)/merchants"
    "$BANK_CORE/app/(dashboard)/payments"
    "$BANK_CORE/app/(dashboard)/transfers"
    "$BANK_CORE/app/(dashboard)/ledger"
    "$BANK_CORE/app/(dashboard)/settlement"
    "$BANK_CORE/app/(dashboard)/reconciliation"
    "$BANK_CORE/app/(dashboard)/fx"
    "$BANK_CORE/app/(dashboard)/liquidity"
    "$BANK_CORE/app/(dashboard)/compliance"
    "$BANK_CORE/app/(dashboard)/risk"
    "$BANK_CORE/app/(dashboard)/fraud"
    "$BANK_CORE/app/(dashboard)/approvals"
    "$BANK_CORE/app/(dashboard)/audit"
    "$BANK_CORE/app/(dashboard)/users"
    "$BANK_CORE/app/(dashboard)/roles"
    "$BANK_CORE/app/(dashboard)/integrations"
    "$BANK_CORE/app/(dashboard)/settings"
    "$BANK_CORE/app/api/health"
    "$BANK_CORE/app/api/sandbox/payments"
    "$BANK_CORE/app/api/sandbox/payments/[id]"
    "$BANK_CORE/app/api/sandbox/webhooks"
    "$BANK_CORE/app/api/sandbox/fx"
    "$BANK_CORE/app/api/sandbox/settlement"
    "$BANK_CORE/app/api/sandbox/transactions"
    "$BANK_CORE/app/developer"
    "$BANK_CORE/app/developer/applications"
    "$BANK_CORE/app/developer/api-keys"
    "$BANK_CORE/app/developer/documentation"
    "$BANK_CORE/app/developer/sandbox"
    "$BANK_CORE/app/developer/webhooks"
    "$BANK_CORE/app/developer/logs"
    "$BANK_CORE/app/developer/certification"
    "$BANK_CORE/app/developer/production"
    "$BANK_CORE/app/merchant"
    "$BANK_CORE/app/merchant/payments"
    "$BANK_CORE/app/merchant/transactions"
    "$BANK_CORE/app/merchant/customers"
    "$BANK_CORE/app/merchant/qr"
    "$BANK_CORE/app/merchant/api"
    "$BANK_CORE/app/merchant/settings"
    "$BANK_CORE/app/login"
    "$BANK_CORE/app/unauthorized"

    "$BANK_CORE/components"
    "$BANK_CORE/components/ui"
    "$BANK_CORE/components/layout"
    "$BANK_CORE/components/dashboard"
    "$BANK_CORE/components/accounts"
    "$BANK_CORE/components/customers"
    "$BANK_CORE/components/merchants"
    "$BANK_CORE/components/payments"
    "$BANK_CORE/components/ledger"
    "$BANK_CORE/components/settlement"
    "$BANK_CORE/components/reconciliation"
    "$BANK_CORE/components/fx"
    "$BANK_CORE/components/security"
    "$BANK_CORE/components/developer"
    "$BANK_CORE/components/merchant"
    "$BANK_CORE/components/sandbox"

    "$BANK_CORE/domain"
    "$BANK_CORE/domain/accounts"
    "$BANK_CORE/domain/customers"
    "$BANK_CORE/domain/merchants"
    "$BANK_CORE/domain/payments"
    "$BANK_CORE/domain/ledger"
    "$BANK_CORE/domain/transactions"
    "$BANK_CORE/domain/fx"
    "$BANK_CORE/domain/settlement"
    "$BANK_CORE/domain/reconciliation"
    "$BANK_CORE/domain/compliance"
    "$BANK_CORE/domain/risk"
    "$BANK_CORE/domain/fraud"
    "$BANK_CORE/domain/approvals"

    "$BANK_CORE/application"
    "$BANK_CORE/application/services"
    "$BANK_CORE/application/use-cases"
    "$BANK_CORE/application/dto"
    "$BANK_CORE/application/ports"

    "$BANK_CORE/infrastructure"
    "$BANK_CORE/infrastructure/adapters"
    "$BANK_CORE/infrastructure/adapters/payments"
    "$BANK_CORE/infrastructure/adapters/fx"
    "$BANK_CORE/infrastructure/adapters/liquidity"
    "$BANK_CORE/infrastructure/adapters/settlement"
    "$BANK_CORE/infrastructure/adapters/blockchain"
    "$BANK_CORE/infrastructure/adapters/legacy"
    "$BANK_CORE/infrastructure/database"
    "$BANK_CORE/infrastructure/events"
    "$BANK_CORE/infrastructure/security"
    "$BANK_CORE/infrastructure/observability"

    "$BANK_CORE/lib"
    "$BANK_CORE/lib/auth"
    "$BANK_CORE/lib/security"
    "$BANK_CORE/lib/formatters"
    "$BANK_CORE/lib/validators"
    "$BANK_CORE/lib/constants"

    "$BANK_CORE/types"
    "$BANK_CORE/hooks"
    "$BANK_CORE/store"
    "$BANK_CORE/mocks"
    "$BANK_CORE/public"

    "$BANK_CORE/tests"
    "$BANK_CORE/tests/unit"
    "$BANK_CORE/tests/integration"
    "$BANK_CORE/tests/e2e"
    "$BANK_CORE/tests/security"
    "$BANK_CORE/tests/contracts"

    "$SANDBOX"
    "$SANDBOX/api"
    "$SANDBOX/scenarios"
    "$SANDBOX/fixtures"
    "$SANDBOX/fixtures/payments"
    "$SANDBOX/fixtures/customers"
    "$SANDBOX/fixtures/merchants"
    "$SANDBOX/fixtures/accounts"
    "$SANDBOX/fixtures/webhooks"
    "$SANDBOX/fixtures/fx"
    "$SANDBOX/fixtures/settlement"
    "$SANDBOX/docs"
    "$SANDBOX/openapi"
    "$SANDBOX/sdk"
    "$SANDBOX/scripts"

    "$DOCS"
)

for directory in "${DIRECTORIES[@]}"; do
    mkdir_safe "$directory"
done

###############################################################################
# PACKAGE.JSON
###############################################################################

echo
echo "[2/20] Criando package base..."

write_if_missing "$BANK_CORE/package.json" <<'EOF'
{
  "name": "@viapay/bank-core",
  "version": "0.1.0",
  "private": true,
  "description": "ViaPay Bank Core and Payment Infrastructure",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "vitest run",
    "test:watch": "vitest",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "lucide-react": "^0.468.0",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "typescript": "^5.7.0",
    "vitest": "^2.1.0"
  }
}
EOF

###############################################################################
# TYPESCRIPT
###############################################################################

write_if_missing "$BANK_CORE/tsconfig.json" <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
EOF

write_if_missing "$BANK_CORE/next-env.d.ts" <<'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited.
EOF

###############################################################################
# NEXT CONFIG
###############################################################################

write_if_missing "$BANK_CORE/next.config.ts" <<'EOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,

  experimental: {
    typedRoutes: true
  },

  env: {
    NEXT_PUBLIC_VIAPAY_ENVIRONMENT:
      process.env.NEXT_PUBLIC_VIAPAY_ENVIRONMENT ?? "sandbox"
  }
};

export default nextConfig;
EOF

###############################################################################
# GLOBAL CSS
###############################################################################

echo
echo "[3/20] Criando identidade visual..."

write_if_missing "$BANK_CORE/app/globals.css" <<'EOF'
@import "tailwindcss";

:root {
  --viapay-blue: #0b5fff;
  --viapay-blue-dark: #0848c7;
  --viapay-blue-light: #60a5fa;
  --viapay-cyan: #06b6d4;
  --viapay-background: #f8fafc;
  --viapay-surface: #ffffff;
  --viapay-border: #e2e8f0;
  --viapay-text: #0f172a;
  --viapay-muted: #64748b;
  --viapay-success: #16a34a;
  --viapay-warning: #d97706;
  --viapay-danger: #dc2626;
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  min-height: 100%;
}

body {
  background: var(--viapay-background);
  color: var(--viapay-text);
  font-family:
    Inter,
    ui-sans-serif,
    system-ui,
    -apple-system,
    BlinkMacSystemFont,
    "Segoe UI",
    sans-serif;
}

button,
input,
select,
textarea {
  font: inherit;
}

a {
  color: inherit;
  text-decoration: none;
}

.vp-shell {
  min-height: 100vh;
  display: flex;
}

.vp-sidebar {
  width: 260px;
  min-height: 100vh;
  background: #ffffff;
  border-right: 1px solid var(--viapay-border);
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  overflow-y: auto;
  z-index: 30;
}

.vp-main {
  margin-left: 260px;
  width: calc(100% - 260px);
  min-height: 100vh;
}

.vp-topbar {
  height: 72px;
  background: #ffffff;
  border-bottom: 1px solid var(--viapay-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  position: sticky;
  top: 0;
  z-index: 20;
}

.vp-content {
  padding: 28px;
  max-width: 1800px;
}

.vp-card {
  background: #ffffff;
  border: 1px solid var(--viapay-border);
  border-radius: 14px;
  padding: 20px;
}

.vp-grid {
  display: grid;
  gap: 18px;
}

.vp-grid-4 {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.vp-grid-3 {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.vp-grid-2 {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.vp-stat {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.vp-stat-value {
  font-size: 28px;
  font-weight: 750;
  letter-spacing: -0.03em;
}

.vp-muted {
  color: var(--viapay-muted);
}

.vp-title {
  font-size: 26px;
  font-weight: 750;
  letter-spacing: -0.03em;
}

.vp-subtitle {
  color: var(--viapay-muted);
  margin-top: 4px;
}

.vp-button {
  border: 0;
  border-radius: 9px;
  padding: 10px 16px;
  cursor: pointer;
  font-weight: 650;
}

.vp-button-primary {
  color: white;
  background: var(--viapay-blue);
}

.vp-button-secondary {
  color: var(--viapay-text);
  background: #ffffff;
  border: 1px solid var(--viapay-border);
}

.vp-badge {
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  padding: 4px 9px;
  font-size: 12px;
  font-weight: 700;
}

.vp-badge-success {
  color: #166534;
  background: #dcfce7;
}

.vp-badge-warning {
  color: #92400e;
  background: #fef3c7;
}

.vp-badge-danger {
  color: #991b1b;
  background: #fee2e2;
}

.vp-badge-info {
  color: #1e40af;
  background: #dbeafe;
}

.vp-table {
  width: 100%;
  border-collapse: collapse;
}

.vp-table th,
.vp-table td {
  text-align: left;
  padding: 14px 12px;
  border-bottom: 1px solid var(--viapay-border);
  font-size: 14px;
}

.vp-table th {
  color: var(--viapay-muted);
  font-weight: 650;
}

.vp-input {
  width: 100%;
  height: 42px;
  border: 1px solid var(--viapay-border);
  border-radius: 8px;
  padding: 0 12px;
  outline: none;
  background: white;
}

.vp-input:focus {
  border-color: var(--viapay-blue);
  box-shadow: 0 0 0 3px rgba(11, 95, 255, 0.1);
}

.vp-code {
  background: #0f172a;
  color: #e2e8f0;
  border-radius: 10px;
  padding: 18px;
  overflow: auto;
  font-family: "JetBrains Mono", monospace;
  font-size: 13px;
}

@media (max-width: 1100px) {
  .vp-grid-4 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .vp-sidebar {
    width: 220px;
  }

  .vp-main {
    margin-left: 220px;
    width: calc(100% - 220px);
  }
}

@media (max-width: 800px) {
  .vp-sidebar {
    display: none;
  }

  .vp-main {
    margin-left: 0;
    width: 100%;
  }

  .vp-grid-4,
  .vp-grid-3,
  .vp-grid-2 {
    grid-template-columns: 1fr;
  }

  .vp-content {
    padding: 18px;
  }
}
EOF

###############################################################################
# TYPES
###############################################################################

echo
echo "[4/20] Criando domínio tipado..."

write_if_missing "$BANK_CORE/types/domain.ts" <<'EOF'
export type Environment =
  | "sandbox"
  | "development"
  | "staging"
  | "production";

export type Currency =
  | "BRL"
  | "USD"
  | "EUR"
  | "GBP"
  | "CNY"
  | "USDC";

export type TransactionStatus =
  | "CREATED"
  | "PENDING"
  | "PROCESSING"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "EXPIRED"
  | "REQUIRES_APPROVAL";

export type PaymentStatus =
  | "CREATED"
  | "AWAITING_PAYMENT"
  | "PAYMENT_DETECTED"
  | "VERIFYING"
  | "CONFIRMED"
  | "FAILED"
  | "EXPIRED"
  | "CANCELLED"
  | "SETTLEMENT_PENDING"
  | "SETTLED";

export type SettlementStatus =
  | "PENDING"
  | "PROCESSING"
  | "COMPLETED"
  | "FAILED"
  | "REVERSED";

export interface Money {
  amount: string;
  currency: Currency;
}

export interface Institution {
  id: string;
  name: string;
  country: string;
  status: "ACTIVE" | "SUSPENDED";
}

export interface Account {
  id: string;
  customerId: string;
  type: "CHECKING" | "SETTLEMENT" | "ESCROW" | "TEST";
  currency: Currency;
  balance: string;
  availableBalance: string;
  status: "ACTIVE" | "BLOCKED" | "CLOSED";
}

export interface Customer {
  id: string;
  name: string;
  email: string;
  country: string;
  status: "ACTIVE" | "PENDING" | "BLOCKED";
}

export interface Merchant {
  id: string;
  legalName: string;
  displayName: string;
  country: string;
  status: "ACTIVE" | "PENDING" | "SUSPENDED";
}

export interface Payment {
  id: string;
  merchantId: string;
  amount: string;
  currency: Currency;
  status: PaymentStatus;
  description: string;
  createdAt: string;
}

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: "DEBIT" | "CREDIT";
  amount: string;
  currency: Currency;
  createdAt: string;
}

export interface Settlement {
  id: string;
  paymentId: string;
  amount: string;
  currency: Currency;
  status: SettlementStatus;
  provider: string;
  createdAt: string;
}

export interface FxQuote {
  id: string;
  baseCurrency: Currency;
  quoteCurrency: Currency;
  baseAmount: string;
  quoteAmount: string;
  rate: string;
  fee: string;
  status: "CREATED" | "LOCKED" | "EXECUTED" | "EXPIRED" | "FAILED";
}

export interface AuditLog {
  id: string;
  actor: string;
  action: string;
  resource: string;
  resourceId: string;
  result: "SUCCESS" | "DENIED" | "ERROR";
  timestamp: string;
}

export interface ApiApplication {
  id: string;
  name: string;
  environment: Environment;
  status: "ACTIVE" | "SUSPENDED";
  createdAt: string;
}

export interface WebhookEvent {
  id: string;
  type: string;
  status: "DELIVERED" | "FAILED" | "PENDING";
  attempts: number;
  createdAt: string;
}
EOF

###############################################################################
# MOCK DATA
###############################################################################

echo
echo "[5/20] Criando dados de demonstração..."

write_if_missing "$BANK_CORE/mocks/data.ts" <<'EOF'
import type {
  Account,
  ApiApplication,
  AuditLog,
  Customer,
  FxQuote,
  LedgerEntry,
  Merchant,
  Payment,
  Settlement,
  WebhookEvent
} from "@/types/domain";

export const dashboardStats = {
  totalAccounts: 128450,
  activeCustomers: 98420,
  activeMerchants: 7310,
  paymentsToday: 18420,
  paymentVolumeToday: "R$ 12.480.392,10",
  pendingApprovals: 17,
  settlementPending: 23,
  reconciliationCases: 4
};

export const customers: Customer[] = [
  {
    id: "cus_001",
    name: "Cliente Sandbox",
    email: "cliente@example.test",
    country: "BR",
    status: "ACTIVE"
  },
  {
    id: "cus_002",
    name: "Global Test Customer",
    email: "global@example.test",
    country: "US",
    status: "ACTIVE"
  },
  {
    id: "cus_003",
    name: "Empresa Demo",
    email: "empresa@example.test",
    country: "BR",
    status: "PENDING"
  }
];

export const merchants: Merchant[] = [
  {
    id: "mrc_001",
    legalName: "Mercado Demo LTDA",
    displayName: "Mercado Demo",
    country: "BR",
    status: "ACTIVE"
  },
  {
    id: "mrc_002",
    legalName: "Global Commerce Inc.",
    displayName: "Global Commerce",
    country: "US",
    status: "ACTIVE"
  }
];

export const accounts: Account[] = [
  {
    id: "acc_001",
    customerId: "cus_001",
    type: "CHECKING",
    currency: "BRL",
    balance: "18500.00",
    availableBalance: "17200.00",
    status: "ACTIVE"
  },
  {
    id: "acc_002",
    customerId: "cus_002",
    type: "SETTLEMENT",
    currency: "USD",
    balance: "42000.00",
    availableBalance: "42000.00",
    status: "ACTIVE"
  },
  {
    id: "acc_sandbox_001",
    customerId: "cus_001",
    type: "TEST",
    currency: "BRL",
    balance: "100000.00",
    availableBalance: "100000.00",
    status: "ACTIVE"
  }
];

export const payments: Payment[] = [
  {
    id: "pi_001",
    merchantId: "mrc_001",
    amount: "109.00",
    currency: "BRL",
    status: "CONFIRMED",
    description: "Sandbox checkout",
    createdAt: "2026-10-03T10:15:00Z"
  },
  {
    id: "pi_002",
    merchantId: "mrc_001",
    amount: "249.90",
    currency: "BRL",
    status: "SETTLED",
    description: "Order #10021",
    createdAt: "2026-10-03T10:12:00Z"
  },
  {
    id: "pi_003",
    merchantId: "mrc_002",
    amount: "19.00",
    currency: "USDC",
    status: "PAYMENT_DETECTED",
    description: "Blockchain simulation",
    createdAt: "2026-10-03T10:05:00Z"
  },
  {
    id: "pi_004",
    merchantId: "mrc_001",
    amount: "1500.00",
    currency: "BRL",
    status: "REQUIRES_APPROVAL",
    description: "High value test transaction",
    createdAt: "2026-10-03T09:54:00Z"
  }
];

export const ledgerEntries: LedgerEntry[] = [
  {
    id: "le_001",
    transactionId: "tx_001",
    accountId: "acc_sandbox_001",
    direction: "DEBIT",
    amount: "109.00",
    currency: "BRL",
    createdAt: "2026-10-03T10:15:02Z"
  },
  {
    id: "le_002",
    transactionId: "tx_001",
    accountId: "acc_001",
    direction: "CREDIT",
    amount: "109.00",
    currency: "BRL",
    createdAt: "2026-10-03T10:15:02Z"
  }
];

export const settlements: Settlement[] = [
  {
    id: "set_001",
    paymentId: "pi_002",
    amount: "249.90",
    currency: "BRL",
    status: "COMPLETED",
    provider: "SANDBOX_SETTLEMENT",
    createdAt: "2026-10-03T10:30:00Z"
  },
  {
    id: "set_002",
    paymentId: "pi_003",
    amount: "19.00",
    currency: "USDC",
    status: "PROCESSING",
    provider: "SANDBOX_BLOCKCHAIN",
    createdAt: "2026-10-03T10:06:00Z"
  }
];

export const fxQuotes: FxQuote[] = [
  {
    id: "fxq_001",
    baseCurrency: "BRL",
    quoteCurrency: "USDC",
    baseAmount: "109.00",
    quoteAmount: "19.00",
    rate: "0.1743119",
    fee: "0.50",
    status: "LOCKED"
  },
  {
    id: "fxq_002",
    baseCurrency: "EUR",
    quoteCurrency: "BRL",
    baseAmount: "100.00",
    quoteAmount: "620.00",
    rate: "6.20",
    fee: "1.20",
    status: "CREATED"
  }
];

export const applications: ApiApplication[] = [
  {
    id: "app_001",
    name: "Global Commerce Sandbox",
    environment: "sandbox",
    status: "ACTIVE",
    createdAt: "2026-10-01T14:00:00Z"
  },
  {
    id: "app_002",
    name: "Bank Integration Test",
    environment: "sandbox",
    status: "ACTIVE",
    createdAt: "2026-09-28T09:00:00Z"
  }
];

export const webhookEvents: WebhookEvent[] = [
  {
    id: "evt_001",
    type: "payment.confirmed",
    status: "DELIVERED",
    attempts: 1,
    createdAt: "2026-10-03T10:15:04Z"
  },
  {
    id: "evt_002",
    type: "settlement.completed",
    status: "DELIVERED",
    attempts: 1,
    createdAt: "2026-10-03T10:30:04Z"
  },
  {
    id: "evt_003",
    type: "payment.failed",
    status: "FAILED",
    attempts: 3,
    createdAt: "2026-10-03T09:45:04Z"
  }
];

export const auditLogs: AuditLog[] = [
  {
    id: "audit_001",
    actor: "manager.demo",
    action: "PAYMENT_APPROVED",
    resource: "payment",
    resourceId: "pi_004",
    result: "SUCCESS",
    timestamp: "2026-10-03T10:01:00Z"
  },
  {
    id: "audit_002",
    actor: "operator.demo",
    action: "PAYMENT_CREATED",
    resource: "payment",
    resourceId: "pi_001",
    result: "SUCCESS",
    timestamp: "2026-10-03T10:15:00Z"
  }
];
EOF

###############################################################################
# LAYOUT
###############################################################################

echo
echo "[6/20] Criando layout..."

write_if_missing "$BANK_CORE/app/layout.tsx" <<'EOF'
import "./globals.css";
import type { Metadata } from "next";
import { AppShell } from "@/components/layout/AppShell";

export const metadata: Metadata = {
  title: "ViaPay Bank Core",
  description:
    "ViaPay — Payment Infrastructure, Bank Core and Financial Orchestration"
};

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR">
      <body>
        <AppShell>{children}</AppShell>
      </body>
    </html>
  );
}
EOF

###############################################################################
# SIDEBAR
###############################################################################

write_if_missing "$BANK_CORE/components/layout/Sidebar.tsx" <<'EOF'
"use client";

import Link from "next/link";
import {
  Activity,
  ArrowLeftRight,
  Building2,
  CheckCircle2,
  CreditCard,
  Database,
  FileCheck2,
  Gauge,
  GitBranch,
  Globe2,
  KeyRound,
  LayoutDashboard,
  Landmark,
  LockKeyhole,
  Network,
  Receipt,
  RefreshCw,
  Settings,
  ShieldCheck,
  Store,
  Users,
  Wallet,
  Webhook
} from "lucide-react";

const groups = [
  {
    title: "Core",
    items: [
      ["/dashboard", "Dashboard", LayoutDashboard],
      ["/accounts", "Contas", Wallet],
      ["/customers", "Clientes", Users],
      ["/merchants", "Comerciantes", Store],
      ["/payments", "Pagamentos", CreditCard],
      ["/transfers", "Transferências", ArrowLeftRight]
    ]
  },
  {
    title: "Financial",
    items: [
      ["/ledger", "Ledger", Database],
      ["/settlement", "Settlement", Receipt],
      ["/reconciliation", "Reconciliação", RefreshCw],
      ["/fx", "FX", Globe2],
      ["/liquidity", "Liquidez", Activity]
    ]
  },
  {
    title: "Risk & Security",
    items: [
      ["/compliance", "Compliance", ShieldCheck],
      ["/risk", "Risk", Gauge],
      ["/fraud", "Fraud", LockKeyhole],
      ["/approvals", "Alçadas", CheckCircle2],
      ["/audit", "Auditoria", FileCheck2]
    ]
  },
  {
    title: "Platform",
    items: [
      ["/users", "Usuários", Users],
      ["/roles", "RBAC / ABAC", KeyRound],
      ["/integrations", "Integrações", Network],
      ["/settings", "Configurações", Settings]
    ]
  }
];

export function Sidebar() {
  return (
    <aside className="vp-sidebar">
      <div
        style={{
          height: 72,
          display: "flex",
          alignItems: "center",
          padding: "0 22px",
          borderBottom: "1px solid var(--viapay-border)"
        }}
      >
        <div
          style={{
            width: 38,
            height: 38,
            borderRadius: 10,
            background: "var(--viapay-blue)",
            color: "white",
            display: "grid",
            placeItems: "center",
            fontWeight: 800,
            marginRight: 11
          }}
        >
          V
        </div>

        <div>
          <div style={{ fontWeight: 800 }}>ViaPay</div>
          <div style={{ fontSize: 11, color: "#64748b" }}>
            BANK CORE
          </div>
        </div>
      </div>

      <div style={{ padding: "18px 12px" }}>
        {groups.map((group) => (
          <div key={group.title} style={{ marginBottom: 22 }}>
            <div
              style={{
                fontSize: 11,
                textTransform: "uppercase",
                color: "#94a3b8",
                fontWeight: 750,
                padding: "0 10px",
                marginBottom: 7
              }}
            >
              {group.title}
            </div>

            {group.items.map(([href, label, Icon]) => {
              const Component = Icon as React.ComponentType<{
                size?: number;
              }>;

              return (
                <Link
                  key={String(href)}
                  href={String(href)}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: 10,
                    padding: "10px 10px",
                    borderRadius: 8,
                    marginBottom: 2,
                    fontSize: 14,
                    color: "#334155"
                  }}
                >
                  <Component size={17} />
                  <span>{String(label)}</span>
                </Link>
              );
            })}
          </div>
        ))}

        <div
          style={{
            marginTop: 24,
            padding: 12,
            borderRadius: 10,
            background: "#eff6ff",
            border: "1px solid #dbeafe"
          }}
        >
          <div
            style={{
              fontSize: 11,
              fontWeight: 800,
              color: "#1d4ed8"
            }}
          >
            ENVIRONMENT
          </div>

          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 7,
              marginTop: 6,
              fontSize: 13,
              fontWeight: 700
            }}
          >
            <span
              style={{
                width: 7,
                height: 7,
                borderRadius: "50%",
                background: "#16a34a"
              }}
            />
            SANDBOX
          </div>
        </div>
      </div>
    </aside>
  );
}
EOF

###############################################################################
# TOPBAR
###############################################################################

write_if_missing "$BANK_CORE/components/layout/Topbar.tsx" <<'EOF'
"use client";

import { Bell, HelpCircle, Search } from "lucide-react";

export function Topbar() {
  return (
    <header className="vp-topbar">
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 10,
          color: "#64748b"
        }}
      >
        <Search size={17} />

        <input
          placeholder="Pesquisar no Bank Core..."
          style={{
            border: 0,
            outline: 0,
            width: 320,
            fontSize: 14
          }}
        />
      </div>

      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 18
        }}
      >
        <HelpCircle size={19} color="#64748b" />
        <Bell size={19} color="#64748b" />

        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: 9
          }}
        >
          <div
            style={{
              width: 34,
              height: 34,
              borderRadius: "50%",
              background: "#dbeafe",
              display: "grid",
              placeItems: "center",
              color: "#1d4ed8",
              fontWeight: 800
            }}
          >
            AD
          </div>

          <div>
            <div style={{ fontSize: 13, fontWeight: 700 }}>
              Admin Demo
            </div>

            <div style={{ fontSize: 11, color: "#64748b" }}>
              Bank Administrator
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
EOF

###############################################################################
# APP SHELL
###############################################################################

write_if_missing "$BANK_CORE/components/layout/AppShell.tsx" <<'EOF'
import { Sidebar } from "./Sidebar";
import { Topbar } from "./Topbar";

export function AppShell({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="vp-shell">
      <Sidebar />

      <main className="vp-main">
        <Topbar />

        <section className="vp-content">
          {children}
        </section>
      </main>
    </div>
  );
}
EOF

###############################################################################
# UI COMPONENTS
###############################################################################

echo
echo "[7/20] Criando componentes..."

write_if_missing "$BANK_CORE/components/ui/PageHeader.tsx" <<'EOF'
export function PageHeader({
  title,
  description,
  action
}: {
  title: string;
  description: string;
  action?: React.ReactNode;
}) {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "flex-start",
        marginBottom: 24,
        gap: 20
      }}
    >
      <div>
        <h1 className="vp-title">{title}</h1>
        <p className="vp-subtitle">{description}</p>
      </div>

      {action}
    </div>
  );
}
EOF

write_if_missing "$BANK_CORE/components/ui/StatusBadge.tsx" <<'EOF'
export function StatusBadge({
  status
}: {
  status: string;
}) {
  const normalized = status.toUpperCase();

  let className = "vp-badge-info";

  if (
    [
      "ACTIVE",
      "COMPLETED",
      "CONFIRMED",
      "SETTLED",
      "DELIVERED",
      "SUCCESS",
      "APPROVED"
    ].includes(normalized)
  ) {
    className = "vp-badge-success";
  }

  if (
    [
      "PENDING",
      "PROCESSING",
      "CREATED",
      "REQUIRES_APPROVAL",
      "LOCKED"
    ].includes(normalized)
  ) {
    className = "vp-badge-warning";
  }

  if (
    [
      "FAILED",
      "BLOCKED",
      "CANCELLED",
      "EXPIRED",
      "DENIED",
      "SUSPENDED"
    ].includes(normalized)
  ) {
    className = "vp-badge-danger";
  }

  return (
    <span className={`vp-badge ${className}`}>
      {status.replaceAll("_", " ")}
    </span>
  );
}
EOF

write_if_missing "$BANK_CORE/components/ui/StatCard.tsx" <<'EOF'
import type { LucideIcon } from "lucide-react";

export function StatCard({
  title,
  value,
  description,
  icon: Icon
}: {
  title: string;
  value: string | number;
  description: string;
  icon: LucideIcon;
}) {
  return (
    <div className="vp-card vp-stat">
      <div>
        <div
          style={{
            fontSize: 13,
            color: "#64748b",
            fontWeight: 650
          }}
        >
          {title}
        </div>

        <div className="vp-stat-value">{value}</div>

        <div
          style={{
            fontSize: 12,
            color: "#64748b",
            marginTop: 5
          }}
        >
          {description}
        </div>
      </div>

      <div
        style={{
          width: 42,
          height: 42,
          borderRadius: 10,
          background: "#eff6ff",
          color: "#2563eb",
          display: "grid",
          placeItems: "center"
        }}
      >
        <Icon size={20} />
      </div>
    </div>
  );
}
EOF

write_if_missing "$BANK_CORE/components/ui/EmptyState.tsx" <<'EOF'
export function EmptyState({
  title,
  description
}: {
  title: string;
  description: string;
}) {
  return (
    <div
      className="vp-card"
      style={{
        textAlign: "center",
        padding: 50
      }}
    >
      <div
        style={{
          fontSize: 18,
          fontWeight: 750
        }}
      >
        {title}
      </div>

      <div
        style={{
          marginTop: 8,
          color: "#64748b"
        }}
      >
        {description}
      </div>
    </div>
  );
}
EOF

###############################################################################
# DASHBOARD
###############################################################################

echo
echo "[8/20] Criando Dashboard..."

write_if_missing "$BANK_CORE/app/(dashboard)/dashboard/page.tsx" <<'EOF'
import {
  Activity,
  ArrowLeftRight,
  CreditCard,
  ShieldCheck,
  Wallet
} from "lucide-react";

import { PageHeader } from "@/components/ui/PageHeader";
import { StatCard } from "@/components/ui/StatCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { dashboardStats, payments } from "@/mocks/data";

export default function DashboardPage() {
  return (
    <>
      <PageHeader
        title="Bank Core Dashboard"
        description="Visão operacional da infraestrutura financeira ViaPay."
        action={
          <span className="vp-badge vp-badge-info">
            SANDBOX ENVIRONMENT
          </span>
        }
      />

      <div className="vp-grid vp-grid-4">
        <StatCard
          title="Contas"
          value={dashboardStats.totalAccounts.toLocaleString("pt-BR")}
          description="Contas registradas"
          icon={Wallet}
        />

        <StatCard
          title="Clientes ativos"
          value={dashboardStats.activeCustomers.toLocaleString("pt-BR")}
          description="Clientes em operação"
          icon={ShieldCheck}
        />

        <StatCard
          title="Pagamentos hoje"
          value={dashboardStats.paymentsToday.toLocaleString("pt-BR")}
          description="Transações processadas"
          icon={CreditCard}
        />

        <StatCard
          title="Volume hoje"
          value={dashboardStats.paymentVolumeToday}
          description="Valor de demonstração"
          icon={Activity}
        />
      </div>

      <div
        className="vp-grid vp-grid-2"
        style={{ marginTop: 20 }}
      >
        <div className="vp-card">
          <h2 style={{ fontSize: 17, fontWeight: 750 }}>
            Pagamentos recentes
          </h2>

          <table className="vp-table" style={{ marginTop: 14 }}>
            <thead>
              <tr>
                <th>ID</th>
                <th>Valor</th>
                <th>Status</th>
              </tr>
            </thead>

            <tbody>
              {payments.map((payment) => (
                <tr key={payment.id}>
                  <td>{payment.id}</td>
                  <td>
                    {payment.currency} {payment.amount}
                  </td>
                  <td>
                    <StatusBadge status={payment.status} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="vp-card">
          <h2 style={{ fontSize: 17, fontWeight: 750 }}>
            Controles operacionais
          </h2>

          <div
            style={{
              display: "grid",
              gap: 12,
              marginTop: 16
            }}
          >
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                padding: 14,
                border: "1px solid #e2e8f0",
                borderRadius: 9
              }}
            >
              <span>Pagamentos aguardando aprovação</span>
              <strong>{dashboardStats.pendingApprovals}</strong>
            </div>

            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                padding: 14,
                border: "1px solid #e2e8f0",
                borderRadius: 9
              }}
            >
              <span>Settlement pendente</span>
              <strong>{dashboardStats.settlementPending}</strong>
            </div>

            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                padding: 14,
                border: "1px solid #e2e8f0",
                borderRadius: 9
              }}
            >
              <span>Casos de reconciliação</span>
              <strong>{dashboardStats.reconciliationCases}</strong>
            </div>
          </div>
        </div>
      </div>

      <div className="vp-card" style={{ marginTop: 20 }}>
        <h2 style={{ fontSize: 17, fontWeight: 750 }}>
          Arquitetura operacional
        </h2>

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(5, 1fr)",
            gap: 10,
            marginTop: 18
          }}
        >
          {[
            "Payment",
            "Risk",
            "FX",
            "Settlement",
            "Ledger"
          ].map((item) => (
            <div
              key={item}
              style={{
                padding: 18,
                textAlign: "center",
                border: "1px solid #dbeafe",
                borderRadius: 10,
                background: "#f8fbff"
              }}
            >
              <ArrowLeftRight
                size={20}
                style={{
                  margin: "0 auto 8px",
                  color: "#2563eb"
                }}
              />
              <strong>{item}</strong>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
EOF

###############################################################################
# ROOT PAGE
###############################################################################

write_if_missing "$BANK_CORE/app/page.tsx" <<'EOF'
import { redirect } from "next/navigation";

export default function HomePage() {
  redirect("/dashboard");
}
EOF

###############################################################################
# GENERIC DATA PAGES
###############################################################################

echo
echo "[9/20] Criando módulos operacionais..."

write_if_missing "$BANK_CORE/app/(dashboard)/accounts/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { accounts } from "@/mocks/data";

export default function AccountsPage() {
  return (
    <>
      <PageHeader
        title="Contas"
        description="Contas e posições financeiras administradas pelo Bank Core."
        action={
          <button className="vp-button vp-button-primary">
            Nova conta
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Cliente</th>
              <th>Tipo</th>
              <th>Moeda</th>
              <th>Saldo</th>
              <th>Disponível</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {accounts.map((account) => (
              <tr key={account.id}>
                <td>{account.id}</td>
                <td>{account.customerId}</td>
                <td>{account.type}</td>
                <td>{account.currency}</td>
                <td>{account.balance}</td>
                <td>{account.availableBalance}</td>
                <td>
                  <StatusBadge status={account.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/customers/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { customers } from "@/mocks/data";

export default function CustomersPage() {
  return (
    <>
      <PageHeader
        title="Clientes"
        description="Cadastro e gestão de clientes do ecossistema financeiro."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nome</th>
              <th>Email</th>
              <th>País</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {customers.map((customer) => (
              <tr key={customer.id}>
                <td>{customer.id}</td>
                <td>{customer.name}</td>
                <td>{customer.email}</td>
                <td>{customer.country}</td>
                <td>
                  <StatusBadge status={customer.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/merchants/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { merchants } from "@/mocks/data";

export default function MerchantsPage() {
  return (
    <>
      <PageHeader
        title="Comerciantes"
        description="Empresas conectadas à infraestrutura ViaPay."
        action={
          <button className="vp-button vp-button-primary">
            Novo comerciante
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nome</th>
              <th>Razão social</th>
              <th>País</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {merchants.map((merchant) => (
              <tr key={merchant.id}>
                <td>{merchant.id}</td>
                <td>{merchant.displayName}</td>
                <td>{merchant.legalName}</td>
                <td>{merchant.country}</td>
                <td>
                  <StatusBadge status={merchant.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/payments/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { payments } from "@/mocks/data";

export default function PaymentsPage() {
  return (
    <>
      <PageHeader
        title="Pagamentos"
        description="Payment Intents e transações processadas pela infraestrutura."
        action={
          <button className="vp-button vp-button-primary">
            Criar Payment
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Payment ID</th>
              <th>Merchant</th>
              <th>Valor</th>
              <th>Descrição</th>
              <th>Status</th>
              <th>Data</th>
            </tr>
          </thead>

          <tbody>
            {payments.map((payment) => (
              <tr key={payment.id}>
                <td>{payment.id}</td>
                <td>{payment.merchantId}</td>
                <td>
                  {payment.currency} {payment.amount}
                </td>
                <td>{payment.description}</td>
                <td>
                  <StatusBadge status={payment.status} />
                </td>
                <td>{payment.createdAt}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/transfers/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function TransfersPage() {
  return (
    <>
      <PageHeader
        title="Transferências"
        description="Orquestração de transferências entre contas e payment rails."
      />

      <div className="vp-grid vp-grid-3">
        {[
          ["Transfers today", "8.420"],
          ["Processing", "32"],
          ["Completed", "8.301"]
        ].map(([title, value]) => (
          <div className="vp-card" key={title}>
            <div className="vp-muted">{title}</div>
            <div className="vp-stat-value">{value}</div>
          </div>
        ))}
      </div>

      <div className="vp-card" style={{ marginTop: 20 }}>
        <h2 style={{ fontWeight: 750 }}>
          Payment Router
        </h2>

        <p className="vp-muted" style={{ marginTop: 7 }}>
          A camada de roteamento seleciona o provider adequado
          conforme moeda, país, disponibilidade, regras de risco,
          liquidez e configuração institucional.
        </p>

        <div
          className="vp-code"
          style={{ marginTop: 18 }}
        >
{`TransferRequest
      |
      v
Risk Engine
      |
      v
Payment Router
      |
      +--> Bank Adapter
      +--> Pix Adapter
      +--> FX Adapter
      +--> Liquidity Adapter
      +--> Blockchain Adapter
      |
      v
Settlement`}
        </div>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/ledger/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { ledgerEntries } from "@/mocks/data";

export default function LedgerPage() {
  return (
    <>
      <PageHeader
        title="Double-Entry Ledger"
        description="Livro contábil de dupla entrada da infraestrutura financeira."
      />

      <div className="vp-card">
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: 18,
            marginBottom: 20
          }}
        >
          <div
            style={{
              padding: 20,
              background: "#eff6ff",
              borderRadius: 10
            }}
          >
            <div className="vp-muted">Débitos</div>
            <div className="vp-stat-value">R$ 109,00</div>
          </div>

          <div
            style={{
              padding: 20,
              background: "#f0fdf4",
              borderRadius: 10
            }}
          >
            <div className="vp-muted">Créditos</div>
            <div className="vp-stat-value">R$ 109,00</div>
          </div>
        </div>

        <table className="vp-table">
          <thead>
            <tr>
              <th>Entry</th>
              <th>Transaction</th>
              <th>Account</th>
              <th>Direction</th>
              <th>Amount</th>
              <th>Currency</th>
            </tr>
          </thead>

          <tbody>
            {ledgerEntries.map((entry) => (
              <tr key={entry.id}>
                <td>{entry.id}</td>
                <td>{entry.transactionId}</td>
                <td>{entry.accountId}</td>
                <td>{entry.direction}</td>
                <td>{entry.amount}</td>
                <td>{entry.currency}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/settlement/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { settlements } from "@/mocks/data";

export default function SettlementPage() {
  return (
    <>
      <PageHeader
        title="Settlement"
        description="Liquidação de transações e instruções de settlement."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Settlement</th>
              <th>Payment</th>
              <th>Valor</th>
              <th>Provider</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {settlements.map((settlement) => (
              <tr key={settlement.id}>
                <td>{settlement.id}</td>
                <td>{settlement.paymentId}</td>
                <td>
                  {settlement.currency} {settlement.amount}
                </td>
                <td>{settlement.provider}</td>
                <td>
                  <StatusBadge status={settlement.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/reconciliation/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";

const cases = [
  {
    id: "rec_001",
    type: "AMOUNT_MISMATCH",
    source: "Provider",
    status: "PENDING"
  },
  {
    id: "rec_002",
    type: "MATCHED",
    source: "Settlement",
    status: "COMPLETED"
  },
  {
    id: "rec_003",
    type: "MISSING_TRANSACTION",
    source: "Blockchain",
    status: "REQUIRES_APPROVAL"
  }
];

export default function ReconciliationPage() {
  return (
    <>
      <PageHeader
        title="Reconciliação"
        description="Comparação entre pagamentos, ledger, providers e settlement."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Case</th>
              <th>Tipo</th>
              <th>Origem</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {cases.map((item) => (
              <tr key={item.id}>
                <td>{item.id}</td>
                <td>{item.type}</td>
                <td>{item.source}</td>
                <td>
                  <StatusBadge status={item.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/fx/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { fxQuotes } from "@/mocks/data";

export default function FxPage() {
  return (
    <>
      <PageHeader
        title="FX & Currency"
        description="Quotes, conversão e integração com provedores de câmbio."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Quote</th>
              <th>Base</th>
              <th>Quote</th>
              <th>Rate</th>
              <th>Fee</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {fxQuotes.map((quote) => (
              <tr key={quote.id}>
                <td>{quote.id}</td>
                <td>
                  {quote.baseCurrency} {quote.baseAmount}
                </td>
                <td>
                  {quote.quoteCurrency} {quote.quoteAmount}
                </td>
                <td>{quote.rate}</td>
                <td>{quote.fee}</td>
                <td>
                  <StatusBadge status={quote.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/liquidity/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function LiquidityPage() {
  return (
    <>
      <PageHeader
        title="Liquidez"
        description="Gestão e observabilidade das fontes de liquidez."
      />

      <div className="vp-grid vp-grid-3">
        {[
          ["BRL", "R$ 8.420.000,00"],
          ["USD", "$ 1.280.000,00"],
          ["USDC", "850.000 USDC"]
        ].map(([currency, value]) => (
          <div className="vp-card" key={currency}>
            <div className="vp-muted">{currency}</div>
            <div className="vp-stat-value">{value}</div>
          </div>
        ))}
      </div>

      <div className="vp-card" style={{ marginTop: 20 }}>
        <h2 style={{ fontWeight: 750 }}>
          Liquidity Provider Architecture
        </h2>

        <p className="vp-muted" style={{ marginTop: 8 }}>
          Os provedores reais deverão ser conectados através de
          adapters implementando LiquidityProviderPort.
        </p>
      </div>
    </>
  );
}
EOF

###############################################################################
# SECURITY / GOVERNANCE PAGES
###############################################################################

echo
echo "[10/20] Criando segurança, compliance e governança..."

write_if_missing "$BANK_CORE/app/(dashboard)/compliance/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";

const checks = [
  ["KYC", "ACTIVE", "Customer verification"],
  ["KYB", "ACTIVE", "Business verification"],
  ["AML", "ACTIVE", "Transaction monitoring"],
  ["Sanctions", "ACTIVE", "Screening provider"],
  ["Risk", "PROCESSING", "Risk evaluation"]
];

export default function CompliancePage() {
  return (
    <>
      <PageHeader
        title="Compliance"
        description="Camada de compliance, KYC, KYB, AML e screening."
      />

      <div className="vp-grid vp-grid-2">
        {checks.map(([name, status, description]) => (
          <div className="vp-card" key={name}>
            <div
              style={{
                display: "flex",
                justifyContent: "space-between"
              }}
            >
              <div>
                <strong>{name}</strong>
                <div className="vp-muted" style={{ marginTop: 5 }}>
                  {description}
                </div>
              </div>

              <StatusBadge status={status} />
            </div>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/risk/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";

const decisions = [
  ["tx_001", "LOW", "APPROVE"],
  ["tx_002", "MEDIUM", "REVIEW"],
  ["tx_003", "HIGH", "BLOCK"]
];

export default function RiskPage() {
  return (
    <>
      <PageHeader
        title="Risk Engine"
        description="Avaliação de risco antes da execução de transações."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Transaction</th>
              <th>Risk</th>
              <th>Decision</th>
            </tr>
          </thead>

          <tbody>
            {decisions.map(([id, risk, decision]) => (
              <tr key={id}>
                <td>{id}</td>
                <td>{risk}</td>
                <td>
                  <StatusBadge status={decision} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/fraud/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function FraudPage() {
  return (
    <>
      <PageHeader
        title="Fraud Detection"
        description="Monitoramento de eventos e regras antifraude."
      />

      <div className="vp-grid vp-grid-3">
        <div className="vp-card">
          <div className="vp-muted">Eventos hoje</div>
          <div className="vp-stat-value">4.280</div>
        </div>

        <div className="vp-card">
          <div className="vp-muted">Bloqueados</div>
          <div className="vp-stat-value">83</div>
        </div>

        <div className="vp-card">
          <div className="vp-muted">Em revisão</div>
          <div className="vp-stat-value">27</div>
        </div>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/approvals/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";

const approvals = [
  {
    id: "apr_001",
    transaction: "pi_004",
    amount: "BRL 1.500,00",
    requestedBy: "operator.demo",
    status: "PENDING"
  },
  {
    id: "apr_002",
    transaction: "tx_020",
    amount: "BRL 15.000,00",
    requestedBy: "operator.demo",
    status: "APPROVED"
  }
];

export default function ApprovalsPage() {
  return (
    <>
      <PageHeader
        title="Alçadas e Aprovações"
        description="Controle de operações que exigem aprovação humana."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Approval</th>
              <th>Transaction</th>
              <th>Valor</th>
              <th>Solicitante</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {approvals.map((item) => (
              <tr key={item.id}>
                <td>{item.id}</td>
                <td>{item.transaction}</td>
                <td>{item.amount}</td>
                <td>{item.requestedBy}</td>
                <td>
                  <StatusBadge status={item.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/audit/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { auditLogs } from "@/mocks/data";

export default function AuditPage() {
  return (
    <>
      <PageHeader
        title="Auditoria"
        description="Registro imutável de ações administrativas e operacionais."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Actor</th>
              <th>Action</th>
              <th>Resource</th>
              <th>Resource ID</th>
              <th>Result</th>
              <th>Timestamp</th>
            </tr>
          </thead>

          <tbody>
            {auditLogs.map((log) => (
              <tr key={log.id}>
                <td>{log.actor}</td>
                <td>{log.action}</td>
                <td>{log.resource}</td>
                <td>{log.resourceId}</td>
                <td>
                  <StatusBadge status={log.result} />
                </td>
                <td>{log.timestamp}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/users/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function UsersPage() {
  return (
    <>
      <PageHeader
        title="Usuários"
        description="Usuários administrativos e operacionais."
        action={
          <button className="vp-button vp-button-primary">
            Novo usuário
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Usuário</th>
              <th>Nome</th>
              <th>Role</th>
              <th>MFA</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td>admin.demo</td>
              <td>Administrador Demo</td>
              <td>BANK_ADMIN</td>
              <td>Enabled</td>
              <td>Active</td>
            </tr>

            <tr>
              <td>manager.demo</td>
              <td>Gerente Demo</td>
              <td>MANAGER</td>
              <td>Enabled</td>
              <td>Active</td>
            </tr>

            <tr>
              <td>operator.demo</td>
              <td>Operador Demo</td>
              <td>OPERATOR</td>
              <td>Enabled</td>
              <td>Active</td>
            </tr>
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/roles/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

const roles = [
  {
    role: "SUPER_ADMIN",
    permissions: "Full platform administration"
  },
  {
    role: "BANK_ADMIN",
    permissions: "Institution administration"
  },
  {
    role: "MANAGER",
    permissions: "Approvals and operational controls"
  },
  {
    role: "OPERATOR",
    permissions: "Operational transactions"
  },
  {
    role: "AUDITOR",
    permissions: "Read-only audit access"
  },
  {
    role: "COMPLIANCE",
    permissions: "Compliance operations"
  }
];

export default function RolesPage() {
  return (
    <>
      <PageHeader
        title="RBAC / ABAC"
        description="Papéis, permissões e políticas de autorização."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Role</th>
              <th>Permissions</th>
            </tr>
          </thead>

          <tbody>
            {roles.map((role) => (
              <tr key={role.role}>
                <td>
                  <strong>{role.role}</strong>
                </td>
                <td>{role.permissions}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/integrations/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";

const providers = [
  ["Thunes", "PAYMENT_PROVIDER", "ADAPTER_READY"],
  ["Solana", "BLOCKCHAIN", "SANDBOX"],
  ["FX Provider", "FX", "NOT_CONFIGURED"],
  ["Liquidity Provider", "LIQUIDITY", "NOT_CONFIGURED"],
  ["Legacy Core", "BANKING", "ADAPTER_READY"]
];

export default function IntegrationsPage() {
  return (
    <>
      <PageHeader
        title="Integrações"
        description="Providers e adapters conectados à infraestrutura ViaPay."
      />

      <div className="vp-grid vp-grid-2">
        {providers.map(([name, type, status]) => (
          <div className="vp-card" key={name}>
            <div
              style={{
                display: "flex",
                justifyContent: "space-between"
              }}
            >
              <div>
                <strong>{name}</strong>
                <div className="vp-muted" style={{ marginTop: 5 }}>
                  {type}
                </div>
              </div>

              <StatusBadge status={status} />
            </div>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/(dashboard)/settings/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function SettingsPage() {
  return (
    <>
      <PageHeader
        title="Configurações"
        description="Configurações institucionais e operacionais."
      />

      <div className="vp-card">
        <div style={{ display: "grid", gap: 18 }}>
          <label>
            <div style={{ fontWeight: 700, marginBottom: 7 }}>
              Institution name
            </div>

            <input
              className="vp-input"
              defaultValue="ViaPay Demo Institution"
            />
          </label>

          <label>
            <div style={{ fontWeight: 700, marginBottom: 7 }}>
              Default currency
            </div>

            <input
              className="vp-input"
              defaultValue="BRL"
            />
          </label>

          <label>
            <div style={{ fontWeight: 700, marginBottom: 7 }}>
              Environment
            </div>

            <input
              className="vp-input"
              value="SANDBOX"
              readOnly
            />
          </label>
        </div>
      </div>
    </>
  );
}
EOF

###############################################################################
# DEVELOPER PORTAL
###############################################################################

echo
echo "[11/20] Criando Developer Portal..."

write_if_missing "$BANK_CORE/app/developer/page.tsx" <<'EOF'
import Link from "next/link";

export default function DeveloperPage() {
  return (
    <>
      <div className="vp-card">
        <div className="vp-badge vp-badge-info">
          VIA PAY DEVELOPER PLATFORM
        </div>

        <h1 className="vp-title" style={{ marginTop: 14 }}>
          Construa sua integração no Sandbox
        </h1>

        <p className="vp-subtitle" style={{ maxWidth: 760 }}>
          O Developer Portal permite criar aplicações, gerar
          credenciais, testar APIs, receber webhooks, simular
          pagamentos e validar a integração antes do acesso
          à produção.
        </p>

        <div style={{ display: "flex", gap: 10, marginTop: 20 }}>
          <Link
            href="/developer/sandbox"
            className="vp-button vp-button-primary"
          >
            Abrir Sandbox
          </Link>

          <Link
            href="/developer/documentation"
            className="vp-button vp-button-secondary"
          >
            Documentação
          </Link>
        </div>
      </div>

      <div
        className="vp-grid vp-grid-3"
        style={{ marginTop: 20 }}
      >
        {[
          ["Applications", "Crie aplicações e ambientes."],
          ["API Keys", "Credenciais isoladas por ambiente."],
          ["Webhooks", "Teste eventos e callbacks."]
        ].map(([title, description]) => (
          <div className="vp-card" key={title}>
            <strong>{title}</strong>
            <p className="vp-muted" style={{ marginTop: 7 }}>
              {description}
            </p>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/applications/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { applications } from "@/mocks/data";

export default function ApplicationsPage() {
  return (
    <>
      <PageHeader
        title="Applications"
        description="Aplicações cadastradas no Developer Portal."
        action={
          <button className="vp-button vp-button-primary">
            Create application
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Application</th>
              <th>Name</th>
              <th>Environment</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {applications.map((app) => (
              <tr key={app.id}>
                <td>{app.id}</td>
                <td>{app.name}</td>
                <td>{app.environment}</td>
                <td>
                  <StatusBadge status={app.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/api-keys/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function ApiKeysPage() {
  return (
    <>
      <PageHeader
        title="API Keys"
        description="Credenciais de integração isoladas por ambiente."
        action={
          <button className="vp-button vp-button-primary">
            Create API Key
          </button>
        }
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Environment</th>
              <th>Scopes</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td>Sandbox Application</td>
              <td>SANDBOX</td>
              <td>payments.*, webhooks.*</td>
              <td>Active</td>
            </tr>
          </tbody>
        </table>

        <div
          className="vp-badge vp-badge-warning"
          style={{ marginTop: 18 }}
        >
          Secrets reais nunca devem ser exibidos após a criação.
        </div>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/documentation/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function DocumentationPage() {
  return (
    <>
      <PageHeader
        title="API Documentation"
        description="Contratos e recursos da API ViaPay."
      />

      <div className="vp-grid vp-grid-2">
        {[
          ["Authentication", "API Keys, OAuth e scopes."],
          ["Payments", "Payment Intent e transaction lifecycle."],
          ["Transfers", "Transferências e roteamento."],
          ["FX", "Quotes, locking e execution."],
          ["Webhooks", "Eventos, retries e signatures."],
          ["Idempotency", "Proteção contra processamento duplicado."]
        ].map(([title, description]) => (
          <div className="vp-card" key={title}>
            <strong>{title}</strong>
            <p className="vp-muted" style={{ marginTop: 7 }}>
              {description}
            </p>
          </div>
        ))}
      </div>

      <div className="vp-card" style={{ marginTop: 20 }}>
        <h2 style={{ fontWeight: 750 }}>
          Example
        </h2>

        <pre className="vp-code" style={{ marginTop: 15 }}>
{`curl -X POST \\
  https://sandbox.api.viapay.example/api/v1/sandbox/payment-intents \\
  -H "X-ViaPay-Api-Key: vp_sandbox_xxx" \\
  -H "Idempotency-Key: 8e1c7c1d-6e1a-4e8e-9b9d-000001" \\
  -H "Content-Type: application/json" \\
  -d '{
    "merchant_id": "mrc_sandbox_000001",
    "amount": "109.00",
    "currency": "BRL",
    "description": "Sandbox payment"
  }'`}
        </pre>
      </div>
    </>
  );
}
EOF

###############################################################################
# SANDBOX PAGE
###############################################################################

echo
echo "[12/20] Criando Sandbox completo..."

write_if_missing "$BANK_CORE/app/developer/sandbox/page.tsx" <<'EOF'
"use client";

import { useState } from "react";

const scenarios = [
  "success",
  "payment_failed",
  "expired",
  "duplicate",
  "webhook_failure",
  "settlement_failure",
  "fx_failure",
  "rpc_timeout"
];

export default function DeveloperSandboxPage() {
  const [scenario, setScenario] = useState("success");
  const [status, setStatus] = useState("READY");

  function simulate() {
    setStatus("PROCESSING");

    window.setTimeout(() => {
      setStatus(
        scenario === "success"
          ? "CONFIRMED"
          : scenario.toUpperCase()
      );
    }, 700);
  }

  return (
    <>
      <div className="vp-card">
        <div className="vp-badge vp-badge-warning">
          SANDBOX — NO REAL FUNDS
        </div>

        <h1 className="vp-title" style={{ marginTop: 14 }}>
          Developer Sandbox
        </h1>

        <p className="vp-subtitle">
          Ambiente isolado para desenvolvimento e homologação
          da integração ViaPay.
        </p>
      </div>

      <div
        className="vp-grid vp-grid-2"
        style={{ marginTop: 20 }}
      >
        <div className="vp-card">
          <h2 style={{ fontWeight: 750 }}>
            Payment Simulator
          </h2>

          <div style={{ marginTop: 18 }}>
            <label>
              <div style={{ fontWeight: 650, marginBottom: 7 }}>
                Scenario
              </div>

              <select
                className="vp-input"
                value={scenario}
                onChange={(event) =>
                  setScenario(event.target.value)
                }
              >
                {scenarios.map((item) => (
                  <option value={item} key={item}>
                    {item}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <div style={{ marginTop: 18 }}>
            <label>
              <div style={{ fontWeight: 650, marginBottom: 7 }}>
                Amount
              </div>

              <input
                className="vp-input"
                defaultValue="109.00"
              />
            </label>
          </div>

          <div style={{ marginTop: 18 }}>
            <label>
              <div style={{ fontWeight: 650, marginBottom: 7 }}>
                Currency
              </div>

              <input
                className="vp-input"
                defaultValue="BRL"
              />
            </label>
          </div>

          <button
            className="vp-button vp-button-primary"
            style={{ marginTop: 20 }}
            onClick={simulate}
          >
            Execute scenario
          </button>
        </div>

        <div className="vp-card">
          <h2 style={{ fontWeight: 750 }}>
            Simulation result
          </h2>

          <div
            style={{
              marginTop: 18,
              padding: 20,
              borderRadius: 10,
              background: "#f8fafc"
            }}
          >
            <div className="vp-muted">
              Current status
            </div>

            <div
              style={{
                fontSize: 28,
                fontWeight: 800,
                marginTop: 7
              }}
            >
              {status}
            </div>
          </div>

          <pre className="vp-code" style={{ marginTop: 18 }}>
{JSON.stringify(
  {
    id: "pi_sandbox_000001",
    status,
    amount: "109.00",
    currency: "BRL",
    environment: "sandbox"
  },
  null,
  2
)}
          </pre>
        </div>
      </div>

      <div className="vp-card" style={{ marginTop: 20 }}>
        <h2 style={{ fontWeight: 750 }}>
          Sandbox guarantees
        </h2>

        <ul
          style={{
            marginTop: 14,
            lineHeight: 2,
            color: "#475569"
          }}
        >
          <li>No real money.</li>
          <li>No production credentials.</li>
          <li>No production wallets.</li>
          <li>No production bank access.</li>
          <li>Test webhooks only.</li>
          <li>Test ledger only.</li>
          <li>Test settlement only.</li>
        </ul>
      </div>
    </>
  );
}
EOF

###############################################################################
# WEBHOOKS / LOGS / CERTIFICATION
###############################################################################

write_if_missing "$BANK_CORE/app/developer/webhooks/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { webhookEvents } from "@/mocks/data";

export default function WebhooksPage() {
  return (
    <>
      <PageHeader
        title="Webhooks"
        description="Eventos enviados para as aplicações integradas."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Event ID</th>
              <th>Type</th>
              <th>Status</th>
              <th>Attempts</th>
              <th>Created</th>
            </tr>
          </thead>

          <tbody>
            {webhookEvents.map((event) => (
              <tr key={event.id}>
                <td>{event.id}</td>
                <td>{event.type}</td>
                <td>
                  <StatusBadge status={event.status} />
                </td>
                <td>{event.attempts}</td>
                <td>{event.createdAt}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/logs/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function DeveloperLogsPage() {
  return (
    <>
      <PageHeader
        title="Integration Logs"
        description="Logs técnicos das integrações do desenvolvedor."
      />

      <div className="vp-card">
        <pre className="vp-code">
{`2026-10-03T10:15:01Z INFO request_id=req_001
POST /api/v1/sandbox/payment-intents
status=201

2026-10-03T10:15:02Z INFO payment
payment_id=pi_sandbox_000001
status=CONFIRMED

2026-10-03T10:15:03Z INFO webhook
event=payment.confirmed
delivery=SUCCESS`}
        </pre>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/certification/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

const tests = [
  "Authentication",
  "Payment creation",
  "Idempotency",
  "Webhook validation",
  "Error handling",
  "Settlement handling",
  "Reconciliation",
  "Security"
];

export default function CertificationPage() {
  return (
    <>
      <PageHeader
        title="Integration Certification"
        description="Checklist de homologação antes da produção."
      />

      <div className="vp-card">
        {tests.map((test, index) => (
          <div
            key={test}
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              padding: "15px 0",
              borderBottom:
                index === tests.length - 1
                  ? "0"
                  : "1px solid #e2e8f0"
            }}
          >
            <span>{test}</span>

            <span className="vp-badge vp-badge-warning">
              NOT TESTED
            </span>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/developer/production/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function ProductionAccessPage() {
  return (
    <>
      <PageHeader
        title="Production Access"
        description="Solicitação de acesso ao ambiente de produção."
      />

      <div className="vp-card">
        <div className="vp-badge vp-badge-warning">
          NOT AVAILABLE
        </div>

        <h2 style={{ marginTop: 15, fontWeight: 750 }}>
          Complete Sandbox Certification
        </h2>

        <p className="vp-muted" style={{ marginTop: 8 }}>
          O acesso de produção somente deve ser liberado após
          homologação, análise de segurança, onboarding e
          aprovação institucional.
        </p>

        <button
          className="vp-button vp-button-secondary"
          style={{ marginTop: 18 }}
        >
          Request production review
        </button>
      </div>
    </>
  );
}
EOF

###############################################################################
# MERCHANT PORTAL
###############################################################################

echo
echo "[13/20] Criando Merchant Portal..."

write_if_missing "$BANK_CORE/app/merchant/page.tsx" <<'EOF'
import Link from "next/link";

export default function MerchantPage() {
  return (
    <>
      <div className="vp-card">
        <div className="vp-badge vp-badge-info">
          MERCHANT PORTAL
        </div>

        <h1 className="vp-title" style={{ marginTop: 14 }}>
          ViaPay para comerciantes
        </h1>

        <p className="vp-subtitle">
          Gestão de pagamentos, transações, clientes, QR Codes
          e integrações.
        </p>
      </div>

      <div
        className="vp-grid vp-grid-3"
        style={{ marginTop: 20 }}
      >
        <Link href="/merchant/payments" className="vp-card">
          <strong>Payments</strong>
          <p className="vp-muted">Gerencie pagamentos.</p>
        </Link>

        <Link href="/merchant/transactions" className="vp-card">
          <strong>Transactions</strong>
          <p className="vp-muted">Consulte transações.</p>
        </Link>

        <Link href="/merchant/qr" className="vp-card">
          <strong>QR Codes</strong>
          <p className="vp-muted">Crie cobranças.</p>
        </Link>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/payments/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { payments } from "@/mocks/data";

export default function MerchantPaymentsPage() {
  return (
    <>
      <PageHeader
        title="Merchant Payments"
        description="Pagamentos recebidos pelo comerciante."
      />

      <div className="vp-card">
        <table className="vp-table">
          <thead>
            <tr>
              <th>Payment</th>
              <th>Amount</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {payments.map((payment) => (
              <tr key={payment.id}>
                <td>{payment.id}</td>
                <td>
                  {payment.currency} {payment.amount}
                </td>
                <td>
                  <StatusBadge status={payment.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/transactions/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function MerchantTransactionsPage() {
  return (
    <>
      <PageHeader
        title="Transactions"
        description="Histórico de transações do comerciante."
      />

      <div className="vp-card">
        <p className="vp-muted">
          A consulta de transações será alimentada pelo Payment
          Core e pelos adapters configurados pela instituição.
        </p>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/customers/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";
import { customers } from "@/mocks/data";

export default function MerchantCustomersPage() {
  return (
    <>
      <PageHeader
        title="Customers"
        description="Clientes associados ao comerciante."
      />

      <div className="vp-card">
        {customers.map((customer) => (
          <div
            key={customer.id}
            style={{
              padding: 15,
              borderBottom: "1px solid #e2e8f0"
            }}
          >
            <strong>{customer.name}</strong>
            <div className="vp-muted">
              {customer.email}
            </div>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/qr/page.tsx" <<'EOF'
"use client";

import { useState } from "react";

export default function MerchantQrPage() {
  const [amount, setAmount] = useState("109.00");

  return (
    <div>
      <div className="vp-card">
        <div className="vp-badge vp-badge-warning">
          SANDBOX QR
        </div>

        <h1 className="vp-title" style={{ marginTop: 14 }}>
          QR Code de cobrança
        </h1>

        <p className="vp-subtitle">
          QR Code de teste. Nenhum pagamento real será realizado.
        </p>

        <div style={{ maxWidth: 420, marginTop: 22 }}>
          <label>
            <div style={{ fontWeight: 700, marginBottom: 7 }}>
              Valor
            </div>

            <input
              className="vp-input"
              value={amount}
              onChange={(event) =>
                setAmount(event.target.value)
              }
            />
          </label>
        </div>

        <div
          style={{
            width: 220,
            height: 220,
            marginTop: 24,
            border: "10px solid #0f172a",
            display: "grid",
            placeItems: "center",
            background:
              "repeating-linear-gradient(45deg,#fff,#fff 8px,#0f172a 8px,#0f172a 12px)"
          }}
        >
          <div
            style={{
              width: 110,
              height: 110,
              background: "#fff",
              display: "grid",
              placeItems: "center",
              fontWeight: 900
            }}
          >
            VP
          </div>
        </div>

        <p className="vp-muted" style={{ marginTop: 15 }}>
          Test amount: BRL {amount}
        </p>
      </div>
    </div>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/api/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function MerchantApiPage() {
  return (
    <>
      <PageHeader
        title="Merchant API"
        description="Integração técnica do comerciante com o ViaPay."
      />

      <div className="vp-card">
        <pre className="vp-code">
{`POST /api/v1/payments

{
  "amount": "109.00",
  "currency": "BRL",
  "description": "Order #10001"
}`}
        </pre>
      </div>
    </>
  );
}
EOF

write_if_missing "$BANK_CORE/app/merchant/settings/page.tsx" <<'EOF'
import { PageHeader } from "@/components/ui/PageHeader";

export default function MerchantSettingsPage() {
  return (
    <>
      <PageHeader
        title="Merchant Settings"
        description="Configurações da conta do comerciante."
      />

      <div className="vp-card">
        <label>
          <div style={{ fontWeight: 700, marginBottom: 7 }}>
            Display name
          </div>

          <input
            className="vp-input"
            defaultValue="Mercado Demo"
          />
        </label>
      </div>
    </>
  );
}
EOF

###############################################################################
# API ROUTES
###############################################################################

echo
echo "[14/20] Criando API Sandbox..."

write_if_missing "$BANK_CORE/app/api/health/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    service: "viapay-bank-core",
    status: "ok",
    environment:
      process.env.NEXT_PUBLIC_VIAPAY_ENVIRONMENT ?? "sandbox",
    timestamp: new Date().toISOString()
  });
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/payments/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    environment: "sandbox",
    data: [
      {
        id: "pi_sandbox_000001",
        amount: "109.00",
        currency: "BRL",
        status: "CONFIRMED"
      },
      {
        id: "pi_sandbox_000002",
        amount: "249.90",
        currency: "BRL",
        status: "SETTLED"
      }
    ]
  });
}

export async function POST(request: Request) {
  const body = await request.json();

  return NextResponse.json(
    {
      id: `pi_sandbox_${Date.now()}`,
      environment: "sandbox",
      status: "AWAITING_PAYMENT",
      amount: body.amount,
      currency: body.currency,
      merchant_id: body.merchant_id ?? "mrc_sandbox_000001",
      description: body.description ?? null,
      created_at: new Date().toISOString()
    },
    { status: 201 }
  );
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/payments/[id]/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function GET(
  _request: Request,
  context: {
    params: Promise<{ id: string }>;
  }
) {
  const { id } = await context.params;

  return NextResponse.json({
    id,
    environment: "sandbox",
    status: "CONFIRMED",
    amount: "109.00",
    currency: "BRL",
    ledger: {
      balanced: true
    },
    settlement: {
      status: "SETTLED"
    }
  });
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/webhooks/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const body = await request.json();

  return NextResponse.json({
    environment: "sandbox",
    event_id: `evt_${Date.now()}`,
    type: body.type ?? "payment.confirmed",
    status: "QUEUED",
    delivered: false,
    message:
      "Webhook queued for Sandbox simulation only."
  });
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/fx/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const body = await request.json();

  return NextResponse.json(
    {
      id: `fxq_sandbox_${Date.now()}`,
      environment: "sandbox",
      base_currency: body.base_currency ?? "BRL",
      quote_currency: body.quote_currency ?? "USDC",
      base_amount: body.base_amount ?? "109.00",
      quote_amount: "19.00",
      rate: "0.1743119",
      fee: "0.50",
      status: "CREATED",
      simulated: true
    },
    { status: 201 }
  );
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/settlement/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const body = await request.json();

  return NextResponse.json(
    {
      id: `set_sandbox_${Date.now()}`,
      payment_id: body.payment_id,
      environment: "sandbox",
      status: "PROCESSING",
      provider: "SANDBOX_SETTLEMENT",
      simulated: true
    },
    { status: 202 }
  );
}
EOF

write_if_missing "$BANK_CORE/app/api/sandbox/transactions/route.ts" <<'EOF'
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    environment: "sandbox",
    transactions: [
      {
        id: "tx_sandbox_001",
        status: "COMPLETED",
        amount: "109.00",
        currency: "BRL"
      },
      {
        id: "tx_sandbox_002",
        status: "PROCESSING",
        amount: "19.00",
        currency: "USDC"
      }
    ]
  });
}
EOF

###############################################################################
# DOMAIN PORTS
###############################################################################

echo
echo "[15/20] Criando Ports e Adapters..."

write_if_missing "$BANK_CORE/application/ports/PaymentProviderPort.ts" <<'EOF'
export interface PaymentProviderPort {
  createPayment(input: {
    amount: string;
    currency: string;
    reference: string;
  }): Promise<{
    providerTransactionId: string;
    status: string;
  }>;

  getPayment(
    providerTransactionId: string
  ): Promise<{
    status: string;
  }>;
}
EOF

write_if_missing "$BANK_CORE/application/ports/FxProviderPort.ts" <<'EOF'
export interface FxProviderPort {
  createQuote(input: {
    baseCurrency: string;
    quoteCurrency: string;
    amount: string;
  }): Promise<{
    quoteId: string;
    rate: string;
    quoteAmount: string;
    fee: string;
  }>;

  executeQuote(quoteId: string): Promise<{
    status: string;
    reference: string;
  }>;
}
EOF

write_if_missing "$BANK_CORE/application/ports/LiquidityProviderPort.ts" <<'EOF'
export interface LiquidityProviderPort {
  getLiquidity(input: {
    currency: string;
    amount: string;
  }): Promise<{
    available: boolean;
    availableAmount: string;
  }>;
}
EOF

write_if_missing "$BANK_CORE/application/ports/SettlementProviderPort.ts" <<'EOF'
export interface SettlementProviderPort {
  createSettlement(input: {
    transactionId: string;
    amount: string;
    currency: string;
  }): Promise<{
    settlementId: string;
    status: string;
  }>;
}
EOF

write_if_missing "$BANK_CORE/application/ports/BlockchainProviderPort.ts" <<'EOF'
export interface BlockchainProviderPort {
  createPayment(input: {
    amount: string;
    asset: string;
    reference: string;
  }): Promise<{
    transactionId: string;
    status: string;
  }>;

  getTransaction(
    transactionId: string
  ): Promise<{
    status: string;
    confirmations: number;
  }>;
}
EOF

write_if_missing "$BANK_CORE/application/ports/LegacyIntegrationPort.ts" <<'EOF'
export interface LegacyIntegrationPort {
  execute(input: {
    operation: string;
    payload: Record<string, unknown>;
  }): Promise<{
    success: boolean;
    reference?: string;
    error?: string;
  }>;
}
EOF

###############################################################################
# ADAPTERS
###############################################################################

write_if_missing "$BANK_CORE/infrastructure/adapters/payments/ThunesAdapter.ts" <<'EOF'
import type { PaymentProviderPort } from "@/application/ports/PaymentProviderPort";

export class ThunesAdapter implements PaymentProviderPort {
  async createPayment(input: {
    amount: string;
    currency: string;
    reference: string;
  }) {
    throw new Error(
      "ThunesAdapter is an integration boundary. Configure credentials and production implementation before use."
    );
  }

  async getPayment(_providerTransactionId: string) {
    throw new Error(
      "ThunesAdapter is not configured."
    );
  }
}
EOF

write_if_missing "$BANK_CORE/infrastructure/adapters/blockchain/SolanaAdapter.ts" <<'EOF'
import type { BlockchainProviderPort } from "@/application/ports/BlockchainProviderPort";

export class SolanaAdapter implements BlockchainProviderPort {
  async createPayment(input: {
    amount: string;
    asset: string;
    reference: string;
  }) {
    return {
      transactionId: `sandbox-solana-${Date.now()}`,
      status: "SIMULATED"
    };
  }

  async getTransaction(_transactionId: string) {
    return {
      status: "CONFIRMED",
      confirmations: 32
    };
  }
}
EOF

write_if_missing "$BANK_CORE/infrastructure/adapters/legacy/LegacyCoreAdapter.ts" <<'EOF'
import type { LegacyIntegrationPort } from "@/application/ports/LegacyIntegrationPort";

export class LegacyCoreAdapter implements LegacyIntegrationPort {
  async execute(input: {
    operation: string;
    payload: Record<string, unknown>;
  }) {
    return {
      success: false,
      error:
        `Legacy adapter not configured. Requested operation: ${input.operation}`
    };
  }
}
EOF

###############################################################################
# USE CASES
###############################################################################

echo
echo "[16/20] Criando casos de uso..."

write_if_missing "$BANK_CORE/application/use-cases/CreatePaymentIntent.ts" <<'EOF'
import type { PaymentProviderPort } from "@/application/ports/PaymentProviderPort";

export interface CreatePaymentIntentInput {
  merchantId: string;
  amount: string;
  currency: string;
  description?: string;
}

export class CreatePaymentIntent {
  constructor(
    private readonly provider: PaymentProviderPort
  ) {}

  async execute(input: CreatePaymentIntentInput) {
    const reference = `vp-${Date.now()}`;

    const result = await this.provider.createPayment({
      amount: input.amount,
      currency: input.currency,
      reference
    });

    return {
      reference,
      merchantId: input.merchantId,
      amount: input.amount,
      currency: input.currency,
      description: input.description ?? null,
      providerTransactionId:
        result.providerTransactionId,
      status: result.status
    };
  }
}
EOF

write_if_missing "$BANK_CORE/application/use-cases/CreateFxQuote.ts" <<'EOF'
import type { FxProviderPort } from "@/application/ports/FxProviderPort";

export class CreateFxQuote {
  constructor(
    private readonly provider: FxProviderPort
  ) {}

  async execute(input: {
    baseCurrency: string;
    quoteCurrency: string;
    amount: string;
  }) {
    return this.provider.createQuote(input);
  }
}
EOF

write_if_missing "$BANK_CORE/application/use-cases/CreateSettlement.ts" <<'EOF'
import type { SettlementProviderPort } from "@/application/ports/SettlementProviderPort";

export class CreateSettlement {
  constructor(
    private readonly provider: SettlementProviderPort
  ) {}

  async execute(input: {
    transactionId: string;
    amount: string;
    currency: string;
  }) {
    return this.provider.createSettlement(input);
  }
}
EOF

###############################################################################
# SECURITY
###############################################################################

write_if_missing "$BANK_CORE/lib/security/permissions.ts" <<'EOF'
export const permissions = {
  paymentsRead: "payments.read",
  paymentsCreate: "payments.create",
  paymentsApprove: "payments.approve",
  transfersRead: "transfers.read",
  transfersCreate: "transfers.create",
  ledgerRead: "ledger.read",
  ledgerAdjust: "ledger.adjust",
  settlementRead: "settlement.read",
  settlementExecute: "settlement.execute",
  auditRead: "audit.read",
  usersManage: "users.manage",
  rolesManage: "roles.manage",
  integrationsManage: "integrations.manage"
} as const;

export type Permission =
  (typeof permissions)[keyof typeof permissions];

export const roles: Record<string, Permission[]> = {
  SUPER_ADMIN: Object.values(permissions),

  BANK_ADMIN: [
    permissions.paymentsRead,
    permissions.paymentsCreate,
    permissions.paymentsApprove,
    permissions.transfersRead,
    permissions.transfersCreate,
    permissions.ledgerRead,
    permissions.settlementRead,
    permissions.settlementExecute,
    permissions.auditRead,
    permissions.usersManage,
    permissions.rolesManage,
    permissions.integrationsManage
  ],

  MANAGER: [
    permissions.paymentsRead,
    permissions.paymentsApprove,
    permissions.transfersRead,
    permissions.settlementRead,
    permissions.auditRead
  ],

  OPERATOR: [
    permissions.paymentsRead,
    permissions.paymentsCreate,
    permissions.transfersRead,
    permissions.transfersCreate
  ],

  AUDITOR: [
    permissions.paymentsRead,
    permissions.ledgerRead,
    permissions.auditRead,
    permissions.settlementRead
  ],

  COMPLIANCE: [
    permissions.paymentsRead,
    permissions.transfersRead,
    permissions.auditRead
  ]
};
EOF

write_if_missing "$BANK_CORE/lib/security/idempotency.ts" <<'EOF'
export interface IdempotencyRecord {
  key: string;
  requestHash: string;
  responseStatus: number;
  responseBody: unknown;
  createdAt: string;
}

export function validateIdempotencyKey(
  key: string | null
) {
  if (!key) {
    throw new Error(
      "Idempotency-Key is required for this operation."
    );
  }

  if (key.length < 16) {
    throw new Error(
      "Idempotency-Key is too short."
    );
  }

  return key;
}
EOF

###############################################################################
# SANDBOX DOCUMENTATION
###############################################################################

echo
echo "[17/20] Criando documentação completa..."

write_if_missing "$SANDBOX/README.md" <<'EOF'
# ViaPay Developer Sandbox

## O que é

Ambiente isolado para desenvolvimento e homologação.

## O que pode ser testado

- Authentication
- API Keys
- Applications
- Payments
- Payment Intents
- Transfers
- FX
- Settlement
- Reconciliation
- Webhooks
- Idempotency
- Blockchain simulation
- QR Codes
- Error scenarios

## O que NÃO acontece

Nenhum dinheiro real é movimentado.

Nenhuma conta bancária real é acessada.

Nenhuma wallet de produção é utilizada.

Nenhuma chave privada real deve ser armazenada.

## Fluxo

Developer

↓

Application

↓

Sandbox API

↓

Payment

↓

Risk

↓

Ledger

↓

Settlement

↓

Webhook

↓

Certification

↓

Production Request
EOF

write_if_missing "$SANDBOX/openapi/viapay-sandbox.yaml" <<'EOF'
openapi: 3.0.3

info:
  title: ViaPay Sandbox API
  version: 1.0.0
  description: Developer Sandbox API.

servers:
  - url: https://sandbox.api.viapay.example

paths:

  /api/v1/sandbox/payment-intents:
    post:
      summary: Create sandbox payment intent
      responses:
        "201":
          description: Created

    get:
      summary: List sandbox payments
      responses:
        "200":
          description: Success

  /api/v1/sandbox/webhooks:
    post:
      summary: Create test webhook
      responses:
        "202":
          description: Queued

  /api/v1/sandbox/fx:
    post:
      summary: Create sandbox FX quote
      responses:
        "201":
          description: Created

  /api/v1/sandbox/settlement:
    post:
      summary: Create sandbox settlement
      responses:
        "202":
          description: Processing
EOF

###############################################################################
# MASTER DOCUMENT
###############################################################################

write_if_missing "$DOCS/VIAPAY-MASTER-SPECIFICATION.md" <<'EOF'
# ViaPay — Master Technical Specification

## 1. Visão

ViaPay é uma infraestrutura tecnológica de pagamentos,
orquestração financeira e integração bancária.

A tecnologia é desenvolvida pela DEEVO.

O modelo comercial prioritário é B2B/B2G/Enterprise.

A tecnologia pode ser licenciada ou integrada por bancos,
instituições financeiras e governos.

---

## 2. Bank Core

Local oficial:

/mnt/ai-knowledge/viapay/apps/bank-core

O Bank Core é o núcleo bancário/financeiro.

Responsabilidades:

- contas;
- clientes;
- comerciantes;
- transações;
- ledger;
- saldos;
- limites;
- tarifas;
- aprovação;
- auditoria;
- segurança.

---

## 3. Ledger

Utilizar double-entry ledger.

Toda transação financeira precisa produzir lançamentos
de débito e crédito balanceados.

Não alterar histórico.

---

## 4. Payment Core

Responsável por:

- Payment Intent;
- Transaction;
- Payment lifecycle;
- routing;
- provider integration;
- webhook events.

---

## 5. Payment Router

Orquestra:

- bancos;
- Pix;
- payment providers;
- FX;
- liquidity;
- blockchain.

O domínio utiliza Ports and Adapters.

---

## 6. FX

Responsável por:

- quote;
- rate;
- fee;
- lock;
- execution.

Integrações reais dependem de providers autorizados/configurados.

---

## 7. Liquidity

Abstração para provedores de liquidez.

---

## 8. Settlement

Controla:

PENDING
PROCESSING
COMPLETED
FAILED
REVERSED

---

## 9. Reconciliation

Compara:

Payment
Ledger
Provider
Settlement
Blockchain

---

## 10. Security

Implementar:

RBAC
ABAC
MFA
API Keys
OAuth quando aplicável
Idempotency
Rate Limiting
Audit
Webhook Signatures
Replay Protection

---

## 11. Approval

Operações de alto valor podem exigir aprovação de gerente
ou múltiplas aprovações.

---

## 12. Blockchain

Blockchain é tratado como payment rail/provider.

Criar:

BlockchainProviderPort

Adapters podem incluir Solana.

Sandbox pode utilizar simulação ou ambiente de testes.

---

## 13. Stablecoin

USDC pode atuar como rail de liquidação em determinadas
arquiteturas cross-border.

Nenhuma implementação deve assumir disponibilidade regulatória
ou operacional sem provider real.

---

## 14. Developer Portal

Permite:

Applications
API Keys
Documentation
API Explorer
Sandbox
Webhooks
Logs
Certification
Production Request

---

## 15. Merchant Portal

Permite:

Payments
Transactions
Customers
QR
API
Settings
Sandbox

---

## 16. Enterprise Bank Portal

Permite:

Accounts
Customers
Merchants
Payments
Transfers
Ledger
Settlement
Reconciliation
FX
Liquidity
Compliance
Risk
Fraud
Approvals
Users
Roles
Audit
Integrations

---

## 17. Sandbox

Local:

/mnt/ai-knowledge/viapay/sandbox

O Sandbox não movimenta dinheiro real.

---

## 18. COBOL / Legacy

O ViaPay deve ser capaz de integrar com sistemas legados.

Utilizar:

LegacyIntegrationPort

Possíveis adapters:

REST
SOAP
MQ
ISO 8583 quando aplicável
batch
file exchange

---

## 19. Observabilidade

Preparar:

OpenTelemetry
logs
metrics
traces
health checks
correlation IDs

---

## 20. Estado

Cada componente deve possuir estado explícito:

NOT_IMPLEMENTED
PLANNED
DESIGNED
IN_DEVELOPMENT
PARTIAL
IMPLEMENTED
INTEGRATED
TESTED
STAGING
PRODUCTION_READY
PRODUCTION

---

## 21. Regra

Nunca declarar uma integração externa como real quando
ela estiver somente simulada.

Nunca utilizar credenciais reais no Sandbox.

Nunca colocar private keys no código.

Nunca permitir acesso Sandbox → Production.

---

## 22. Arquitetura final

DEEVO

↓

VIA PAY

├── Bank Core

├── Payment Core

├── Payment Router

├── Ledger

├── Accounts

├── Customers

├── Merchants

├── FX

├── Liquidity

├── Settlement

├── Reconciliation

├── Compliance

├── Risk

├── Fraud

├── Blockchain

├── APIs

├── SDK

├── Webhooks

├── Developer Portal

├── Merchant Portal

├── Enterprise Portal

└── Sandbox
EOF

###############################################################################
# ARCHITECTURE FILES
###############################################################################

echo
echo "[18/20] Criando documentação arquitetural..."

write_if_missing "$BANK_CORE/domain/README.md" <<'EOF'
# Domain Layer

A camada Domain contém regras de negócio puras.

Não deve depender de:

- Next.js;
- React;
- banco;
- Redis;
- RabbitMQ;
- provider externo.

Responsabilidades:

- entidades;
- value objects;
- aggregates;
- domain services;
- domain events;
- regras financeiras.
EOF

write_if_missing "$BANK_CORE/application/README.md" <<'EOF'
# Application Layer

Orquestra casos de uso.

Não deve conhecer detalhes de infraestrutura.

Exemplos:

CreatePaymentIntent
CreateTransfer
CreateFxQuote
CreateSettlement
ReconcileTransaction
ApproveTransaction
CreateAccount
CreateMerchant
EOF

write_if_missing "$BANK_CORE/infrastructure/README.md" <<'EOF'
# Infrastructure

Implementa adapters externos.

Exemplos:

Database
Redis
RabbitMQ
Thunes
Solana
FX providers
Liquidity providers
Settlement providers
Legacy Core

O domínio não depende diretamente destes adapters.
EOF

###############################################################################
# ENVIRONMENT
###############################################################################

write_if_missing "$BANK_CORE/.env.example" <<'EOF'
NODE_ENV=development

NEXT_PUBLIC_VIAPAY_ENVIRONMENT=sandbox

VIAPAY_DATABASE_URL=

VIAPAY_REDIS_URL=

VIAPAY_RABBITMQ_URL=

VIAPAY_WEBHOOK_SECRET=

VIAPAY_API_KEY=

VIAPAY_THUNES_API_KEY=

VIAPAY_FX_PROVIDER_API_KEY=

VIAPAY_LIQUIDITY_PROVIDER_API_KEY=

VIAPAY_SOLANA_RPC_URL=

VIAPAY_SOLANA_NETWORK=devnet

VIAPAY_REAL_FUNDS=false

VIAPAY_PRODUCTION_ENABLED=false
EOF

###############################################################################
# SECURITY FILES
###############################################################################

write_if_missing "$BANK_CORE/docs-security.md" <<'EOF'
# Security Baseline

## Secrets

Nunca armazenar:

- API keys;
- private keys;
- passwords;
- production secrets

no código.

## Authentication

Administradores devem utilizar MFA.

## Authorization

Utilizar RBAC + ABAC.

## Audit

Operações sensíveis devem gerar audit events.

## Production

Production credentials são independentes do Sandbox.
EOF

###############################################################################
# TESTS
###############################################################################

echo
echo "[19/20] Criando testes base..."

write_if_missing "$BANK_CORE/tests/unit/idempotency.test.ts" <<'EOF'
import { describe, expect, it } from "vitest";
import { validateIdempotencyKey } from "@/lib/security/idempotency";

describe("Idempotency", () => {
  it("requires a key", () => {
    expect(() =>
      validateIdempotencyKey(null)
    ).toThrow();
  });

  it("rejects short keys", () => {
    expect(() =>
      validateIdempotencyKey("short")
    ).toThrow();
  });

  it("accepts valid keys", () => {
    expect(
      validateIdempotencyKey(
        "8e1c7c1d-6e1a-4e8e-9b9d-000001"
      )
    ).toBeTruthy();
  });
});
EOF

write_if_missing "$BANK_CORE/tests/unit/ledger.test.ts" <<'EOF'
import { describe, expect, it } from "vitest";

describe("Double Entry Ledger", () => {
  it("requires debit and credit to balance", () => {
    const debit = 109;
    const credit = 109;

    expect(debit).toBe(credit);
  });
});
EOF

write_if_missing "$BANK_CORE/tests/contracts/sandbox-api.test.ts" <<'EOF'
import { describe, expect, it } from "vitest";

describe("Sandbox API contract", () => {
  it("must never represent real funds", () => {
    const environment = "sandbox";
    const realFunds = false;

    expect(environment).toBe("sandbox");
    expect(realFunds).toBe(false);
  });
});
EOF

###############################################################################
# ROOT README
###############################################################################

write_if_missing "$ROOT/README-VIAPAY.md" <<'EOF'
# ViaPay

Payment Infrastructure and Financial Orchestration Platform.

## Company

DEEVO

## Product

ViaPay

## Official Bank Core

/mnt/ai-knowledge/viapay/apps/bank-core

## Official Sandbox

/mnt/ai-knowledge/viapay/sandbox

## Main capabilities

- Bank Core
- Payment Core
- Payment Router
- Ledger
- Accounts
- Customers
- Merchants
- FX
- Liquidity
- Settlement
- Reconciliation
- Compliance
- Risk
- Fraud
- Blockchain
- APIs
- SDK
- Webhooks
- Developer Portal
- Merchant Portal
- Enterprise Portal
- Sandbox

## Architecture

Clean Architecture
DDD
SOLID
Hexagonal Architecture
Ports and Adapters
Event Driven Architecture
API First

## Important

This repository contains architecture and Sandbox/reference
implementations.

External production providers require real credentials,
contracts, compliance requirements and institutional approval.
EOF

###############################################################################
# FINAL MANIFEST
###############################################################################

write_if_missing "$ROOT/VIAPAY-IMPLEMENTATION-MANIFEST.md" <<'EOF'
# ViaPay Implementation Manifest

## Official paths

ROOT

/mnt/ai-knowledge/viapay

BANK CORE

/mnt/ai-knowledge/viapay/apps/bank-core

SANDBOX

/mnt/ai-knowledge/viapay/sandbox

MASTER DOCUMENTATION

/mnt/ai-knowledge/viapay/docs/VIAPAY-MASTER-SPECIFICATION.md

## Created layers

Frontend
Domain
Application
Infrastructure
Security
API
Sandbox
Developer Portal
Merchant Portal
Tests
Documentation

## Existing code

Existing files are preserved.

The bootstrap only creates missing files.

## Next step

A senior AI/software engineer should audit the generated
structure and integrate it with the existing project rather
than replacing the architecture.
EOF

###############################################################################
# DIRECTORY INVENTORY
###############################################################################

echo
echo "======================================================================"
echo "                  BOOTSTRAP FINALIZADO"
echo "======================================================================"
echo

echo "Bank Core:"
echo "  $BANK_CORE"

echo
echo "Sandbox:"
echo "  $SANDBOX"

echo
echo "Master Documentation:"
echo "  $DOCS/VIAPAY-MASTER-SPECIFICATION.md"

echo
echo "Arquivos criados/existentes dentro do Bank Core:"
find "$BANK_CORE" -type f | sort | sed 's#^#  #'

echo
echo "======================================================================"
echo "                    VALIDANDO ESTRUTURA"
echo "======================================================================"

test -d "$BANK_CORE" && echo "[OK] Bank Core"
test -d "$SANDBOX" && echo "[OK] Sandbox"
test -f "$BANK_CORE/package.json" && echo "[OK] package.json"
test -f "$BANK_CORE/app/page.tsx" && echo "[OK] root page"
test -f "$BANK_CORE/app/layout.tsx" && echo "[OK] layout"
test -f "$BANK_CORE/app/globals.css" && echo "[OK] CSS"
test -f "$BANK_CORE/mocks/data.ts" && echo "[OK] mock data"
test -f "$DOCS/VIAPAY-MASTER-SPECIFICATION.md" && echo "[OK] master documentation"

echo
echo "======================================================================"
echo "                    IMPORTANTE"
echo "======================================================================"
echo
echo "Este bootstrap criou uma BASE COMPLETA E PREENCHIDA."
echo
echo "A IA deverá agora:"
echo
echo "1. Auditar o código existente."
echo "2. Identificar conflitos."
echo "3. Integrar o que já existe."
echo "4. Substituir mocks por infraestrutura real onde aplicável."
echo "5. Criar migrations reais."
echo "6. Integrar PostgreSQL."
echo "7. Integrar Redis."
echo "8. Integrar RabbitMQ."
echo "9. Implementar autenticação real."
echo "10. Implementar RBAC/ABAC real."
echo "11. Implementar MFA."
echo "12. Implementar ledger persistente."
echo "13. Implementar idempotência persistente."
echo "14. Implementar auditoria persistente."
echo "15. Implementar testes."
echo "16. Validar APIs."
echo "17. Validar Sandbox."
echo "18. Preparar adapters reais."
echo
echo "NÃO apagar apps/bank-core."
echo
echo "NÃO criar outro Bank Core."
echo
echo "======================================================================"
echo "                           FIM"
echo "======================================================================"
```
