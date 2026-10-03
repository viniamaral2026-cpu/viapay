import { ArrowRight, CheckCircle2, QrCode, Wallet, Zap } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

const steps = [
  ["1", "Gere a cobrança Pix", "Após a compra, um QR Pix é criado automaticamente.", QrCode],
  ["2", "Usuário paga", "O cliente paga com Pix normalmente.", CheckCircle2],
  ["3", "Conversão automática", "O valor é convertido de BRL para USDC.", Zap],
  ["4", "Liquidação na Solana", "O lojista recebe USDC na sua carteira Solana.", Wallet],
] as const;

export default function ComoFuncionaPage() {
  return (
    <>
      <Navbar />
      <main>
        <section className="bg-blue-50 px-6 py-24 text-center">
          <h1 className="text-5xl font-bold tracking-tight">Como funciona</h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg text-slate-600">
            Simples para o usuário. Poderoso para o desenvolvedor.
          </p>
        </section>
        <section className="mx-auto max-w-7xl px-6 py-20">
          <div className="grid gap-5 md:grid-cols-4">
            {steps.map(([number, title, description, Icon]) => (
              <Card key={number} className="relative p-6">
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><Icon /></div>
                <span className="mt-6 block text-xs font-bold text-blue-600">ETAPA {number}</span>
                <h2 className="mt-2 font-bold">{title}</h2>
                <p className="mt-2 text-sm leading-6 text-slate-500">{description}</p>
                {number !== "4" && <ArrowRight className="absolute -right-4 top-20 hidden text-slate-300 md:block" />}
              </Card>
            ))}
          </div>
        </section>
      </main>
      <Footer />
    </>
  );
}
