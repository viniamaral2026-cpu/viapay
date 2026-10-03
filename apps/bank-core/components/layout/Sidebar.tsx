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
