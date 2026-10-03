import Link from "next/link";
import { ArrowLeft, CheckCircle2, Circle } from "lucide-react";
import { Badge } from "@/components/Badge";
import { Card } from "@/components/Card";

export default async function PaymentDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const timeline = [
    ["Pagamento criado", "14:32", true],
    ["QR Pix gerado", "14:32", true],
    ["Pagamento confirmado", "14:33", true],
    ["Conversão para USDC", "14:33", true],
    ["Transferência na Solana", "14:34", true],
    ["Liquidado", "14:34", true],
  ] as const;

  return (
    <div>
      <header className="border-b bg-white px-6 py-6">
        <div className="mx-auto max-w-7xl">
          <Link href="/dashboard/pagamentos" className="inline-flex items-center gap-2 text-sm text-slate-500"><ArrowLeft size={16} />Voltar para pagamentos</Link>
          <div className="mt-4 flex flex-wrap items-center gap-3"><h1 className="text-2xl font-bold">Pagamento #{id}</h1><Badge>Liquidado</Badge></div>
          <p className="mt-1 text-sm text-slate-500">Criado em 30 de outubro de 2026 às 14:32</p>
        </div>
      </header>
      <main className="mx-auto grid max-w-7xl gap-6 p-6 lg:grid-cols-2">
        <Card className="p-6">
          <h2 className="font-bold">Informações gerais</h2>
          <dl className="mt-6 divide-y divide-slate-100">
            {[
              ["Valor (BRL)", "R$ 100,00"],
              ["USDC recebido", "18,42 USDC"],
              ["Câmbio utilizado", "1 USDC = R$ 5,43"],
              ["Status", "Liquidado"],
              ["Cliente", "Cliente Exemplo"],
              ["Referência", "order_123"],
              ["Expira em", "30/10/2026 15:02"],
            ].map(([label, value]) => <div key={label} className="flex justify-between gap-6 py-4 text-sm"><dt className="text-slate-500">{label}</dt><dd className="font-semibold text-right">{value}</dd></div>)}
          </dl>
        </Card>
        <Card className="p-6">
          <h2 className="font-bold">Linha do tempo</h2>
          <div className="mt-6 space-y-5">
            {timeline.map(([label, time, done]) => <div key={label} className="flex gap-3"><div className="mt-0.5">{done ? <CheckCircle2 className="text-emerald-500" size={19} /> : <Circle size={19} />}</div><div className="flex-1 flex justify-between text-sm"><span>{label}</span><span className="text-slate-400">{time}</span></div></div>)}
          </div>
        </Card>
      </main>
    </div>
  );
}
