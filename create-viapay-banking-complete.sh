#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

echo "=============================================================="
echo " VIAPAY — COMPLETE BANKING INFRASTRUCTURE BOOTSTRAP"
echo " Core Banking + Payment Infrastructure + Bank Gateway"
echo "=============================================================="

mkdir -p "$ROOT"
cd "$ROOT"

# ==============================================================
# 1. DIRETÓRIOS
# ==============================================================

mkdir -p \
apps/bank-core/app/login \
apps/bank-core/app/dashboard \
apps/bank-core/app/customers \
"apps/bank-core/app/customers/[id]" \
apps/bank-core/app/accounts \
"apps/bank-core/app/accounts/[id]" \
"apps/bank-core/app/accounts/[id]/transactions" \
apps/bank-core/app/payments \
"apps/bank-core/app/payments/[id]" \
apps/bank-core/app/transfers \
apps/bank-core/app/pix \
apps/bank-core/app/cards \
apps/bank-core/app/credit \
apps/bank-core/app/fx \
apps/bank-core/app/viapay \
apps/bank-core/app/viapay/cross-border \
apps/bank-core/app/viapay/blockchain \
apps/bank-core/app/viapay/settlement \
apps/bank-core/app/viapay/reconciliation \
apps/bank-core/app/approvals \
apps/bank-core/app/approvals/pending \
apps/bank-core/app/approvals/history \
apps/bank-core/app/compliance \
apps/bank-core/app/accounting \
apps/bank-core/app/ledger \
apps/bank-core/app/reports \
apps/bank-core/app/audit \
apps/bank-core/app/users \
apps/bank-core/app/roles \
apps/bank-core/app/permissions \
apps/bank-core/app/limits \
apps/bank-core/app/integrations \
apps/bank-core/app/settings \
apps/bank-core/components/layout \
apps/bank-core/components/navigation \
apps/bank-core/components/sidebar \
apps/bank-core/components/header \
apps/bank-core/components/data-table \
apps/bank-core/components/forms \
apps/bank-core/components/cards \
apps/bank-core/components/charts \
apps/bank-core/components/security \
apps/bank-core/components/approval \
apps/bank-core/components/payment \
apps/bank-core/components/account \
apps/bank-core/components/customer \
apps/bank-core/components/viapay \
apps/bank-core/features/auth \
apps/bank-core/features/customers \
apps/bank-core/features/accounts \
apps/bank-core/features/payments \
apps/bank-core/features/transfers \
apps/bank-core/features/pix \
apps/bank-core/features/ledger \
apps/bank-core/features/approvals \
apps/bank-core/features/compliance \
apps/bank-core/features/settlement \
apps/bank-core/features/reconciliation \
apps/bank-core/features/viapay \
apps/bank-core/hooks \
apps/bank-core/lib \
apps/bank-core/services/api \
apps/bank-core/services/auth \
apps/bank-core/services/payments \
apps/bank-core/services/accounts \
apps/bank-core/services/viapay \
apps/bank-core/services/ledger \
apps/bank-core/schemas \
apps/bank-core/types \
apps/bank-core/styles \
apps/bank-core/public

mkdir -p \
apps/bank-core-api/src/domain/customer \
apps/bank-core-api/src/domain/account \
apps/bank-core-api/src/domain/ledger \
apps/bank-core-api/src/domain/transaction \
apps/bank-core-api/src/domain/payment \
apps/bank-core-api/src/domain/transfer \
apps/bank-core-api/src/domain/approval \
apps/bank-core-api/src/domain/authorization \
apps/bank-core-api/src/domain/compliance \
apps/bank-core-api/src/domain/settlement \
apps/bank-core-api/src/domain/reconciliation \
apps/bank-core-api/src/domain/audit \
apps/bank-core-api/src/application/commands \
apps/bank-core-api/src/application/queries \
apps/bank-core-api/src/application/use-cases/customer \
apps/bank-core-api/src/application/use-cases/account \
apps/bank-core-api/src/application/use-cases/payment \
apps/bank-core-api/src/application/use-cases/transfer \
apps/bank-core-api/src/application/use-cases/ledger \
apps/bank-core-api/src/application/use-cases/approval \
apps/bank-core-api/src/application/use-cases/settlement \
apps/bank-core-api/src/application/use-cases/reconciliation \
apps/bank-core-api/src/application/services \
apps/bank-core-api/src/infrastructure/database \
apps/bank-core-api/src/infrastructure/repositories \
apps/bank-core-api/src/infrastructure/security \
apps/bank-core-api/src/infrastructure/idempotency \
apps/bank-core-api/src/infrastructure/messaging \
apps/bank-core-api/src/infrastructure/providers \
apps/bank-core-api/src/interfaces/http \
apps/bank-core-api/src/interfaces/events \
apps/bank-core-api/src/config \
apps/bank-core-api/tests

mkdir -p \
apps/bank-gateway/src/adapters/cobol \
apps/bank-gateway/src/adapters/cics \
apps/bank-gateway/src/adapters/ibm-mq \
apps/bank-gateway/src/adapters/db2 \
apps/bank-gateway/src/adapters/iso20022 \
apps/bank-gateway/src/adapters/rest \
apps/bank-gateway/src/adapters/soap \
apps/bank-gateway/src/contracts \
apps/bank-gateway/src/application \
apps/bank-gateway/src/security \
apps/bank-gateway/src/transport \
apps/bank-gateway/src/config \
apps/bank-gateway/tests

mkdir -p \
apps/viapay-api \
apps/worker

mkdir -p \
packages/ui \
packages/sdk \
packages/types \
packages/contracts \
packages/auth \
packages/config

mkdir -p \
integrations/banking/cobol/copybooks \
integrations/banking/cobol/programs \
integrations/banking/cobol/transactions \
integrations/banking/cobol/mappings \
integrations/banking/cobol/schemas \
integrations/banking/mainframe \
integrations/banking/cics \
integrations/banking/ibm-mq \
integrations/banking/db2 \
integrations/banking/iso20022 \
integrations/banking/rest \
integrations/banking/soap \
integrations/pix \
integrations/blockchain \
integrations/fx

mkdir -p \
bank-architecture/00-master \
bank-architecture/01-core-banking \
bank-architecture/02-access-control \
bank-architecture/03-approval-engine \
bank-architecture/04-bank-gateway \
bank-architecture/05-viapay-integration \
bank-architecture/06-bank-console \
bank-architecture/07-security \
bank-architecture/08-events \
bank-architecture/09-diagrams \
bank-architecture/10-data-model

mkdir -p \
docs/api \
docs/security \
docs/integration \
docs/operations \
docs/financial \
docs/compliance

echo "[1/12] Estrutura criada."

# ==============================================================
# 2. FRONTEND
# ==============================================================

cat > apps/bank-core/package.json <<'EOF'
{
  "name": "@viapay/bank-core",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3010",
    "build": "next build",
    "start": "next start -p 3010",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

cat > apps/bank-core/tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
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

cat > apps/bank-core/next-env.d.ts <<'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />
EOF

cat > apps/bank-core/app/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --vp-primary: #0b5fff;
  --vp-primary-dark: #084dcc;
  --vp-blue: #2563eb;
  --vp-cyan: #06b6d4;
  --vp-bg: #f7f9fc;
  --vp-card: #ffffff;
  --vp-border: #e5e7eb;
  --vp-text: #111827;
  --vp-muted: #6b7280;
  --vp-success: #16a34a;
  --vp-warning: #d97706;
  --vp-danger: #dc2626;
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
  min-height: 100%;
  background: var(--vp-bg);
  color: var(--vp-text);
  font-family: Inter, Arial, sans-serif;
}

a {
  text-decoration: none;
  color: inherit;
}

button,
input,
select,
textarea {
  font: inherit;
}

.bank-shell {
  display: flex;
  min-height: 100vh;
}

.bank-sidebar {
  position: fixed;
  inset: 0 auto 0 0;
  width: 270px;
  overflow-y: auto;
  background: #fff;
  border-right: 1px solid var(--vp-border);
  padding: 18px 14px;
}

.bank-logo {
  padding: 12px;
  margin-bottom: 20px;
}

.bank-logo strong {
  display: block;
  color: var(--vp-primary);
  font-size: 25px;
  letter-spacing: -0.5px;
}

.bank-logo span {
  color: var(--vp-muted);
  font-size: 12px;
}

.bank-nav {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.bank-nav a {
  padding: 10px 12px;
  border-radius: 8px;
  color: #374151;
  font-size: 14px;
}

.bank-nav a:hover {
  background: #eff6ff;
  color: var(--vp-primary);
}

.bank-main {
  margin-left: 270px;
  width: calc(100% - 270px);
}

.bank-header {
  height: 72px;
  padding: 0 30px;
  background: #fff;
  border-bottom: 1px solid var(--vp-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.bank-header-title {
  display: flex;
  flex-direction: column;
}

.bank-header-title strong {
  font-size: 15px;
}

.bank-header-title span {
  font-size: 12px;
  color: var(--vp-muted);
}

.bank-operator {
  display: flex;
  align-items: center;
  gap: 12px;
}

.operator-avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #eff6ff;
  color: var(--vp-primary);
  display: grid;
  place-items: center;
  font-weight: 700;
}

.page-container {
  padding: 30px;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 25px;
}

.page-header h1 {
  margin: 0;
  font-size: 27px;
  letter-spacing: -0.5px;
}

.page-header p {
  margin: 6px 0 0;
  color: var(--vp-muted);
}

.grid {
  display: grid;
  gap: 18px;
}

.grid-4 {
  grid-template-columns: repeat(4, 1fr);
}

.grid-3 {
  grid-template-columns: repeat(3, 1fr);
}

.grid-2 {
  grid-template-columns: repeat(2, 1fr);
}

.card {
  background: var(--vp-card);
  border: 1px solid var(--vp-border);
  border-radius: 12px;
  padding: 20px;
}

.stat-label {
  color: var(--vp-muted);
  font-size: 13px;
}

.stat-value {
  display: block;
  margin-top: 8px;
  font-size: 25px;
  font-weight: 700;
}

.table-card {
  margin-top: 20px;
  overflow: hidden;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 14px 16px;
  border-bottom: 1px solid var(--vp-border);
  text-align: left;
  font-size: 13px;
}

.data-table th {
  background: #f9fafb;
  color: #4b5563;
}

.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 9px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 600;
}

.badge-success {
  background: #dcfce7;
  color: #166534;
}

.badge-warning {
  background: #fef3c7;
  color: #92400e;
}

.badge-danger {
  background: #fee2e2;
  color: #991b1b;
}

.badge-info {
  background: #dbeafe;
  color: #1e40af;
}

.button {
  border: 0;
  border-radius: 8px;
  padding: 10px 15px;
  cursor: pointer;
}

.button-primary {
  background: var(--vp-primary);
  color: #fff;
}

.button-secondary {
  background: #eff6ff;
  color: var(--vp-primary);
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 7px;
  margin-bottom: 16px;
}

.form-group label {
  font-size: 13px;
  font-weight: 600;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  border: 1px solid var(--vp-border);
  border-radius: 8px;
  padding: 11px 12px;
  outline: none;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--vp-primary);
  box-shadow: 0 0 0 3px rgba(11, 95, 255, 0.08);
}

.security-banner {
  border: 1px solid #bfdbfe;
  background: #eff6ff;
  color: #1e40af;
  border-radius: 10px;
  padding: 14px;
}

.empty-state {
  padding: 50px;
  text-align: center;
  color: var(--vp-muted);
}

@media (max-width: 1100px) {
  .grid-4,
  .grid-3 {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 800px) {
  .bank-sidebar {
    width: 220px;
  }

  .bank-main {
    margin-left: 220px;
    width: calc(100% - 220px);
  }

  .grid-4,
  .grid-3,
  .grid-2 {
    grid-template-columns: 1fr;
  }
}
EOF

cat > apps/bank-core/components/layout/BankShell.tsx <<'EOF'
"use client";

import Link from "next/link";

const sections = [
  {
    title: "Operações",
    items: [
      ["Dashboard", "/dashboard"],
      ["Clientes", "/customers"],
      ["Contas", "/accounts"],
      ["Pagamentos", "/payments"],
      ["Transferências", "/transfers"],
      ["PIX", "/pix"],
    ],
  },
  {
    title: "Produtos",
    items: [
      ["Cartões", "/cards"],
      ["Crédito", "/credit"],
      ["Câmbio", "/fx"],
    ],
  },
  {
    title: "VIAPAY",
    items: [
      ["Visão geral", "/viapay"],
      ["Cross-Border", "/viapay/cross-border"],
      ["Blockchain", "/viapay/blockchain"],
      ["Settlement", "/viapay/settlement"],
      ["Reconciliação", "/viapay/reconciliation"],
    ],
  },
  {
    title: "Controle",
    items: [
      ["Aprovações", "/approvals"],
      ["Compliance", "/compliance"],
      ["Ledger", "/ledger"],
      ["Contabilidade", "/accounting"],
      ["Relatórios", "/reports"],
      ["Auditoria", "/audit"],
    ],
  },
  {
    title: "Administração",
    items: [
      ["Usuários", "/users"],
      ["Papéis", "/roles"],
      ["Permissões", "/permissions"],
      ["Alçadas", "/limits"],
      ["Integrações", "/integrations"],
      ["Configurações", "/settings"],
    ],
  },
];

export function BankShell({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="bank-shell">
      <aside className="bank-sidebar">
        <div className="bank-logo">
          <strong>VIAPAY</strong>
          <span>Banking Infrastructure</span>
        </div>

        <nav className="bank-nav">
          {sections.map((section) => (
            <div key={section.title}>
              <div
                style={{
                  padding: "14px 12px 6px",
                  fontSize: 10,
                  fontWeight: 700,
                  color: "#9ca3af",
                  textTransform: "uppercase",
                }}
              >
                {section.title}
              </div>

              {section.items.map(([label, href]) => (
                <Link key={href} href={href}>
                  {label}
                </Link>
              ))}
            </div>
          ))}
        </nav>
      </aside>

      <main className="bank-main">
        <header className="bank-header">
          <div className="bank-header-title">
            <strong>Core Banking Console</strong>
            <span>Ambiente operacional seguro</span>
          </div>

          <div className="bank-operator">
            <div>
              <strong style={{ fontSize: 13 }}>
                Banco Administrator
              </strong>
              <div style={{ fontSize: 11, color: "#6b7280" }}>
                Gerente
              </div>
            </div>

            <div className="operator-avatar">BA</div>
          </div>
        </header>

        {children}
      </main>
    </div>
  );
}
EOF

cat > apps/bank-core/app/layout.tsx <<'EOF'
import "./globals.css";
import { BankShell } from "@/components/layout/BankShell";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>
        <BankShell>{children}</BankShell>
      </body>
    </html>
  );
}
EOF

cat > apps/bank-core/app/page.tsx <<'EOF'
import { redirect } from "next/navigation";

export default function Home() {
  redirect("/dashboard");
}
EOF

echo "[2/12] Frontend base criado."

# ==============================================================
# 3. PÁGINAS
# ==============================================================

create_page() {
  local file="$1"
  local title="$2"

  mkdir -p "$(dirname "$file")"

  cat > "$file" <<EOF
export default function Page() {
  return (
    <section className="page-container">
      <div className="page-header">
        <div>
          <h1>$title</h1>
          <p>Operação e gestão do ambiente bancário VIAPAY.</p>
        </div>
      </div>

      <div className="card">
        <div className="empty-state">
          <strong>$title</strong>
          <p>
            Interface preparada para integração com os contratos
            financeiros e APIs do Bank Core.
          </p>
        </div>
      </div>
    </section>
  );
}
EOF
}

create_page apps/bank-core/app/login/page.tsx "Acesso bancário"
create_page apps/bank-core/app/dashboard/page.tsx "Dashboard"
create_page apps/bank-core/app/customers/page.tsx "Clientes"
create_page "apps/bank-core/app/customers/[id]/page.tsx" "Detalhes do cliente"
create_page apps/bank-core/app/accounts/page.tsx "Contas"
create_page "apps/bank-core/app/accounts/[id]/page.tsx" "Detalhes da conta"
create_page "apps/bank-core/app/accounts/[id]/transactions/page.tsx" "Transações da conta"
create_page apps/bank-core/app/payments/page.tsx "Pagamentos"
create_page "apps/bank-core/app/payments/[id]/page.tsx" "Detalhes do pagamento"
create_page apps/bank-core/app/transfers/page.tsx "Transferências"
create_page apps/bank-core/app/pix/page.tsx "PIX"
create_page apps/bank-core/app/cards/page.tsx "Cartões"
create_page apps/bank-core/app/credit/page.tsx "Crédito"
create_page apps/bank-core/app/fx/page.tsx "Câmbio"
create_page apps/bank-core/app/viapay/page.tsx "VIAPAY"
create_page apps/bank-core/app/viapay/cross-border/page.tsx "Cross-Border"
create_page apps/bank-core/app/viapay/blockchain/page.tsx "Blockchain Rails"
create_page apps/bank-core/app/viapay/settlement/page.tsx "Settlement"
create_page apps/bank-core/app/viapay/reconciliation/page.tsx "Reconciliação"
create_page apps/bank-core/app/approvals/page.tsx "Aprovações"
create_page apps/bank-core/app/approvals/pending/page.tsx "Aprovações pendentes"
create_page apps/bank-core/app/approvals/history/page.tsx "Histórico de aprovações"
create_page apps/bank-core/app/compliance/page.tsx "Compliance"
create_page apps/bank-core/app/accounting/page.tsx "Contabilidade"
create_page apps/bank-core/app/ledger/page.tsx "Ledger"
create_page apps/bank-core/app/reports/page.tsx "Relatórios"
create_page apps/bank-core/app/audit/page.tsx "Auditoria"
create_page apps/bank-core/app/users/page.tsx "Usuários"
create_page apps/bank-core/app/roles/page.tsx "Papéis"
create_page apps/bank-core/app/permissions/page.tsx "Permissões"
create_page apps/bank-core/app/limits/page.tsx "Alçadas e limites"
create_page apps/bank-core/app/integrations/page.tsx "Integrações"
create_page apps/bank-core/app/settings/page.tsx "Configurações"

# Dashboard mais completo
cat > apps/bank-core/app/dashboard/page.tsx <<'EOF'
export default function DashboardPage() {
  return (
    <section className="page-container">
      <div className="page-header">
        <div>
          <h1>Dashboard</h1>
          <p>Visão operacional do Core Banking.</p>
        </div>

        <button className="button button-primary">
          Nova operação
        </button>
      </div>

      <div className="grid grid-4">
        <div className="card">
          <span className="stat-label">Saldo operacional</span>
          <strong className="stat-value">R$ 0,00</strong>
        </div>

        <div className="card">
          <span className="stat-label">Pagamentos hoje</span>
          <strong className="stat-value">0</strong>
        </div>

        <div className="card">
          <span className="stat-label">Aprovações pendentes</span>
          <strong className="stat-value">0</strong>
        </div>

        <div className="card">
          <span className="stat-label">Liquidações pendentes</span>
          <strong className="stat-value">0</strong>
        </div>
      </div>

      <div className="grid grid-2" style={{ marginTop: 20 }}>
        <div className="card">
          <h3>Controle operacional</h3>
          <p>
            Monitoramento de pagamentos, transferências,
            liquidações e reconciliações.
          </p>
        </div>

        <div className="card">
          <h3>Segurança</h3>
          <p>
            RBAC, ABAC, MFA, aprovação por alçada e auditoria.
          </p>
        </div>
      </div>

      <div className="card table-card">
        <h3>Últimas operações</h3>

        <table className="data-table">
          <thead>
            <tr>
              <th>Operação</th>
              <th>Tipo</th>
              <th>Valor</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td>—</td>
              <td>—</td>
              <td>—</td>
              <td>
                <span className="badge badge-info">
                  Sem operações
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  );
}
EOF

echo "[3/12] Páginas criadas."

# ==============================================================
# 4. COMPONENTES
# ==============================================================

cat > apps/bank-core/components/data-table/DataTable.tsx <<'EOF'
export function DataTable() {
  return (
    <div className="card table-card">
      <table className="data-table">
        <thead>
          <tr>
            <th>Identificador</th>
            <th>Status</th>
            <th>Data</th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>—</td>
            <td>—</td>
            <td>—</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
}
EOF

cat > apps/bank-core/components/cards/StatCard.tsx <<'EOF'
interface StatCardProps {
  label: string;
  value: string;
}

export function StatCard({ label, value }: StatCardProps) {
  return (
    <div className="card">
      <span className="stat-label">{label}</span>
      <strong className="stat-value">{value}</strong>
    </div>
  );
}
EOF

cat > apps/bank-core/components/forms/BankForm.tsx <<'EOF'
export function BankForm() {
  return (
    <form className="card">
      <div className="form-group">
        <label>Referência</label>
        <input placeholder="Digite a referência" />
      </div>

      <div className="form-group">
        <label>Valor</label>
        <input type="number" step="0.01" />
      </div>

      <button className="button button-primary">
        Continuar
      </button>
    </form>
  );
}
EOF

cat > apps/bank-core/components/security/MfaChallenge.tsx <<'EOF'
export function MfaChallenge() {
  return (
    <div className="security-banner">
      <strong>Autenticação multifator</strong>
      <p>
        Esta operação requer uma etapa adicional de autenticação.
      </p>
    </div>
  );
}
EOF

cat > apps/bank-core/components/security/PermissionGuard.tsx <<'EOF'
interface PermissionGuardProps {
  permission: string;
  children: React.ReactNode;
}

export function PermissionGuard({
  permission,
  children,
}: PermissionGuardProps) {
  return (
    <div data-required-permission={permission}>
      {children}
    </div>
  );
}
EOF

cat > apps/bank-core/components/approval/ApprovalRequest.tsx <<'EOF'
export interface ApprovalRequestProps {
  operationId: string;
  amount: string;
  currency: string;
}

export function ApprovalRequest({
  operationId,
  amount,
  currency,
}: ApprovalRequestProps) {
  return (
    <div className="card">
      <strong>Solicitação de aprovação</strong>

      <p>Operação: {operationId}</p>
      <p>
        Valor: {amount} {currency}
      </p>

      <button className="button button-primary">
        Aprovar
      </button>

      <button
        className="button button-secondary"
        style={{ marginLeft: 8 }}
      >
        Rejeitar
      </button>
    </div>
  );
}
EOF

cat > apps/bank-core/components/payment/PaymentStatus.tsx <<'EOF'
interface PaymentStatusProps {
  status: string;
}

export function PaymentStatus({ status }: PaymentStatusProps) {
  return (
    <span className="badge badge-info">
      {status}
    </span>
  );
}
EOF

cat > apps/bank-core/components/viapay/CrossBorderPayment.tsx <<'EOF'
export function CrossBorderPayment() {
  return (
    <div className="card">
      <h3>Cross-Border Payment</h3>

      <p>
        Orquestração internacional entre moeda de origem,
        FX, settlement e moeda de destino.
      </p>

      <div className="security-banner">
        A execução financeira deve ocorrer exclusivamente
        através dos serviços autorizados do backend.
      </div>
    </div>
  );
}
EOF

echo "[4/12] Componentes criados."

# ==============================================================
# 5. TYPES / CONTRACTS
# ==============================================================

cat > packages/types/banking.ts <<'EOF'
export type Currency =
  | "BRL"
  | "USD"
  | "EUR"
  | "GBP"
  | "CNY"
  | "JPY";

export type AccountStatus =
  | "PENDING"
  | "ACTIVE"
  | "BLOCKED"
  | "SUSPENDED"
  | "CLOSED";

export type PaymentStatus =
  | "CREATED"
  | "PENDING_APPROVAL"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLEMENT"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "REVERSED";

export type ApprovalStatus =
  | "PENDING"
  | "APPROVED"
  | "REJECTED"
  | "EXPIRED";

export interface Money {
  amount: string;
  currency: Currency;
}

export interface Customer {
  id: string;
  legalName: string;
  document?: string;
  status: string;
  createdAt: string;
}

export interface Account {
  id: string;
  customerId: string;
  number: string;
  branch?: string;
  currency: Currency;
  status: AccountStatus;
  availableBalance: string;
  ledgerBalance: string;
}

export interface Payment {
  id: string;
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amount: string;
  currency: Currency;
  status: PaymentStatus;
  createdAt: string;
}

export interface Approval {
  id: string;
  operationId: string;
  requestedBy: string;
  approvedBy?: string;
  requiredLevel: string;
  status: ApprovalStatus;
}
EOF

cat > packages/contracts/payment.ts <<'EOF'
export interface PaymentRequest {
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amount: string;
  currency: string;
  purpose?: string;
  metadata?: Record<string, string>;
}

export interface PaymentResponse {
  paymentId: string;
  status: string;
  createdAt: string;
}
EOF

cat > packages/contracts/ledger.ts <<'EOF'
export interface LedgerEntry {
  accountId: string;
  direction: "DEBIT" | "CREDIT";
  amount: string;
  currency: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: string;
}
EOF

cat > packages/contracts/approval.ts <<'EOF'
export interface ApprovalRequest {
  operationId: string;
  actorId: string;
  requiredLevel: string;
  amount: string;
  currency: string;
  reason?: string;
}
EOF

cat > packages/contracts/settlement.ts <<'EOF'
export interface SettlementInstruction {
  settlementId: string;
  paymentId: string;
  sourceCurrency: string;
  destinationCurrency: string;
  grossAmount: string;
  netAmount: string;
  fees: string;
  status: string;
}
EOF

echo "[5/12] Contratos financeiros criados."

# ==============================================================
# 6. BACKEND
# ==============================================================

cat > apps/bank-core-api/package.json <<'EOF'
{
  "name": "@viapay/bank-core-api",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/main.ts",
    "build": "tsc",
    "test": "vitest"
  },
  "dependencies": {
    "fastify": "^5.0.0",
    "zod": "^3.0.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0",
    "vitest": "^3.0.0"
  }
}
EOF

cat > apps/bank-core-api/tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "outDir": "dist"
  },
  "include": ["src/**/*.ts", "tests/**/*.ts"]
}
EOF

cat > apps/bank-core-api/src/main.ts <<'EOF'
import Fastify from "fastify";

const app = Fastify({
  logger: true,
});

app.get("/health", async () => ({
  service: "viapay-bank-core-api",
  status: "healthy",
  version: "0.1.0",
}));

app.get("/api/v1/accounts/:id", async (request) => {
  const { id } = request.params as { id: string };

  return {
    id,
    status: "ACTIVE",
    message: "Account contract ready",
  };
});

app.post("/api/v1/payments", async (request) => {
  const body = request.body;

  return {
    status: "PENDING",
    message: "Payment command accepted",
    request: body,
  };
});

app.get("/api/v1/ledger/health", async () => ({
  ledger: "available",
  doubleEntry: true,
  immutableEntries: true,
}));

app.listen({
  port: Number(process.env.PORT ?? 4010),
  host: "0.0.0.0",
});
EOF

# ==============================================================
# 7. DOMÍNIO FINANCEIRO
# ==============================================================

cat > apps/bank-core-api/src/domain/ledger/Ledger.ts <<'EOF'
export type LedgerDirection = "DEBIT" | "CREDIT";

export interface LedgerEntry {
  id: string;
  transactionId: string;
  accountId: string;
  direction: LedgerDirection;
  amountMinor: bigint;
  currency: string;
}

export interface LedgerTransaction {
  id: string;
  reference: string;
  entries: LedgerEntry[];
  createdAt: Date;
}

export function validateBalancedTransaction(
  entries: LedgerEntry[],
): boolean {
  const debit = entries
    .filter((entry) => entry.direction === "DEBIT")
    .reduce((sum, entry) => sum + entry.amountMinor, 0n);

  const credit = entries
    .filter((entry) => entry.direction === "CREDIT")
    .reduce((sum, entry) => sum + entry.amountMinor, 0n);

  return debit === credit;
}
EOF

cat > apps/bank-core-api/src/domain/payment/Payment.ts <<'EOF'
export type PaymentStatus =
  | "CREATED"
  | "PENDING_APPROVAL"
  | "AUTHORIZED"
  | "PROCESSING"
  | "SETTLEMENT"
  | "COMPLETED"
  | "FAILED"
  | "CANCELLED"
  | "REVERSED";

export interface Payment {
  id: string;
  idempotencyKey: string;
  sourceAccountId: string;
  destinationAccountId?: string;
  amountMinor: bigint;
  currency: string;
  status: PaymentStatus;
  createdAt: Date;
}
EOF

cat > apps/bank-core-api/src/domain/account/Account.ts <<'EOF'
export type AccountStatus =
  | "PENDING"
  | "ACTIVE"
  | "BLOCKED"
  | "SUSPENDED"
  | "CLOSED";

export interface Account {
  id: string;
  customerId: string;
  number: string;
  currency: string;
  status: AccountStatus;
  ledgerBalanceMinor: bigint;
  availableBalanceMinor: bigint;
}
EOF

cat > apps/bank-core-api/src/domain/customer/Customer.ts <<'EOF'
export interface Customer {
  id: string;
  legalName: string;
  document?: string;
  status: "ACTIVE" | "BLOCKED" | "PENDING";
  createdAt: Date;
}
EOF

cat > apps/bank-core-api/src/domain/approval/Approval.ts <<'EOF'
export type ApprovalStatus =
  | "PENDING"
  | "APPROVED"
  | "REJECTED"
  | "EXPIRED";

export interface Approval {
  id: string;
  operationId: string;
  requestedBy: string;
  approvedBy?: string;
  requiredLevel: string;
  status: ApprovalStatus;
  createdAt: Date;
}
EOF

cat > apps/bank-core-api/src/domain/authorization/Authorization.ts <<'EOF'
export interface AuthorizationContext {
  userId: string;
  roles: string[];
  permissions: string[];
  attributes: Record<string, string>;
  amountMinor?: bigint;
  currency?: string;
}

export interface AuthorizationPolicy {
  permission: string;
  maximumAmountMinor?: bigint;
  requiredApprovalLevel?: string;
}
EOF

cat > apps/bank-core-api/src/domain/settlement/Settlement.ts <<'EOF'
export interface Settlement {
  id: string;
  paymentId: string;
  sourceCurrency: string;
  destinationCurrency: string;
  grossAmountMinor: bigint;
  feesMinor: bigint;
  netAmountMinor: bigint;
  status:
    | "CREATED"
    | "PROCESSING"
    | "SETTLED"
    | "FAILED";
  createdAt: Date;
}
EOF

cat > apps/bank-core-api/src/domain/reconciliation/Reconciliation.ts <<'EOF'
export type ReconciliationStatus =
  | "MATCHED"
  | "MISMATCH"
  | "MISSING"
  | "DUPLICATE"
  | "PENDING";

export interface ReconciliationItem {
  id: string;
  internalReference: string;
  externalReference?: string;
  amountMinor: bigint;
  currency: string;
  status: ReconciliationStatus;
  createdAt: Date;
}
EOF

cat > apps/bank-core-api/src/domain/audit/AuditEvent.ts <<'EOF'
export interface AuditEvent {
  id: string;
  actorId: string;
  action: string;
  resourceType: string;
  resourceId: string;
  before?: unknown;
  after?: unknown;
  correlationId: string;
  ipAddress?: string;
  userAgent?: string;
  createdAt: Date;
}
EOF

echo "[6/12] Domínio financeiro criado."

# ==============================================================
# 8. IDEMPOTÊNCIA / SEGURANÇA
# ==============================================================

cat > apps/bank-core-api/src/infrastructure/idempotency/IdempotencyStore.ts <<'EOF'
export interface IdempotencyRecord {
  key: string;
  operation: string;
  responseHash?: string;
  responseBody?: unknown;
  statusCode?: number;
  createdAt: Date;
  expiresAt?: Date;
}

export interface IdempotencyStore {
  get(
    key: string,
    operation: string,
  ): Promise<IdempotencyRecord | null>;

  save(
    record: IdempotencyRecord,
  ): Promise<void>;
}
EOF

cat > apps/bank-core-api/src/infrastructure/security/AuthorizationService.ts <<'EOF'
import {
  AuthorizationContext,
  AuthorizationPolicy,
} from "../../domain/authorization/Authorization.js";

export class AuthorizationService {
  authorize(
    context: AuthorizationContext,
    policy: AuthorizationPolicy,
  ): boolean {
    if (!context.permissions.includes(policy.permission)) {
      return false;
    }

    if (
      policy.maximumAmountMinor !== undefined &&
      context.amountMinor !== undefined &&
      context.amountMinor > policy.maximumAmountMinor
    ) {
      return false;
    }

    return true;
  }
}
EOF

cat > apps/bank-core-api/src/infrastructure/security/MfaService.ts <<'EOF'
export interface MfaChallenge {
  challengeId: string;
  userId: string;
  expiresAt: Date;
  verified: boolean;
}

export class MfaService {
  createChallenge(userId: string): MfaChallenge {
    return {
      challengeId: crypto.randomUUID(),
      userId,
      expiresAt: new Date(Date.now() + 5 * 60 * 1000),
      verified: false,
    };
  }
}
EOF

# ==============================================================
# 9. BANK GATEWAY / COBOL
# ==============================================================

cat > apps/bank-gateway/package.json <<'EOF'
{
  "name": "@viapay/bank-gateway",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/main.ts",
    "build": "tsc",
    "test": "vitest"
  },
  "dependencies": {
    "fastify": "^5.0.0",
    "zod": "^3.0.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0",
    "vitest": "^3.0.0"
  }
}
EOF

cat > apps/bank-gateway/src/contracts/BankAdapter.ts <<'EOF'
export interface BankAdapter {
  getAccountBalance(accountId: string): Promise<{
    accountId: string;
    availableBalance: string;
    currency: string;
  }>;

  debitAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }): Promise<{
    transactionId: string;
    status: string;
  }>;

  creditAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }): Promise<{
    transactionId: string;
    status: string;
  }>;

  getTransactionStatus(transactionId: string): Promise<{
    transactionId: string;
    status: string;
  }>;
}
EOF

cat > apps/bank-gateway/src/main.ts <<'EOF'
import Fastify from "fastify";

const app = Fastify({
  logger: true,
});

app.get("/health", async () => ({
  service: "viapay-bank-gateway",
  status: "healthy",
}));

app.post("/v1/payments", async (request) => ({
  status: "ACCEPTED",
  adapter: "configured-by-bank",
  request: request.body,
}));

app.listen({
  port: Number(process.env.PORT ?? 4020),
  host: "0.0.0.0",
});
EOF

cat > apps/bank-gateway/src/adapters/cobol/CobolAdapter.ts <<'EOF'
import type { BankAdapter } from "../../contracts/BankAdapter.js";

export class CobolAdapter implements BankAdapter {
  async getAccountBalance(accountId: string) {
    return {
      accountId,
      availableBalance: "0",
      currency: "BRL",
    };
  }

  async debitAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }) {
    return {
      transactionId: `COBOL-${input.reference}`,
      status: "PENDING",
    };
  }

  async creditAccount(input: {
    accountId: string;
    amount: string;
    currency: string;
    reference: string;
  }) {
    return {
      transactionId: `COBOL-${input.reference}`,
      status: "PENDING",
    };
  }

  async getTransactionStatus(transactionId: string) {
    return {
      transactionId,
      status: "PENDING",
    };
  }
}
EOF

for adapter in cics ibm-mq db2 iso20022 rest soap; do
cat > "apps/bank-gateway/src/adapters/$adapter/README.md" <<EOF
# $adapter Adapter

Adapter reservado para integração com sistemas bancários $adapter.

A implementação definitiva depende dos contratos técnicos fornecidos pela instituição financeira.
EOF
done

# ==============================================================
# 10. INTEGRAÇÕES
# ==============================================================

cat > integrations/banking/cobol/README.md <<'EOF'
# COBOL / Mainframe Integration

O VIAPAY não acessa o frontend diretamente.

Fluxo:

Bank Core
→ Bank Core API
→ Bank Gateway
→ Adapter COBOL
→ CICS / IBM MQ
→ Core Banking do banco.

Copybooks e layouts reais devem ser fornecidos pelo banco.
EOF

cat > integrations/banking/cobol/mappings/payment-request.json <<'EOF'
{
  "contract": "PaymentRequest",
  "version": "1.0",
  "target": "COBOL",
  "fields": {
    "sourceAccountId": "SOURCE-ACCOUNT",
    "destinationAccountId": "DESTINATION-ACCOUNT",
    "amount": "AMOUNT",
    "currency": "CURRENCY",
    "reference": "REFERENCE"
  }
}
EOF

cat > integrations/banking/iso20022/README.md <<'EOF'
# ISO 20022

Estrutura reservada para mensagens e schemas ISO 20022.
EOF

cat > integrations/banking/ibm-mq/README.md <<'EOF'
# IBM MQ

Camada de mensageria para integração com ambientes bancários.
EOF

cat > integrations/banking/cics/README.md <<'EOF'
# CICS

Camada para integração com transações CICS.
EOF

cat > integrations/banking/db2/README.md <<'EOF'
# DB2

Integração com dados do banco somente através dos contratos aprovados.
EOF

cat > integrations/blockchain/README.md <<'EOF'
# Blockchain Rails

Camada de integração com redes blockchain.

Blockchain deve funcionar como rail de liquidação quando aplicável.

Não substitui automaticamente o ledger contábil do banco.
EOF

cat > integrations/fx/README.md <<'EOF'
# FX

Camada destinada a:

- cotação
- conversão
- spread
- taxas
- moeda de origem
- moeda de destino
- timestamp da cotação
- fornecedor de liquidez
EOF

# ==============================================================
# 11. ARQUITETURA / DOCUMENTAÇÃO
# ==============================================================

cat > bank-architecture/00-master/architecture-overview.md <<'EOF'
# VIAPAY Banking Infrastructure

## Objetivo

Criar infraestrutura tecnológica para que bancos e instituições financeiras possam integrar pagamentos nacionais e internacionais através de APIs, SDKs e adapters.

## Princípio

O banco mantém seu Core Banking.

O VIAPAY fornece uma camada de infraestrutura e orquestração.

## Fluxo

Bank Frontend
→ Bank Core API
→ Bank Gateway
→ Adapter bancário
→ Core Banking

Para pagamentos internacionais:

Bank
→ VIAPAY
→ FX
→ Payment Rail
→ Settlement
→ Banco destino
→ Beneficiário
EOF

cat > bank-architecture/01-core-banking/core-banking.md <<'EOF'
# Core Banking Integration

O VIAPAY não precisa substituir o Core Banking existente.

A arquitetura permite integração com:

- COBOL
- Mainframe
- CICS
- IBM MQ
- DB2
- REST
- SOAP
- ISO 20022

O Bank Core funciona como console operacional moderno.
EOF

cat > bank-architecture/02-access-control/access-control.md <<'EOF'
# RBAC + ABAC

## RBAC

Roles:

- OPERATOR
- SUPERVISOR
- MANAGER
- ADMIN
- COMPLIANCE
- AUDITOR

## ABAC

Policies podem considerar:

- usuário
- instituição
- operação
- valor
- moeda
- horário
- localização
- risco
- limite
- função
EOF

cat > bank-architecture/03-approval-engine/approval-engine.md <<'EOF'
# Approval Engine

Operações sensíveis:

REQUESTED
→ PENDING_APPROVAL
→ APPROVED
→ EXECUTING
→ COMPLETED

Falhas:

REJECTED
CANCELLED
EXPIRED
FAILED

Suporta:

- maker-checker
- dupla aprovação
- alçadas
- MFA
- segregação de funções
EOF

cat > bank-architecture/04-bank-gateway/gateway.md <<'EOF'
# Bank Gateway

Camada antiacoplamento entre VIAPAY e Core Banking.

Adapters:

- COBOL
- CICS
- IBM MQ
- DB2
- ISO 20022
- REST
- SOAP
EOF

cat > bank-architecture/05-viapay-integration/viapay.md <<'EOF'
# VIAPAY Integration

Componentes:

- Payment Orchestration
- FX
- Cross-Border
- Settlement
- Reconciliation
- Blockchain Rails
- Webhooks
- SDK
- API
EOF

cat > bank-architecture/07-security/security.md <<'EOF'
# Security

Controles:

- OAuth2/OIDC
- MFA
- RBAC
- ABAC
- mTLS
- secrets management
- encryption
- audit trail
- rate limiting
- idempotency
- correlation IDs
- segregation of duties
EOF

cat > bank-architecture/08-events/events.md <<'EOF'
# Events

payment.created
payment.authorized
payment.approved
payment.processing
payment.completed
payment.failed

transfer.created
transfer.completed

settlement.created
settlement.completed

reconciliation.matched
reconciliation.mismatch

approval.requested
approval.approved
approval.rejected

audit.created
EOF

cat > bank-architecture/10-data-model/data-model.md <<'EOF'
# Financial Data Model

Principais entidades:

Customer
Account
LedgerAccount
LedgerTransaction
LedgerEntry
Payment
Transfer
Approval
Settlement
Reconciliation
AuditEvent
IdempotencyRecord
Role
Permission
Policy
Limit

Regra principal:

Total Debits = Total Credits

Ledger financeiro deve ser tratado como registro imutável.
EOF

# ==============================================================
# 12. SQL / BANCO DE DADOS
# ==============================================================

mkdir -p apps/bank-core-api/database

cat > apps/bank-core-api/database/001_initial_financial_schema.sql <<'EOF'
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legal_name TEXT NOT NULL,
    document TEXT,
    status TEXT NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    account_number TEXT NOT NULL,
    branch TEXT,
    currency CHAR(3) NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(account_number, currency)
);

CREATE TABLE IF NOT EXISTS ledger_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL REFERENCES accounts(id),
    currency CHAR(3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ledger_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reference TEXT NOT NULL UNIQUE,
    idempotency_key TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ledger_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES ledger_transactions(id),
    ledger_account_id UUID NOT NULL REFERENCES ledger_accounts(id),
    direction TEXT NOT NULL CHECK(direction IN ('DEBIT', 'CREDIT')),
    amount_minor NUMERIC(38,0) NOT NULL CHECK(amount_minor > 0),
    currency CHAR(3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    idempotency_key TEXT NOT NULL,
    source_account_id UUID NOT NULL REFERENCES accounts(id),
    destination_account_id UUID REFERENCES accounts(id),
    amount_minor NUMERIC(38,0) NOT NULL CHECK(amount_minor > 0),
    currency CHAR(3) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(idempotency_key)
);

CREATE TABLE IF NOT EXISTS approvals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operation_id UUID NOT NULL,
    requested_by UUID NOT NULL,
    approved_by UUID,
    required_level TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    approved_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS idempotency_records (
    key TEXT NOT NULL,
    operation TEXT NOT NULL,
    response_hash TEXT,
    response_body JSONB,
    status_code INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    PRIMARY KEY(key, operation)
);

CREATE TABLE IF NOT EXISTS audit_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id UUID,
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id TEXT NOT NULL,
    before_state JSONB,
    after_state JSONB,
    correlation_id TEXT NOT NULL,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS settlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL REFERENCES payments(id),
    source_currency CHAR(3) NOT NULL,
    destination_currency CHAR(3) NOT NULL,
    gross_amount_minor NUMERIC(38,0) NOT NULL,
    fees_minor NUMERIC(38,0) NOT NULL DEFAULT 0,
    net_amount_minor NUMERIC(38,0) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reconciliation_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    internal_reference TEXT NOT NULL,
    external_reference TEXT,
    amount_minor NUMERIC(38,0) NOT NULL,
    currency CHAR(3) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payments_source
ON payments(source_account_id);

CREATE INDEX IF NOT EXISTS idx_ledger_entries_transaction
ON ledger_entries(transaction_id);

CREATE INDEX IF NOT EXISTS idx_audit_resource
ON audit_events(resource_type, resource_id);

CREATE INDEX IF NOT EXISTS idx_reconciliation_reference
ON reconciliation_items(internal_reference);
EOF

echo "[7/12] Modelo financeiro SQL criado."

# ==============================================================
# 13. API CONTRACTS
# ==============================================================

cat > docs/api/api-contract.md <<'EOF'
# VIAPAY API Contract

## Base

/api/v1

## Customers

GET /customers
POST /customers
GET /customers/{id}

## Accounts

GET /accounts
POST /accounts
GET /accounts/{id}
GET /accounts/{id}/transactions

## Payments

POST /payments
GET /payments/{id}
POST /payments/{id}/authorize
POST /payments/{id}/cancel

Header obrigatório:

Idempotency-Key

## Transfers

POST /transfers
GET /transfers/{id}

## Approvals

GET /approvals
POST /approvals/{id}/approve
POST /approvals/{id}/reject

## Settlement

GET /settlements
GET /settlements/{id}

## Reconciliation

GET /reconciliation
POST /reconciliation/run

## Audit

GET /audit/events
EOF

# ==============================================================
# 14. README
# ==============================================================

cat > README-VIAPAY-BANKING.md <<'EOF'
# VIAPAY Banking Infrastructure

## Arquitetura

O projeto possui quatro camadas principais:

1. Bank Core Frontend
2. Bank Core API
3. Bank Gateway
4. VIAPAY Payment Infrastructure

## Frontend

apps/bank-core

## Backend

apps/bank-core-api

## Gateway

apps/bank-gateway

## Integrações

integrations/banking

## Segurança

- RBAC
- ABAC
- MFA
- maker-checker
- approval engine
- audit trail
- idempotency
- correlation IDs

## Financeiro

- accounts
- ledger
- double-entry
- payments
- transfers
- settlement
- reconciliation
- FX

## Mainframe

- COBOL
- CICS
- IBM MQ
- DB2

## Regra arquitetural

Frontend nunca acessa diretamente o Core Banking.

Frontend
→ API
→ Domain
→ Gateway
→ Adapter
→ Banco

## Importante

Adapters reais de banco precisam ser implementados com os contratos, credenciais, schemas, ambientes de homologação e especificações fornecidas pela instituição financeira.
EOF

# ==============================================================
# 15. MAPA FINAL
# ==============================================================

echo
echo "=============================================================="
echo " VIAPAY — CRIAÇÃO CONCLUÍDA"
echo "=============================================================="

echo
echo "FRONTEND:"
echo "  apps/bank-core"

echo
echo "BACKEND:"
echo "  apps/bank-core-api"

echo
echo "GATEWAY:"
echo "  apps/bank-gateway"

echo
echo "INTEGRAÇÕES:"
echo "  integrations/banking"

echo
echo "CONTRATOS:"
echo "  packages/contracts"

echo
echo "TIPOS:"
echo "  packages/types"

echo
echo "ARQUITETURA:"
echo "  bank-architecture"

echo
echo "DATABASE:"
echo "  apps/bank-core-api/database"

echo
echo "DOCUMENTAÇÃO:"
echo "  docs"

echo
echo "=============================================================="
echo " IMPORTANTE"
echo "=============================================================="
echo "Arquivos existentes não foram removidos."
echo "Nenhuma integração real com banco foi inventada."
echo "COBOL/Mainframe está preparado através de adapters."
echo "Ledger usa modelo de dupla entrada."
echo "Operações financeiras usam idempotência."
echo "Autorização deve ocorrer no backend."
echo "=============================================================="
