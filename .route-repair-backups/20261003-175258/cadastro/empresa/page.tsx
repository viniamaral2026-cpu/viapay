import Link from "next/link";
import { Button } from "@/components/Button";
import { Card } from "@/components/Card";
import { Input } from "@/components/Input";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";

export default function EmpresaOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={2} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Dados da empresa</h1>
            <p className="mt-2 text-sm text-slate-500">Vamos configurar sua conta para começar a receber pagamentos.</p>
            <div className="mt-8 grid gap-5 md:grid-cols-2">
              <Input placeholder="Sua empresa LTDA" />
              <Input placeholder="00.000.000/0000-00" />
              <Input placeholder="contato@suaempresa.com" type="email" />
              <Input placeholder="https://www.suaempresa.com" />
            </div>
            <Link href="/cadastro/carteira" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Continuar →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
