import { ArrowUpRight, CheckCircle2 } from "lucide-react";
import { Card } from "@/components/Card";

export default function LiquidacoesPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Liquidações</h1><p className="mt-1 text-sm text-slate-500">Acompanhe as liquidações em USDC na Solana.</p></header>
      <main className="mx-auto max-w-7xl space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-3">
          <Card className="p-5"><p className="text-sm text-slate-500">Total liquidado</p><p className="mt-2 text-2xl font-bold">2.348,52 USDC</p></Card>
          <Card className="p-5"><p className="text-sm text-slate-500">Liquidações</p><p className="mt-2 text-2xl font-bold">124</p></Card>
          <Card className="p-5"><p className="text-sm text-slate-500">Status</p><p className="mt-2 flex items-center gap-2 text-2xl font-bold"><CheckCircle2 className="text-emerald-500" />Operacional</p></Card>
        </div>
        <Card className="overflow-hidden">
          <div className="border-b p-5 font-bold">Histórico de liquidações</div>
          <div className="divide-y">
            {["set_01J25a7", "set_01J25a1", "set_01J24ff"].map((id, i) => <div key={id} className="flex items-center justify-between p-5 text-sm"><div><p className="font-mono">{id}</p><p className="mt-1 text-slate-500">Pagamento pay_01J2... • 30/10/2026</p></div><div className="flex items-center gap-5"><strong>{[18.42,46.10,14.73][i].toFixed(2)} USDC</strong><ArrowUpRight className="text-blue-600" size={17} /></div></div>)}
          </div>
        </Card>
      </main>
    </>
  );
}
