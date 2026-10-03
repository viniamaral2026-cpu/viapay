import Link from "next/link";
import { ArrowUpRight } from "lucide-react";
import { Badge } from "@/components/Badge";

const rows = [
  ["pay_01J2...", "Cliente Exemplo", "R$ 100,00", "18,42 USDC", "Liquidado", "30/10 14:32"],
  ["pay_01J25...", "Maria Silva", "R$ 250,00", "46,10 USDC", "Liquidado", "30/10 13:21"],
  ["pay_01J24...", "João Santos", "R$ 80,00", "14,73 USDC", "Processando", "30/10 12:45"],
  ["pay_01J23...", "Ana Costa", "R$ 150,00", "27,68 USDC", "Pago", "30/10 10:18"],
  ["pay_01J22...", "Pedro Lima", "R$ 320,00", "58,90 USDC", "Expirado", "30/10 09:12"],
] as const;

export function PaymentTable() {
  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white">
      <table className="w-full min-w-[800px] text-left text-sm">
        <thead className="border-b bg-slate-50 text-xs uppercase text-slate-500">
          <tr>{["ID", "Cliente", "Valor (BRL)", "USDC", "Status", "Data", ""].map((h) => <th key={h} className="px-5 py-4">{h}</th>)}</tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row[0]} className="border-b last:border-0 hover:bg-slate-50">
              {row.map((cell, i) => <td key={`${row[0]}-${i}`} className="px-5 py-4">{i === 4 ? <Badge>{cell}</Badge> : <span className={i === 0 ? "font-mono text-xs" : ""}>{cell}</span>}</td>)}
              <td className="px-5 py-4"><Link href="/dashboard/pagamentos/pay_01J25a7f3" className="text-blue-600"><ArrowUpRight size={17} /></Link></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
