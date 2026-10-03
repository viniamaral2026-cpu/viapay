import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell";
import { Card } from "@/components/Card/Card";

interface Payment {
  id: string;
  customer: string;
  amount: string;
  status: "pending" | "processing" | "succeeded" | "failed";
  method: string;
}

const mockPayments: Payment[] = [
  { id: "pay_001", customer: "Cliente A", amount: "R$ 100,00", status: "succeeded", method: "pix" },
  { id: "pay_002", customer: "Cliente B", amount: "R$ 250,00", status: "processing", method: "card" },
  { id: "pay_003", customer: "Cliente C", amount: "R$ 80,00", status: "failed", method: "pix" },
];

export function PaymentsPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Pagamentos</h1>
      </header>

      <div className="p-6">
        <Card>
          <h2>Histórico de Pagamentos</h2>
          <p>Visualizar todos os pagamentos processados</p>
          <ul>
            <li>pay_001: R$ 100,00 - PIX - Concluído</li>
            <li>pay_002: R$ 250,00 - Cartão - Em processamento</li>
            <li>pay_003: R$ 80,00 - PIX - Falhou</li>
          </ul>
        </Card>
      </div>
    </DashboardShell>
  );
}
