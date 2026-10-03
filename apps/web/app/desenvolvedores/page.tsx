import Link from "next/link";
import { Code2, ExternalLink, Webhook } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

export default function DesenvolvedoresPage() {
  return (
    <>
      <Navbar />
      <main className="bg-slate-50 px-6 py-20">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-5xl font-bold">Desenvolvedores</h1>
          <p className="mt-4 max-w-2xl text-lg text-slate-600">Cadastro → credenciais → integração → cobrança → webhook → liquidação.</p>
          <div className="mt-12 grid gap-6 md:grid-cols-3">
            <Card className="p-6"><Code2 className="text-blue-600" /><h2 className="mt-5 font-bold">SDK</h2><p className="mt-2 text-sm text-slate-500">Integre a criação de cobranças de forma tipada.</p><Link href="/dashboard/documentacao" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Abrir documentação →</Link></Card>
            <Card className="p-6"><Webhook className="text-blue-600" /><h2 className="mt-5 font-bold">Webhooks</h2><p className="mt-2 text-sm text-slate-500">Receba eventos do ciclo de vida do pagamento.</p><Link href="/dashboard/webhooks" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Ver eventos →</Link></Card>
            <Card className="p-6"><ExternalLink className="text-blue-600" /><h2 className="mt-5 font-bold">API Reference</h2><p className="mt-2 text-sm text-slate-500">Contratos da API organizados por recurso.</p><Link href="/dashboard/documentacao" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Consultar →</Link></Card>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
