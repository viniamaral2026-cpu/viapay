import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <Logo />

        <nav className="hidden items-center gap-7 md:flex">
          <Link href="/como-funciona">Como funciona</Link>
          <Link href="/precos">Preços</Link>
          <Link href="/empresa">Empresa</Link>
          <Link href="/contato">Contato</Link>
        </nav>

        <div className="flex items-center gap-3">
          <Link
            href="/login"
            className="text-sm font-medium text-slate-700"
          >
            Entrar
          </Link>

          <Link
            href="/cadastro"
            className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-blue-700"
          >
            Criar conta
          </Link>
        </div>
      </div>
    </header>
  );
}
