import Link from "next/link";
import { Logo } from "@/components/Logo/Logo";

export function Footer() {
  return (
    <footer className="border-t border-slate-200 bg-white">
      <div className="mx-auto grid max-w-7xl gap-10 px-6 py-14 md:grid-cols-4">
        <div>
          <Logo />

          <p className="mt-4 max-w-xs text-sm leading-6 text-slate-500">
            Infraestrutura de pagamentos para conectar aplicações
            brasileiras ao sistema financeiro global.
          </p>
        </div>

        <div>
          <h3 className="font-semibold">Produto</h3>

          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link href="/como-funciona" className="block">
              Como funciona
            </Link>

            <Link href="/precos" className="block">
              Preços
            </Link>
          </div>
        </div>

        <div>
          <h3 className="font-semibold">Desenvolvedores</h3>

          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link
              href="/dashboard/documentacao"
              className="block"
            >
              Documentação
            </Link>

            <Link
              href="/dashboard/webhooks"
              className="block"
            >
              Webhooks
            </Link>
          </div>
        </div>

        <div>
          <h3 className="font-semibold">Empresa</h3>

          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link href="/empresa" className="block">
              Sobre
            </Link>

            <Link href="/contato" className="block">
              Contato
            </Link>
          </div>
        </div>
      </div>

      <div className="border-t border-slate-100 px-6 py-5 text-center text-xs text-slate-400">
        © 2026 ViaPay. Todos os direitos reservados.
      </div>
    </footer>
  );
}
