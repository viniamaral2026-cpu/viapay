import { Card } from "@/components/Card";
import { StatCard } from "@/components/dashboard/StatCard";

export default function DashboardPage() {
  const metrics = [
    ["Volume Processado", "R$ 12.480,32", "+12%"],
    ["Pagamentos", "128", "+8%"],
    ["Liquidações", "124", "+10%"],
    ["USDC Recebido", "2.348,52 USDC", "+15%"],
  ] as const;

  const bars = [30,42,38,55,48,70,61,76,68,82,75,94];

  return (
    <>
      <header className="border-b bg-white px-6 py-6">
        <div className="mx-auto max-w-7xl"><p className="text-xs font-semibold uppercase tracking-wider text-blue-600">Últimos 30 dias</p><h1 className="mt-1 text-2xl font-bold">Visão Geral</h1></div>
      </header>
      <div className="mx-auto max-w-7xl space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-2 xl:grid-cols-4">
          {metrics.map(([title, value, change]) => <StatCard key={title} title={title} value={value} change={change} />)}
        </div>
        <Card className="p-6">
          <div className="flex items-center justify-between"><h2 className="font-bold">Volume de pagamentos</h2><select className="rounded-lg border border-slate-200 px-3 py-2 text-sm"><option>BRL</option><option>USDC</option></select></div>
          <div className="mt-8 flex h-64 items-end gap-2">
            {bars.map((height, index) => <div key={index} className="flex-1 rounded-t bg-blue-500" style={{ height: `${height}%` }} />)}
          </div>
          <div className="mt-3 flex justify-between text-xs text-slate-400"><span>1 out</span><span>8 out</span><span>15 out</span><span>22 out</span><span>30 out</span></div>
        </Card>
      </div>
    </>
  );
}
