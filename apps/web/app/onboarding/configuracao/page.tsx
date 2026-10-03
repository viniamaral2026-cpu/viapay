import React from "react";

export default function Page() {
  return (
    <main className="min-h-screen bg-white p-8">
      <section className="mx-auto max-w-7xl">
        <header className="mb-8">
          <p className="text-sm font-medium text-blue-600">
            ViaPay
          </p>

          <h1 className="mt-2 text-3xl font-semibold text-slate-900">
            configuracao
          </h1>

          <p className="mt-3 max-w-3xl text-slate-600">
            Área institucional do ViaPay.
            Esta página foi criada automaticamente porque a rota
            estava vazia. A implementação funcional deve consumir
            os contratos e APIs reais do backend.
          </p>
        </header>

        <div className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <p className="text-sm text-slate-500">
            Estado: estrutura inicial criada.
          </p>
        </div>
      </section>
    </main>
  );
}
