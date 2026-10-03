"use client";

import React from "react";

const title = "Cartão de Cobrança";
const description = "Detalhes do cartão de cobrança do pagamento";

export default function Page() {
  return (
    <main className="vp-page">
      <header className="vp-page-header">
        <div>
          <h1>{title}</h1>
          <p>{description}</p>
        </div>

        <div className="vp-page-actions">
          <button className="vp-button vp-button-secondary">
            Exportar
          </button>

          <button className="vp-button vp-button-primary">
            Nova operação
          </button>
        </div>
      </header>

      <section className="vp-card">
        <div className="vp-card-header">
          <div>
            <h2>{title}</h2>
            <p>Área preparada para integração com a API VIAPAY.</p>
          </div>
        </div>

        <div className="vp-empty-state">
          <div className="vp-empty-icon">◎</div>
          <h3>Conteúdo disponível após integração</h3>
          <p>
            A estrutura visual desta página está pronta.
            Os dados reais serão conectados posteriormente ao backend.
          </p>
        </div>
      </section>
    </main>
  );
}
