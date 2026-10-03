import Link from "next/link";
import { Check } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

const plans = [
  { name: "Gratuito", price: "R$ 0", items: ["Ambiente de testes (devnet)", "Volume limitado", "Suporte por comunidade"] },
  { name: "Pro", price: "R$ 99", featured: true, items: ["Volume maior", "Suporte prioritário", "Webhooks personalizados", "Relatórios avançados"] },
  { name: "Enterprise", price: "Sob consulta", items: ["Volumes altos", "Suporte dedicado", "Soluções personalizadas", "SLA"] },
];

export default function PrecosPage() {
  return (
    <>
      <Navbar />
      <main className="bg-slate-50 px-6 py-24">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-center text-5xl font-bold">Preços simples e transparentes</h1>
          <p className="mx-auto mt-5 max-w-2xl text-center text-slate-600">Comece gratuitamente e escale conforme seu volume.</p>
          <div className="mt-14 grid gap-6 md:grid-cols-3">
            {plans.map((plan) => (
              <Card key={plan.name} className={plan.featured ? "border-blue-500 p-8 ring-2 ring-blue-100" : "p-8"}>
                {plan.featured && <span className="rounded-full bg-blue-600 px-3 py-1 text-xs font-bold text-white">Mais popular</span>}
                <h2 className="mt-4 text-xl font-bold">{plan.name}</h2>
                <p className="mt-6 text-4xl font-bold">{plan.price}<span className="text-sm font-medium text-slate-400">/mês</span></p>
                <ul className="mt-8 space-y-4 text-sm text-slate-600">
                  {plan.items.map((item) => <li key={item} className="flex gap-2"><Check className="text-blue-600" size={18} />{item}</li>)}
                </ul>
                <Link href="/cadastro" className="mt-8 block rounded-xl bg-blue-600 py-3 text-center font-semibold text-white hover:bg-blue-700">
                  {plan.name === "Enterprise" ? "Falar com vendas" : "Começar agora"}
                </Link>
              </Card>
            ))}
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
