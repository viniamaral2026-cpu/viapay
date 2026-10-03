"use client";

import { useState } from "react";
import { Eye, EyeOff } from "lucide-react";
import { Button } from "@/components/Button";
import { Input } from "@/components/Input";

export function LoginForm() {
  const [show, setShow] = useState(false);

  return (
    <form className="mt-8 space-y-4" onSubmit={(e) => e.preventDefault()}>
      <Input type="email" placeholder="seu@email.com" required />
      <div className="relative">
        <Input className="pr-11" type={show ? "text" : "password"} placeholder="Digite sua senha" required />
        <button type="button" onClick={() => setShow(!show)} className="absolute right-3 top-3 text-slate-400">
          {show ? <EyeOff size={18} /> : <Eye size={18} />}
        </button>
      </div>
      <div className="flex items-center justify-between text-sm">
        <label className="flex items-center gap-2"><input type="checkbox" /> Lembrar de mim</label>
        <button type="button" className="font-semibold text-blue-600">Esqueceu a senha?</button>
      </div>
      <Button type="submit" className="w-full">Entrar</Button>
      <div className="flex items-center gap-3 py-2 text-xs text-slate-400"><span className="h-px flex-1 bg-slate-200" />ou continue com<span className="h-px flex-1 bg-slate-200" /></div>
      <div className="grid grid-cols-2 gap-3">
        <button type="button" className="rounded-xl border border-slate-200 py-3 text-sm font-semibold">Google</button>
        <button type="button" className="rounded-xl border border-slate-200 py-3 text-sm font-semibold">GitHub</button>
      </div>
    </form>
  );
}
