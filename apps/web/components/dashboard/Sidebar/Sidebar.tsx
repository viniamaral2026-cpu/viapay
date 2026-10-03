import Link from "next/link";
import { ArrowLeftRight, BookOpen, CreditCard, LayoutDashboard, Settings, Wallet, Webhook } from "lucide-react";
import { Logo } from "@/components/Logo";

const navigation = [
  ["/dashboard", "Visão Geral", LayoutDashboard],
  ["/dashboard/pagamentos", "Pagamentos", CreditCard],
  ["/dashboard/liquidacoes", "Liquidações", ArrowLeftRight],
  ["/dashboard/carteiras", "Carteiras", Wallet],
  ["/dashboard/webhooks", "Webhooks", Webhook],
  ["/dashboard/documentacao", "Documentação", BookOpen],
  ["/dashboard/configuracoes", "Configurações", Settings],
] as const;

export function Sidebar() {
  return (
    <aside className="fixed inset-y-0 left-0 z-40 hidden w-64 border-r border-slate-800 bg-[#07142f] lg:block">
      <div className="flex h-16 items-center border-b border-white/10 px-5">
        <Link href="/" className="flex items-center gap-2 text-white"><span className="text-xl font-bold">ViaPay</span></Link>
      </div>
      <nav className="space-y-1 p-4">
        {navigation.map(([href, label, Icon]) => (
          <Link key={href} href={href} className="flex items-center gap-3 rounded-xl px-3 py-3 text-sm font-medium text-slate-300 hover:bg-white/10 hover:text-white">
            <Icon size={18} /> {label}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
