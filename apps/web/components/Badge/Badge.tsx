import { cn } from "@/lib/utils";

const styles: Record<string, string> = {
  Liquidado: "bg-emerald-50 text-emerald-700 ring-emerald-200",
  Pago: "bg-blue-50 text-blue-700 ring-blue-200",
  Processando: "bg-amber-50 text-amber-700 ring-amber-200",
  Expirado: "bg-red-50 text-red-700 ring-red-200",
  "Aguardando pagamento": "bg-slate-100 text-slate-700 ring-slate-200",
};

export function Badge({ children }: { children: string }) {
  return (
    <span className={cn(
      "inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ring-1 ring-inset",
      styles[children] || "bg-slate-100 text-slate-700 ring-slate-200",
    )}>
      {children}
    </span>
  );
}
