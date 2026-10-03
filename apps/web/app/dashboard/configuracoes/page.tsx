import { Card } from "@/components/Card";
import { Input } from "@/components/Input";

export default function ConfiguracoesPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Configurações</h1><p className="mt-1 text-sm text-slate-500">Gerencie sua conta e integrações.</p></header>
      <main className="mx-auto max-w-5xl space-y-6 p-6">
        <Card className="p-6"><h2 className="font-bold">Dados da empresa</h2><div className="mt-5 grid gap-4 md:grid-cols-2"><Input placeholder="Nome da empresa" /><Input placeholder="CNPJ" /><Input placeholder="E-mail comercial" /><Input placeholder="Site" /></div></Card>
        <Card className="p-6"><h2 className="font-bold">Integração</h2><div className="mt-5 space-y-4"><Input placeholder="Webhook URL" /><Input placeholder="API Key" type="password" /></div></Card>
      </main>
    </>
  );
}
