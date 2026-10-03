"use client";

import { useState } from "react";
import { Check, Copy, LoaderCircle } from "lucide-react";
import { Logo } from "@/components/Logo";
import { QRCode } from "@/components/checkout/QRCode";

export default function CheckoutPage() {
  const [copied, setCopied] = useState(false);
  const pix = "00020126580014br.gov.bcb.pix0136viapay-payment-01J25a7f3";

  async function copyPix() {
    await navigator.clipboard.writeText(pix);
    setCopied(true);
    setTimeout(() => setCopied(false), 1200);
  }

  return (
    <main className="min-h-screen bg-slate-50 px-6 py-10">
      <div className="mx-auto max-w-5xl">
        <Logo />
        <div className="mt-10 text-center"><h1 className="text-4xl font-bold">Pague com Pix</h1><p className="mt-2 text-slate-500">Escaneie o QR Code com seu app bancário.</p></div>
        <div className="mt-10 grid gap-8 rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:grid-cols-2 md:p-10">
          <div className="flex justify-center"><QRCode /></div>
          <div className="flex flex-col justify-center">
            <div className="rounded-2xl bg-slate-50 p-5"><p className="text-sm text-slate-500">Valor</p><p className="mt-1 text-3xl font-bold">R$ 100,00</p><p className="mt-5 text-sm text-slate-500">Expira em</p><p className="mt-1 font-semibold">14:58</p></div>
            <div className="mt-5"><p className="text-sm font-semibold">Ou copie o código Pix:</p><div className="mt-2 flex gap-2"><input readOnly value={pix} className="min-w-0 flex-1 rounded-xl border border-slate-200 px-3 py-3 text-xs text-slate-500" /><button onClick={copyPix} className="rounded-xl border px-4">{copied ? <Check size={17} /> : <Copy size={17} />}</button></div></div>
            <div className="mt-6 flex items-center justify-center gap-2 rounded-xl bg-blue-50 px-4 py-3 text-sm font-semibold text-blue-700"><LoaderCircle className="animate-spin" size={17} />Aguardando pagamento...</div>
          </div>
        </div>
      </div>
    </main>
  );
}
