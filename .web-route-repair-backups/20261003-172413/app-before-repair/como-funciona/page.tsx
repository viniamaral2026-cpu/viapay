import { Navbar } from "@/components/Navbar/Navbar";
import { Footer } from "@/components/Footer/Footer";
import { Card } from "@/components/Card/Card";

const steps = [
  ["01", "Crie a cobrança", "Sua aplicação cria o pagamento através da API."],
  ["02", "Cliente paga", "O cliente paga normalmente utilizando Pix."],
  ["03", "Processamento", "A ViaPay processa a operação."],
  ["04", "Liquidação", "O valor é liquidado em USDC na Solana."],
];

export default function ComoFuncionaPage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="bg-blue-50 px-6 py-24 text-center">
          <h1 className="text-5xl font-bold">Como funciona</h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg text-slate-600">
            Uma infraestrutura simples na experiência e robusta por baixo.
          </p>
        </section>

        <section className="mx-auto grid max-w-6xl gap-5 px-6 py-20 md:grid-cols-4">
          {steps.map(([number, title, description]) => (
            <Card key={number} className="p-6">
              <span className="text-sm font-bold text-blue-600">{number}</span>
              <h2 className="mt-6 font-bold">{title}</h2>
              <p className="mt-2 text-sm leading-6 text-slate-500">
                {description}
              </p>
            </Card>
          ))}
        </section>
      </main>

      <Footer />
    </>
  );
}
