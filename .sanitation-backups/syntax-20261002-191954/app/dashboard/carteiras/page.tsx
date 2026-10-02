import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell;
import { Card } from "@/components/Card/Card;

export default function CarteirasPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Carteiras</h1>
        <p className="mt-1 text-sm text-slate-500">
          Gerencie sua operação ViaPay.
        </p>
      </header>

      <div className="p-6">
        <Card className="p-8">
          <h2 className="font-bold">Área Carteiras</h2>
          <p className="mt-2 text-sm text-slate-500">
            Componente preparado para integração com a API ViaPay.
          </p>
        </Card>
      </div>
    </DashboardShell>
  );
}
