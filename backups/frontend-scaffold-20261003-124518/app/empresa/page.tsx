import { Navbar } from "@/components/Navbar/Navbar";
import { Footer } from "@/components/Footer/Footer";

export default function EmpresaPage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="bg-[#07142f] px-6 py-24 text-white">
          <div className="mx-auto max-w-5xl">
            <span className="text-sm font-semibold text-cyan-400">
              VIAPAY
            </span>

            <h1 className="mt-6 text-5xl font-bold">
              Infraestrutura financeira programável.
            </h1>

            <p className="mt-6 max-w-2xl text-lg leading-8 text-slate-300">
              Construímos infraestrutura para conectar pagamentos locais,
              aplicações modernas e liquidação global.
            </p>
          </div>
        </section>
      </main>

      <Footer />
    </>
  );
}
