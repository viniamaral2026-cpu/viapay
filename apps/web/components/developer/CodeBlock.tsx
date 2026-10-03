"use client";

import { Copy } from "lucide-react";
import { useState } from "react";

const code = `npm install @viapay/sdk

import { ViaPay } from "@viapay/sdk";

const viapay = new ViaPay({
  apiKey: "vp_test_xxx"
});

const payment = await viapay.payments.create({
  amountBRL: 100,
  merchantWallet: "SOLANA_WALLET"
});`;

export function CodeBlock() {
  const [copied, setCopied] = useState(false);

  async function copy() {
    await navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 1200);
  }

  return (
    <div className="mt-8 overflow-hidden rounded-2xl bg-slate-950 shadow-xl">
      <div className="flex items-center justify-between border-b border-white/10 px-4 py-3 text-xs text-slate-400">
        <span>npm</span><button onClick={copy} className="inline-flex items-center gap-2">{copied ? "Copiado" : "Copiar"} <Copy size={15} /></button>
      </div>
      <pre className="overflow-x-auto p-6 text-sm leading-7 text-slate-200"><code>{code}</code></pre>
    </div>
  );
}
