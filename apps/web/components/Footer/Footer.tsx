import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Footer() {
  return (
    <footer className="border-t border-slate-200 bg-white">
      <div className="mx-auto grid max-w-7xl gap-10 px-6 py-14 md:grid-cols-4">
        <div>
          <Logo />
          <p className="mt-4 max-w-xs text-sm leading-6 text-slate-500">
            Infraestrutura de pagamentos para conectar Pix brasileiro a liquidação em USDC na Solana.
          </p>
        </div>
        <div>
          <h3 className="font-semibold">Produto</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/como-funciona">Como funciona</Link>
            <Link className="block" href="/precos">Preços</Link>
          </div>
        </div>
        <div>
          <h3 className="font-semibold">Desenvolvedores</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/desenvolvedores">Documentação</Link>
            <Link className="block" href="/dashboard/webhooks">Webhooks</Link>
          </div>
        </div>
        <div>
          <h3 className="font-semibold">Empresa</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/empresa">Sobre</Link>
            <Link className="block" href="/contato">Contato</Link>
          </div>
        </div>
      </div>
      <div className="border-t border-slate-100 px-6 py-5 text-center text-xs text-slate-400">
        © 2026 ViaPay. Todos os direitos reservados.
      </div>
    </footer>
  );
}
