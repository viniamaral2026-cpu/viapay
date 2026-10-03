import Link from "next/link";
import { CheckCircle2 } from "lucide-react";
import { Card } from "@/components/Card/Card";

export default function CheckoutSuccessPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6">
      <Card className="w-full max-w-md p-8 text-center">
        <CheckCircle2 className="mx-auto text-emerald-500" size={64} />

        <h1 className="mt-6 text-2xl font-bold">
          Pagamento confirmado
        </h1>

        <p className="mt-2 text-sm text-slate-500">
          O pagamento foi processado com sucesso.
        </p>

        <Link
          href="/"
          className="mt-7 block rounded-lg bg-blue-600 py-3 font-semibold text-white"
        >
          Voltar para ViaPay
        </Link>
      </Card>
    </main>
  );
}
