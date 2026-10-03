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
