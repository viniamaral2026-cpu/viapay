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
