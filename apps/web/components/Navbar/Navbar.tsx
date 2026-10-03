import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <Logo />
        <nav className="hidden items-center gap-7 text-sm font-medium text-slate-600 md:flex">
          <Link href="/como-funciona" className="hover:text-slate-950">Como funciona</Link>
          <Link href="/precos" className="hover:text-slate-950">Preços</Link>
          <Link href="/desenvolvedores" className="hover:text-slate-950">Desenvolvedores</Link>
          <Link href="/empresa" className="hover:text-slate-950">Empresa</Link>
        </nav>
        <div className="flex items-center gap-3">
          <Link href="/login" className="hidden text-sm font-semibold text-slate-700 sm:block">Entrar</Link>
          <Link href="/cadastro" className="rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-blue-700">
            Criar conta
          </Link>
        </div>
      </div>
    </header>
  );
}
