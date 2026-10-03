import Link from "next/link";
import { CheckCircle2, ExternalLink } from "lucide-react";
import { Logo } from "@/components/Logo";

export default function CheckoutSuccessPage() {
  return (
    <main className="min-h-screen bg-slate-50 px-6 py-10">
      <div className="mx-auto max-w-2xl"><Logo />
        <div className="mt-16 text-center">
          <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-emerald-50 text-emerald-600"><CheckCircle2 size={48} /></div>
          <h1 className="mt-6 text-4xl font-bold">Pagamento confirmado!</h1>
          <p className="mt-2 text-slate-500">Seu pagamento foi processado com sucesso.</p>
        </div>
        <div className="mt-10 rounded-3xl border border-slate-200 bg-white p-7 shadow-sm">
          <div className="flex justify-between py-4 text-sm"><span className="text-slate-500">Valor pago</span><strong>R$ 100,00</strong></div>
          <div className="flex justify-between py-4 text-sm"><span className="text-slate-500">USDC recebido</span><strong>18,42 USDC</strong></div>
          <div className="flex justify-between gap-5 py-4 text-sm"><span className="text-slate-500">Transação na Solana</span><span className="font-mono font-semibold">5xK8...9zP2</span></div>
        </div>
        <a href="https://explorer.solana.com/" target="_blank" rel="noreferrer" className="mt-6 flex items-center justify-center gap-2 rounded-xl bg-blue-600 py-3 font-semibold text-white hover:bg-blue-700">Ver no Solana Explorer <ExternalLink size={17} /></a>
        <Link href="/" className="mt-5 block text-center text-sm text-slate-500">Obrigado por usar a ViaPay!</Link>
      </div>
    </main>
  );
}
