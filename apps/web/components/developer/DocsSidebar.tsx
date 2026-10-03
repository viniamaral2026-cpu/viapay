import Link from "next/link";

const items = ["Introdução", "Instalação", "Primeiros passos", "Exemplos", "API Reference", "Webhooks", "Ambiente de Testes", "Boas práticas"];

export function DocsSidebar() {
  return (
    <aside className="border-r bg-white p-6">
      <p className="font-bold">Documentação</p>
      <nav className="mt-5 space-y-1">{items.map((item, i) => <Link key={item} href="/dashboard/documentacao" className={`block rounded-lg px-3 py-2 text-sm ${i === 0 ? "bg-blue-50 font-semibold text-blue-700" : "text-slate-500 hover:bg-slate-50"}`}>{item}</Link>)}</nav>
    </aside>
  );
}
