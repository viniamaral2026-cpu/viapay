import { Card } from "@/components/Card/Card;
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell;
import { StatCard } from "@/components/dashboard/StatCard/StatCard;

const metrics = [
  {
    title: "Volume Processado",
    value: "R$ 12.480,32",
    change: "+12%",
  },
  {
    title: "Pagamentos",
    value: "128",
    change: "+8%",
  },
  {
    title: "Liquidações",
    value: "124",
    change: "+10%",
  },
  {
    title: "Saldo",
    value: "2.548,32",
    change: "+15%",
  },
];

export default function DashboardPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">
          Visão Geral
        </h1>

        <p className="mt-1 text-sm text-slate-500">
          Acompanhe sua operação ViaPay.
        </p>
      </header>

      <div className="space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-2 xl:grid-cols-4">
          {metrics.map((metric) => (
            <StatCard
              key={metric.title}
              {...metric}
            />
          ))}
        </div>

        <Card className="p-6">
          <h2 className="font-bold">
            Volume de pagamentos
          </h2>

          <div className="mt-8 flex h-64 items-end gap-2">
            {[30, 42, 38, 55, 48, 70, 61, 76, 68, 82, 75, 94].map(
              (height, index) => (
                <div
                  key={index}
                  className="flex-1 rounded-t bg-blue-500"
                  style={{
                    height: `${height}%`,
                  }}
                />
              ),
            )}
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
