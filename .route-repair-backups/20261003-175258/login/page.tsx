import Link from "next/link";
import { Logo } from "@/components/Logo";
import { LoginForm } from "@/components/forms/LoginForm";

export default function LoginPage() {
  return (
    <main className="grid min-h-screen lg:grid-cols-2">
      <section className="flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-md">
          <Logo />
          <h1 className="mt-10 text-3xl font-bold">Bem-vindo de volta</h1>
          <p className="mt-2 text-sm text-slate-500">Acesse sua conta na ViaPay.</p>
          <LoginForm />
          <p className="mt-6 text-center text-sm text-slate-500">
            Não tem uma conta? <Link href="/cadastro" className="font-semibold text-blue-600">Criar conta</Link>
          </p>
        </div>
      </section>
      <section className="hidden overflow-hidden bg-gradient-to-br from-blue-700 via-indigo-700 to-cyan-600 p-12 text-white lg:flex lg:flex-col lg:justify-end">
        <p className="text-5xl font-bold leading-tight">Uma nova forma de conectar o Brasil ao mundo.</p>
        <p className="mt-5 max-w-xl text-lg text-blue-50">Receba pagamentos em Pix e liquide em USDC na Solana.</p>
      </section>
    </main>
  );
}
