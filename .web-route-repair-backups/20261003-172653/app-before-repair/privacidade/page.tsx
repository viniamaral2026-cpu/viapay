"use client";

import React from "react";

const title = "Privacidade";
const description = "Declaração de privacidade";

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
            Fechar
          </button>
        </div>
      </header>

      <section className="vp-card">
        <div className="vp-card-header">
          <div>
            <h2>{title}</h2>
            <p>Área preparada.</p>
          </div>
        </div>

        <div className="vp-empty-state">
          <div className="vp-empty-icon">◎</div>
          <h3>Conteúdo disponível</h3>
          <p>Estrutura pronta.</p>
        </div>
      </section>
    </main>
  );
}
