import { Card } from "@/components/Card";
import { Button } from "@/components/Button";
import { Footer } from "@/components/Footer";
import { Input } from "@/components/Input";
import { Navbar } from "@/components/Navbar";

export default function ContatoPage() {
  return (
    <>
      <Navbar />
      <main className="bg-slate-50 px-6 py-24">
        <Card className="mx-auto max-w-xl p-8">
          <h1 className="text-3xl font-bold">Entre em contato</h1>
          <p className="mt-2 text-sm text-slate-500">Fale com a equipe ViaPay.</p>
          <form className="mt-8 space-y-4">
            <Input placeholder="Nome" required />
            <Input placeholder="E-mail" type="email" required />
            <Input placeholder="Empresa" />
            <textarea className="min-h-32 w-full rounded-xl border border-slate-200 p-4 outline-none focus:border-blue-500" placeholder="Mensagem" />
            <Button className="w-full" type="submit">Enviar mensagem</Button>
          </form>
        </Card>
      </main>
      <Footer />
    </>
  );
}
