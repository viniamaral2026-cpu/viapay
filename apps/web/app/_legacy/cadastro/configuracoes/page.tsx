import Link from "next/link";
import { Card } from "@/components/Card";
import { Input } from "@/components/Input";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";

export default function ConfiguracoesOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={4} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Configurações</h1>
            <p className="mt-2 text-sm text-slate-500">Defina as preferências iniciais da sua conta.</p>
            <div className="mt-8 space-y-5">
              <Input placeholder="URL de webhook" />
              <Input placeholder="E-mail para notificações" type="email" />
              <label className="flex items-center gap-3 text-sm"><input type="checkbox" defaultChecked /> Ativar notificações de pagamento</label>
            </div>
            <Link href="/dashboard" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Concluir cadastro →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
