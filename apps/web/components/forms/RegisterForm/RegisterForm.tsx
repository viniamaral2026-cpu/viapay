"use client";

import { Button } from "@/components/Button";
import { Input } from "@/components/Input";

export function RegisterForm() {
  return (
    <form className="mt-8 space-y-4" onSubmit={(e) => e.preventDefault()}>
      <Input placeholder="Nome completo" required />
      <Input placeholder="E-mail profissional" type="email" required />
      <Input placeholder="Senha" type="password" required />
      <label className="flex items-start gap-2 text-xs text-slate-500">
        <input type="checkbox" required className="mt-0.5" />
        Aceito os termos de uso e a política de privacidade.
      </label>
      <Button type="submit" className="w-full">Criar conta</Button>
    </form>
  );
}
