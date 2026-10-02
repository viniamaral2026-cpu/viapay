import { Navbar } from "@/components/Navbar/Navbar;
import { Footer } from "@/components/Footer/Footer;
import { Input } from "@/components/Input/Input;
import { Button } from "@/components/Button/Button;
import { Card } from "@/components/Card/Card;

export default function ContatoPage() {
  return (
    <>
      <Navbar />

      <main className="bg-slate-50 px-6 py-24">
        <Card className="mx-auto max-w-xl p-8">
          <h1 className="text-3xl font-bold">Entre em contato</h1>

          <div className="mt-8 space-y-4">
            <Input placeholder="Nome" />
            <Input placeholder="E-mail" />
            <Input placeholder="Empresa" />
            <textarea
              className="min-h-32 w-full rounded-lg border border-slate-200 p-3"
              placeholder="Mensagem"
            />
            <Button className="w-full">
              Enviar mensagem
            </Button>
          </div>
        </Card>
      </main>

      <Footer />
    </>
  );
}
