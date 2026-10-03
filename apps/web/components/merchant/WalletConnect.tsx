"use client";

import { useState } from "react";
import { Button } from "@/components/Button";
import { Input } from "@/components/Input";

export function WalletConnect() {
  const [address, setAddress] = useState("");
  const [message, setMessage] = useState("");

  function validate() {
    setMessage(address.trim().length >= 32 ? "Endereço informado para validação." : "Informe um endereço Solana válido.");
  }

  return (
    <div className="space-y-4">
      {[
        ["Phantom", "Conectar carteira Phantom"],
        ["Solflare", "Conectar carteira Solflare"],
        ["Ledger", "Conectar via Ledger"],
      ].map(([name, description]) => (
        <div key={name} className="flex items-center justify-between rounded-2xl border border-slate-200 p-4">
          <div><p className="font-semibold">{name}</p><p className="text-sm text-slate-500">{description}</p></div>
          <Button type="button" className="px-4 py-2">Conectar</Button>
        </div>
      ))}
      <div className="rounded-2xl border border-dashed border-slate-300 p-5">
        <p className="font-semibold">Inserir endereço manualmente</p>
        <div className="mt-3 flex gap-2"><Input value={address} onChange={(e) => setAddress(e.target.value)} placeholder="Cole seu endereço da carteira Solana" /><Button type="button" onClick={validate}>Validar</Button></div>
        {message && <p className="mt-2 text-sm text-slate-500">{message}</p>}
      </div>
    </div>
  );
}
