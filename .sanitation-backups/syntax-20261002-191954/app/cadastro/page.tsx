import Link from "next/link";
import { Logo } from "@/components/Logo/Logo;
import { RegisterForm } from "@/components/forms/RegisterForm/RegisterForm;

export default function CadastroPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6 py-12">
      <div className="w-full max-w-lg rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
        <Logo />

        <h1 className="mt-10 text-3xl font-bold">
          Criar conta
        </h1>

        <p className="mt-2 text-sm text-slate-500">
          Comece sua integração com a ViaPay.
        </p>

        <RegisterForm />

        <p className="mt-6 text-center text-sm text-slate-500">
          Já possui conta?{" "}
          <Link
            href="/login"
            className="font-semibold text-blue-600"
          >
            Entrar
          </Link>
        </p>
      </div>
    </main>
  );
}
