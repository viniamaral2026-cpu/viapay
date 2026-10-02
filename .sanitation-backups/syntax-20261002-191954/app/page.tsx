import Link from "next/link";
import {
  ArrowRight,
  Globe2,
  QrCode,
  ShieldCheck,
} from "lucide-react";
import { Card } from "@/components/Card/Card;
import { Footer } from "@/components/Footer/Footer;
import { Navbar } from "@/components/Navbar/Navbar;

export default function HomePage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="overflow-hidden bg-gradient-to-br from-white via-blue-50 to-cyan-50">
          <div className="mx-auto grid max-w-7xl gap-16 px-6 py-24 lg:grid-cols-2 lg:items-center">
            <div>
              <span className="inline-flex rounded-full border border-blue-100 bg-white px-3 py-1 text-xs font-semibold text-blue-700">
                Payment Settlement Infrastructure
              </span>

              <h1 className="mt-7 max-w-3xl text-5xl font-bold tracking-tight text-slate-950 md:text-6xl">
                Pagamentos brasileiros conectados ao mundo.
              </h1>

              <p className="mt-6 max-w-xl text-lg leading-8 text-slate-600">
                Receba Pix, processe pagamentos e liquide
                operações através de uma infraestrutura
                construída para aplicações modernas.
              </p>

              <div className="mt-8 flex flex-wrap gap-3">
                <Link
                  href="/cadastro"
                  className="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white transition hover:bg-blue-700"
                >
                  Começar agora
                  <ArrowRight size={17} />
                </Link>

                <Link
                  href="/como-funciona"
                  className="rounded-lg border border-slate-200 bg-white px-5 py-3 font-semibold text-slate-900"
                >
                  Como funciona
                </Link>
              </div>

              <div className="mt-10 grid max-w-xl grid-cols-3 gap-5">
                <div>
                  <QrCode className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Pix
                  </p>
                </div>

                <div>
                  <Globe2 className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Global
                  </p>
                </div>

                <div>
                  <ShieldCheck className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Seguro
                  </p>
                </div>
              </div>
            </div>

            <Card className="p-7 shadow-2xl">
              <p className="text-sm font-semibold text-slate-500">
                ViaPay Checkout
              </p>

              <div className="mt-7 rounded-2xl bg-slate-50 p-8 text-center">
                <QrCode
                  className="mx-auto"
                  size={170}
                  strokeWidth={1.3}
                />

                <p className="mt-5 text-2xl font-bold">
                  R$ 100,00
                </p>

                <p className="mt-1 text-sm text-slate-500">
                  Pague com Pix
                </p>
              </div>

              <div className="mt-5 rounded-xl bg-blue-50 p-4">
                <p className="text-xs text-slate-500">
                  Liquidação
                </p>

                <p className="font-semibold">
                  USDC
                </p>
              </div>
            </Card>
          </div>
        </section>
      </main>

      <Footer />
    </>
  );
}
