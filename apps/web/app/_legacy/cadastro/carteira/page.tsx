import Link from "next/link";
import { Card } from "@/components/Card";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";
import { WalletConnect } from "@/components/merchant/WalletConnect";

export default function CarteiraOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={3} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Conecte sua carteira Solana</h1>
            <p className="mt-2 text-sm text-slate-500">É aqui que você receberá os pagamentos em USDC.</p>
            <div className="mt-8"><WalletConnect /></div>
            <Link href="/cadastro/configuracoes" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Continuar →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
