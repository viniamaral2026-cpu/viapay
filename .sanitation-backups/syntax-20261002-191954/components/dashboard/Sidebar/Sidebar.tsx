import Link from "next/link";
import {
  ArrowLeftRight,
  BookOpen,
  CreditCard,
  LayoutDashboard,
  Settings,
  Wallet,
  Webhook,
} from "lucide-react";
import { Logo } from "@/components/Logo/Logo;

const navigation = [
  {
    href: "/dashboard",
    label: "Visão Geral",
    Icon: LayoutDashboard,
  },
  {
    href: "/dashboard/pagamentos",
    label: "Pagamentos",
    Icon: CreditCard,
  },
  {
    href: "/dashboard/liquidacoes",
    label: "Liquidações",
    Icon: ArrowLeftRight,
  },
  {
    href: "/dashboard/carteiras",
    label: "Carteiras",
    Icon: Wallet,
  },
  {
    href: "/dashboard/webhooks",
    label: "Webhooks",
    Icon: Webhook,
  },
  {
    href: "/dashboard/documentacao",
    label: "Documentação",
    Icon: BookOpen,
  },
  {
    href: "/dashboard/configuracoes",
    label: "Configurações",
    Icon: Settings,
  },
];

export function Sidebar() {
  return (
    <aside className="fixed inset-y-0 left-0 hidden w-64 border-r border-slate-800 bg-[#07142f] lg:block">
      <div className="flex h-16 items-center border-b border-white/10 px-5">
        <Logo />
      </div>

      <nav className="space-y-1 p-4">
        {navigation.map(({ href, label, Icon }) => (
          <Link
            key={href}
            href={href}
            className="flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white"
          >
            <Icon size={18} />
            {label}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
