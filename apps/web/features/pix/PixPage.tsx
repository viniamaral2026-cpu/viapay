import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell";
import { Card } from "@/components/Card/Card";

export function PixPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">PIX</h1>
      </header>

      <div className="p-6">
        <Card>
          <h2>Cobranças PIX</h2>
          <p>Gerenciar cobranças Pix</p>

          <div className="mt-4">
            <button className="vp-button">Nova Cobrança</button>
            <button className="vp-button vp-button-outline">Histórico</button>
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
