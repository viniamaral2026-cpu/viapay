import { Copy, ExternalLink, Wallet } from "lucide-react";
import { Card } from "@/components/Card";

export default function CarteirasPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Carteiras</h1><p className="mt-1 text-sm text-slate-500">Carteira Solana usada para receber liquidações.</p></header>
      <main className="mx-auto max-w-5xl p-6">
        <Card className="p-6">
          <div className="flex items-center gap-3"><div className="rounded-xl bg-blue-50 p-3 text-blue-600"><Wallet /></div><div><h2 className="font-bold">Carteira de liquidação</h2><p className="text-sm text-slate-500">Solana • USDC</p></div></div>
          <div className="mt-8 rounded-2xl bg-slate-50 p-5"><p className="text-xs font-semibold uppercase text-slate-400">Endereço</p><div className="mt-2 flex items-center gap-2 break-all font-mono text-sm">7Yg...ViaPaySolanaWallet <Copy size={16} className="shrink-0 text-slate-400" /></div></div>
          <div className="mt-5 flex gap-3"><button className="rounded-xl border px-4 py-3 text-sm font-semibold">Alterar carteira</button><button className="inline-flex items-center gap-2 rounded-xl border px-4 py-3 text-sm font-semibold">Solana Explorer <ExternalLink size={16} /></button></div>
        </Card>
      </main>
    </>
  );
}
