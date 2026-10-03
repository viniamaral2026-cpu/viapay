import { Card } from "@/components/Card";

export default function WebhooksPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Webhooks</h1><p className="mt-1 text-sm text-slate-500">Eventos enviados para sua aplicação.</p></header>
      <main className="mx-auto max-w-5xl space-y-6 p-6">
        <Card className="p-6"><h2 className="font-bold">Endpoint</h2><div className="mt-4 rounded-xl bg-slate-950 p-4 font-mono text-sm text-slate-200">https://suaempresa.com/api/viapay/webhook</div></Card>
        <Card className="overflow-hidden"><div className="border-b p-5 font-bold">Eventos</div><div className="divide-y">{["payment.created","payment.pix_confirmed","payment.settling","payment.settled"].map((event) => <div key={event} className="p-5 text-sm"><span className="font-mono text-blue-600">{event}</span><p className="mt-1 text-slate-500">Evento de ciclo de vida do pagamento.</p></div>)}</div></Card>
      </main>
    </>
  );
}
