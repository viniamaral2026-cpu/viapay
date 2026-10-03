import { Download, Filter, Search } from "lucide-react";
import { PaymentTable } from "@/components/dashboard/PaymentTable";

export default function PagamentosPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Pagamentos</h1><p className="mt-1 text-sm text-slate-500">Acompanhe todos os seus pagamentos em tempo real.</p></header>
      <div className="mx-auto max-w-7xl space-y-5 p-6">
        <div className="flex flex-col gap-3 md:flex-row">
          <div className="relative flex-1"><Search className="absolute left-3 top-3 text-slate-400" size={18} /><input className="w-full rounded-xl border border-slate-200 bg-white py-3 pl-10 pr-4 text-sm" placeholder="Buscar por ID, cliente ou valor..." /></div>
          <button className="inline-flex items-center justify-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold"><Filter size={17} />Filtro</button>
          <button className="inline-flex items-center justify-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold"><Download size={17} />Exportar</button>
        </div>
        <div className="overflow-x-auto"><PaymentTable /></div>
      </div>
    </>
  );
}
