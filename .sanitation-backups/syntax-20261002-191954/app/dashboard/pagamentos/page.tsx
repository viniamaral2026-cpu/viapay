import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell;
import { Card } from "@/components/Card/Card;

const payments = [
  ["pay_001", "Cliente A", "R$ 100,00", "18,42 USDC"],
  ["pay_002", "Cliente B", "R$ 250,00", "46,10 USDC"],
  ["pay_003", "Cliente C", "R$ 80,00", "14,73 USDC"],
];

export default function PagamentosPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Pagamentos</h1>
      </header>

      <div className="p-6">
        <Card>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50">
                <tr>
                  <th className="px-5 py-4">ID</th>
                  <th className="px-5 py-4">Cliente</th>
                  <th className="px-5 py-4">BRL</th>
                  <th className="px-5 py-4">USDC</th>
                </tr>
              </thead>

              <tbody>
                {payments.map(([id, customer, brl, usdc]) => (
                  <tr key={id} className="border-t">
                    <td className="px-5 py-4">
                      <Link
                        href={`/dashboard/pagamentos/${id}`}
                        className="font-semibold text-blue-600"
                      >
                        {id}
                      </Link>
                    </td>
                    <td className="px-5 py-4">{customer}</td>
                    <td className="px-5 py-4">{brl}</td>
                    <td className="px-5 py-4">{usdc}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
