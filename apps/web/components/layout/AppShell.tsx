"use client";

import type { ReactNode } from "react";

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <div className="viapay-app-shell">
      <aside className="viapay-sidebar">
        <div className="viapay-brand">VIAPAY</div>

        <nav>
          <a href="/dashboard">Dashboard</a>
          <a href="/dashboard/pagamentos">Pagamentos</a>
          <a href="/dashboard/cobrancas">Cobranças</a>
          <a href="/dashboard/payment-links">Payment Links</a>
          <a href="/dashboard/clientes">Clientes</a>
          <a href="/dashboard/produtos">Produtos</a>
          <a href="/dashboard/assinaturas">Assinaturas</a>
          <a href="/dashboard/pix">PIX</a>
          <a href="/dashboard/liquidacoes">Liquidações</a>
          <a href="/dashboard/relatorios">Relatórios</a>
          <a href="/dashboard/developers">Developers</a>
          <a href="/dashboard/integracoes">Integrações</a>
          <a href="/dashboard/configuracoes">Configurações</a>
        </nav>
      </aside>

      <section className="viapay-main">
        <header className="viapay-topbar">
          <span>VIAPAY</span>
          <span>Conta empresarial</span>
        </header>

        <div className="viapay-main-content">
          {children}
        </div>
      </section>
    </div>
  );
}
