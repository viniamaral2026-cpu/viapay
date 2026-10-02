import { Navbar } from "@/components/Navbar/Navbar";
import { Footer } from "@/components/Footer/Footer";
import { Card } from "@/components/Card/Card";

export default function PrecosPage() {
  const plans = [
    ["Developer", "R$ 0"],
    ["Pro", "R$ 99"],
    ["Enterprise", "Sob consulta"],
  ];

  return (
    <>
      <Navbar />

      <main className="bg-slate-50 px-6 py-24">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-center text-5xl font-bold">
            Preços transparentes
          </h1>

          <div className="mt-14 grid gap-6 md:grid-cols-3">
            {plans.map(([name, price]) => (
              <Card key={name} className="p-8">
                <h2 className="text-xl font-bold">{name}</h2>
                <p className="mt-6 text-4xl font-bold">{price}</p>

                <button className="mt-8 w-full rounded-lg bg-blue-600 py-3 font-semibold text-white">
                  Começar
                </button>
              </Card>
            ))}
          </div>
        </div>
      </main>

      <Footer />
    </>
  );
}
