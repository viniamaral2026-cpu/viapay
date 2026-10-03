import { Globe2, ShieldCheck, Zap } from "lucide-react";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

export default function EmpresaPage() {
  return (
    <>
      <Navbar />
      <main>
        <section className="bg-gradient-to-br from-blue-700 to-cyan-600 px-6 py-28 text-white">
          <div className="mx-auto max-w-5xl">
            <span className="text-sm font-semibold text-cyan-100">VIAPAY</span>
            <h1 className="mt-6 text-5xl font-bold">Uma nova forma de conectar o Brasil ao mundo.</h1>
            <p className="mt-6 max-w-2xl text-lg leading-8 text-blue-50">
              Infraestrutura de pagamentos orientada a APIs, Pix, conversão e liquidação em blockchain.
            </p>
          </div>
        </section>
        <section className="mx-auto grid max-w-6xl gap-6 px-6 py-20 md:grid-cols-3">
          <div><Zap className="text-blue-600" /><h2 className="mt-4 font-bold">Velocidade</h2><p className="mt-2 text-sm text-slate-500">Fluxos orientados a eventos e processamento assíncrono.</p></div>
          <div><ShieldCheck className="text-blue-600" /><h2 className="mt-4 font-bold">Segurança</h2><p className="mt-2 text-sm text-slate-500">Contratos explícitos, idempotência e rastreabilidade.</p></div>
          <div><Globe2 className="text-blue-600" /><h2 className="mt-4 font-bold">Global</h2><p className="mt-2 text-sm text-slate-500">Liquidação em USDC através da rede Solana.</p></div>
        </section>
      </main>
      <Footer />
    </>
  );
}
