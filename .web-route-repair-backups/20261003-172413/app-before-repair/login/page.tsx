import Link from "next/link";
import { Logo } from "@/components/Logo/Logo";
import { LoginForm } from "@/components/forms/LoginForm/LoginForm";

export default function LoginPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6">
      <div className="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
        <Logo />

        <h1 className="mt-10 text-3xl font-bold">
          Entrar
        </h1>

        <p className="mt-2 text-sm text-slate-500">
          Acesse seu painel ViaPay.
        </p>

        <LoginForm />

        <p className="mt-6 text-center text-sm text-slate-500">
          Ainda não possui conta?{" "}
          <Link
            href="/cadastro"
            className="font-semibold text-blue-600"
          >
            Criar conta
          </Link>
        </p>
      </div>
    </main>
  );
}
