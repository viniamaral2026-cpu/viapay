import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell";
import { Card } from "@/components/Card/Card";

export default async function PagamentoDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">
          Pagamento {id}
        </h1>
      </header>

      <div className="grid gap-6 p-6 lg:grid-cols-2">
        <Card className="p-6">
          <h2 className="font-bold">Detalhes</h2>

          <div className="mt-6 space-y-4 text-sm">
            <div className="flex justify-between">
              <span className="text-slate-500">Valor</span>
              <strong>R$ 100,00</strong>
            </div>

            <div className="flex justify-between">
              <span className="text-slate-500">USDC</span>
              <strong>18,42 USDC</strong>
            </div>

            <div className="flex justify-between">
              <span className="text-slate-500">Status</span>
              <strong className="text-emerald-600">
                Liquidado
              </strong>
            </div>
          </div>
        </Card>

        <Card className="p-6">
          <h2 className="font-bold">Timeline</h2>

          <div className="mt-6 space-y-5">
            {[
              "Pagamento criado",
              "Pix gerado",
              "Pix confirmado",
              "Conversão realizada",
              "Liquidação confirmada",
            ].map((event) => (
              <div key={event} className="flex gap-3 text-sm">
                <span className="mt-1 h-2.5 w-2.5 rounded-full bg-emerald-500" />
                {event}
              </div>
            ))}
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
