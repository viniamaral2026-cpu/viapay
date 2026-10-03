#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
WEB="$ROOT/apps/web"

echo "=============================================="
echo " VIAPAY — BUILD COMPLETO DO FRONTEND"
echo " Mockups 01–12 + correção TypeScript"
echo "=============================================="

if [ ! -d "$ROOT" ]; then
  echo "ERRO: projeto não encontrado em $ROOT"
  exit 1
fi

if [ ! -d "$WEB" ]; then
  echo "ERRO: frontend não encontrado em $WEB"
  exit 1
fi

cd "$ROOT"

PM="pnpm"
if ! command -v pnpm >/dev/null 2>&1; then
  if command -v npm >/dev/null 2>&1; then PM="npm"; else
    echo "ERRO: pnpm ou npm não encontrado."
    exit 1
  fi
fi

echo "Package manager: $PM"

# ------------------------------------------------------------
# 1. Dependências
# ------------------------------------------------------------
if [ "$PM" = "pnpm" ]; then
  pnpm install
  pnpm --dir apps/web add lucide-react clsx tailwind-merge
else
  npm install
  npm --prefix apps/web install lucide-react clsx tailwind-merge
fi

# ------------------------------------------------------------
# 2. Estrutura
# ------------------------------------------------------------
cd "$WEB"

rm -rf .next

mkdir -p \
  app/login \
  app/cadastro \
  app/como-funciona \
  app/precos \
  app/empresa \
  app/contato \
  app/desenvolvedores \
  app/dashboard \
  app/dashboard/pagamentos \
  'app/dashboard/pagamentos/[id]' \
  app/dashboard/liquidacoes \
  app/dashboard/carteiras \
  app/dashboard/webhooks \
  app/dashboard/documentacao \
  app/dashboard/configuracoes \
  'app/checkout/[paymentId]' \
  'app/checkout/[paymentId]/success' \
  components/BrandMark \
  components/Logo \
  components/Navbar \
  components/Footer \
  components/Button \
  components/Input \
  components/Card \
  components/Badge \
  components/dashboard/Sidebar \
  components/dashboard/DashboardShell \
  components/dashboard/StatCard \
  components/dashboard/PaymentTable \
  components/checkout/QRCode \
  components/checkout/PaymentSummary \
  components/forms/LoginForm \
  components/forms/RegisterForm \
  components/merchant/OnboardingStepper \
  components/merchant/WalletConnect \
  components/developer/CodeBlock \
  components/developer/DocsSidebar \
  lib \
  services \
  types \
  constants

# ------------------------------------------------------------
# 3. TypeScript — remove baseUrl deprecated
# ------------------------------------------------------------
node <<'NODE'
const fs = require("fs");

for (const file of ["tsconfig.json", "apps/bank-core/tsconfig.json"]) {
  if (!fs.existsSync(file)) continue;

  let config;
  try {
    config = JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    console.error(`ERRO: JSON inválido em ${file}`);
    process.exit(1);
  }

  config.compilerOptions ??= {};
  delete config.compilerOptions.baseUrl;

  if (file === "tsconfig.json") {
    config.compilerOptions.paths = {
      ...(config.compilerOptions.paths || {}),
      "@/*": ["./*"]
    };
    config.compilerOptions.strict ??= true;
    config.compilerOptions.noEmit = true;
    config.compilerOptions.esModuleInterop = true;
    config.compilerOptions.skipLibCheck = true;
    config.compilerOptions.moduleResolution = "Bundler";
    config.include = [
      "next-env.d.ts",
      "**/*.ts",
      "**/*.tsx",
      ".next/types/**/*.ts"
    ];
    config.exclude = ["node_modules"];
  }

  fs.writeFileSync(file, JSON.stringify(config, null, 2) + "\n");
  console.log(`OK tsconfig: ${file}`);
}
NODE

# ------------------------------------------------------------
# 4. Tipos e utilitários
# ------------------------------------------------------------
cat > lib/utils.ts <<'EOF'
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
EOF

cat > types/payment.ts <<'EOF'
export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";

export interface Payment {
  id: string;
  amountBRL: number;
  merchantWallet: string;
  status: PaymentStatus;
  pixChargeId?: string;
  qrCode?: string;
  qrCodeImage?: string;
  amountUSDC?: number;
  exchangeRate?: string;
  customerName?: string;
  reference?: string;
  expiresAt?: string;
  solanaSignature?: string;
  createdAt: string;
  updatedAt: string;
}
EOF

cat > types/dashboard.ts <<'EOF'
export interface DashboardMetric {
  title: string;
  value: string;
  change: string;
  positive?: boolean;
}
EOF

cat > services/api.ts <<'EOF'
import type { Payment } from "@/types/payment";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL?.replace(/\/$/, "") ||
  "http://localhost:3001";

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${API_URL}${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...(init?.headers || {}),
    },
    cache: "no-store",
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(body || `API error ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export async function getPayment(id: string): Promise<Payment> {
  return request<Payment>(`/payments/${encodeURIComponent(id)}`);
}

export async function createPayment(input: {
  amountBRL: number;
  merchantWallet: string;
}) {
  return request<{
    paymentId: string;
    status: string;
    pixChargeId: string;
    qrCode: string;
    qrCodeImage?: string;
    expiresAt: string;
  }>("/payments", {
    method: "POST",
    body: JSON.stringify(input),
  });
}
EOF

# ------------------------------------------------------------
# 5. CSS global — light mode obrigatório
# ------------------------------------------------------------
cat > app/globals.css <<'EOF'
@import "tailwindcss";

:root {
  --vp-blue: #0b5fff;
  --vp-primary: #2563eb;
  --vp-light: #60a5fa;
  --vp-cyan: #06b6d4;
  --vp-navy: #07142f;
  --vp-text: #0f172a;
  --vp-muted: #64748b;
  --vp-border: #e2e8f0;
}

* { box-sizing: border-box; }

html { scroll-behavior: smooth; }

body {
  margin: 0;
  min-height: 100vh;
  background: #fff;
  color: var(--vp-text);
  font-family: Arial, Helvetica, sans-serif;
}

button, input, textarea, select { font: inherit; }

a { text-decoration: none; color: inherit; }

::selection {
  background: #bfdbfe;
  color: #0f172a;
}
EOF

# ------------------------------------------------------------
# 6. Layout
# ------------------------------------------------------------
cat > app/layout.tsx <<'EOF'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: {
    default: "ViaPay — Payment Settlement Infrastructure",
    template: "%s | ViaPay",
  },
  description:
    "Infraestrutura de pagamentos que conecta Pix a liquidação em USDC na Solana.",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
EOF

# ------------------------------------------------------------
# 7. Componentes base
# ------------------------------------------------------------
cat > components/BrandMark/BrandMark.tsx <<'EOF'
export function BrandMark() {
  return (
    <span
      aria-label="ViaPay"
      className="relative inline-block h-9 w-9 shrink-0"
    >
      <span className="absolute left-1 top-2 h-6 w-3 -skew-x-[18deg] rounded-b-lg bg-blue-600" />
      <span className="absolute right-1 top-0 h-7 w-3 skew-x-[18deg] rounded-b-lg bg-cyan-400" />
      <span className="absolute left-3 top-2 h-5 w-2.5 -skew-x-[18deg] rounded-b-lg bg-indigo-500" />
    </span>
  );
}
EOF

cat > components/BrandMark/index.ts <<'EOF'
export { BrandMark } from "./BrandMark";
EOF

cat > components/Logo/Logo.tsx <<'EOF'
import Link from "next/link";
import { BrandMark } from "@/components/BrandMark";

export function Logo() {
  return (
    <Link href="/" className="inline-flex items-center gap-2" aria-label="ViaPay">
      <BrandMark />
      <span className="text-xl font-bold tracking-tight text-slate-950">
        ViaPay
      </span>
    </Link>
  );
}
EOF

cat > components/Logo/index.ts <<'EOF'
export { Logo } from "./Logo";
EOF

cat > components/Button/Button.tsx <<'EOF'
import type { ButtonHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export function Button({
  className,
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      {...props}
      className={cn(
        "rounded-xl bg-blue-600 px-5 py-3 text-sm font-semibold text-white transition hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-50",
        className,
      )}
    />
  );
}
EOF

cat > components/Button/index.ts <<'EOF'
export { Button } from "./Button";
EOF

cat > components/Input/Input.tsx <<'EOF'
import type { InputHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export function Input({
  className,
  ...props
}: InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      className={cn(
        "w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition placeholder:text-slate-400 focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10",
        className,
      )}
    />
  );
}
EOF

cat > components/Input/index.ts <<'EOF'
export { Input } from "./Input";
EOF

cat > components/Card/Card.tsx <<'EOF'
import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

export function Card({
  children,
  className,
}: {
  children: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("rounded-2xl border border-slate-200 bg-white shadow-sm", className)}>
      {children}
    </div>
  );
}
EOF

cat > components/Card/index.ts <<'EOF'
export { Card } from "./Card";
EOF

cat > components/Badge/Badge.tsx <<'EOF'
import { cn } from "@/lib/utils";

const styles: Record<string, string> = {
  Liquidado: "bg-emerald-50 text-emerald-700 ring-emerald-200",
  Pago: "bg-blue-50 text-blue-700 ring-blue-200",
  Processando: "bg-amber-50 text-amber-700 ring-amber-200",
  Expirado: "bg-red-50 text-red-700 ring-red-200",
  "Aguardando pagamento": "bg-slate-100 text-slate-700 ring-slate-200",
};

export function Badge({ children }: { children: string }) {
  return (
    <span className={cn(
      "inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ring-1 ring-inset",
      styles[children] || "bg-slate-100 text-slate-700 ring-slate-200",
    )}>
      {children}
    </span>
  );
}
EOF

cat > components/Badge/index.ts <<'EOF'
export { Badge } from "./Badge";
EOF

# ------------------------------------------------------------
# 8. Marketing
# ------------------------------------------------------------
cat > components/Navbar/Navbar.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <Logo />
        <nav className="hidden items-center gap-7 text-sm font-medium text-slate-600 md:flex">
          <Link href="/como-funciona" className="hover:text-slate-950">Como funciona</Link>
          <Link href="/precos" className="hover:text-slate-950">Preços</Link>
          <Link href="/desenvolvedores" className="hover:text-slate-950">Desenvolvedores</Link>
          <Link href="/empresa" className="hover:text-slate-950">Empresa</Link>
        </nav>
        <div className="flex items-center gap-3">
          <Link href="/login" className="hidden text-sm font-semibold text-slate-700 sm:block">Entrar</Link>
          <Link href="/cadastro" className="rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-blue-700">
            Criar conta
          </Link>
        </div>
      </div>
    </header>
  );
}
EOF

cat > components/Navbar/index.ts <<'EOF'
export { Navbar } from "./Navbar";
EOF

cat > components/Footer/Footer.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Footer() {
  return (
    <footer className="border-t border-slate-200 bg-white">
      <div className="mx-auto grid max-w-7xl gap-10 px-6 py-14 md:grid-cols-4">
        <div>
          <Logo />
          <p className="mt-4 max-w-xs text-sm leading-6 text-slate-500">
            Infraestrutura de pagamentos para conectar Pix brasileiro a liquidação em USDC na Solana.
          </p>
        </div>
        <div>
          <h3 className="font-semibold">Produto</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/como-funciona">Como funciona</Link>
            <Link className="block" href="/precos">Preços</Link>
          </div>
        </div>
        <div>
          <h3 className="font-semibold">Desenvolvedores</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/desenvolvedores">Documentação</Link>
            <Link className="block" href="/dashboard/webhooks">Webhooks</Link>
          </div>
        </div>
        <div>
          <h3 className="font-semibold">Empresa</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link className="block" href="/empresa">Sobre</Link>
            <Link className="block" href="/contato">Contato</Link>
          </div>
        </div>
      </div>
      <div className="border-t border-slate-100 px-6 py-5 text-center text-xs text-slate-400">
        © 2026 ViaPay. Todos os direitos reservados.
      </div>
    </footer>
  );
}
EOF

cat > components/Footer/index.ts <<'EOF'
export { Footer } from "./Footer";
EOF

cat > app/page.tsx <<'EOF'
import Link from "next/link";
import { ArrowRight, Code2, Globe2, QrCode, ShieldCheck, Wallet } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

export default function HomePage() {
  return (
    <>
      <Navbar />
      <main>
        <section className="overflow-hidden bg-gradient-to-br from-white via-blue-50 to-cyan-50">
          <div className="mx-auto grid max-w-7xl gap-16 px-6 py-24 lg:grid-cols-2 lg:items-center">
            <div>
              <span className="inline-flex rounded-full border border-blue-100 bg-white px-3 py-1 text-xs font-semibold text-blue-700">
                Payment Settlement Infrastructure
              </span>
              <h1 className="mt-7 max-w-3xl text-5xl font-bold tracking-tight text-slate-950 md:text-6xl">
                Conectando o Pix brasileiro ao sistema financeiro global.
              </h1>
              <p className="mt-6 max-w-xl text-lg leading-8 text-slate-600">
                Infraestrutura de pagamentos que permite receber Pix e liquidar automaticamente em USDC na Solana.
              </p>
              <div className="mt-8 flex flex-wrap gap-3">
                <Link href="/cadastro" className="inline-flex items-center gap-2 rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700">
                  Começar agora <ArrowRight size={17} />
                </Link>
                <Link href="/desenvolvedores" className="rounded-xl border border-slate-200 bg-white px-5 py-3 font-semibold text-slate-900">
                  Ver documentação
                </Link>
              </div>
              <div className="mt-10 grid max-w-xl grid-cols-3 gap-5">
                <div><Code2 className="text-blue-600" /><p className="mt-2 text-sm font-semibold">SDK em 5 linhas</p></div>
                <div><Wallet className="text-blue-600" /><p className="mt-2 text-sm font-semibold">Receba em USDC</p></div>
                <div><ShieldCheck className="text-blue-600" /><p className="mt-2 text-sm font-semibold">Rápido e seguro</p></div>
              </div>
            </div>
            <Card className="p-7 shadow-2xl">
              <p className="text-sm font-semibold text-slate-500">ViaPay Checkout</p>
              <div className="mt-7 rounded-2xl bg-slate-50 p-8 text-center">
                <QrCode className="mx-auto" size={190} strokeWidth={1.3} />
                <p className="mt-5 text-2xl font-bold">R$ 100,00</p>
                <p className="mt-1 text-sm text-slate-500">Pague com Pix</p>
              </div>
              <div className="mt-5 grid grid-cols-2 gap-3">
                <div className="rounded-xl bg-blue-50 p-4"><p className="text-xs text-slate-500">Conversão</p><p className="font-semibold">BRL → USDC</p></div>
                <div className="rounded-xl bg-cyan-50 p-4"><p className="text-xs text-slate-500">Liquidação</p><p className="font-semibold">Solana</p></div>
              </div>
            </Card>
          </div>
        </section>
      </main>
      <Footer />
    </>
  );
}
EOF

cat > app/como-funciona/page.tsx <<'EOF'
import { ArrowRight, CheckCircle2, QrCode, Wallet, Zap } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

const steps = [
  ["1", "Gere a cobrança Pix", "Após a compra, um QR Pix é criado automaticamente.", QrCode],
  ["2", "Usuário paga", "O cliente paga com Pix normalmente.", CheckCircle2],
  ["3", "Conversão automática", "O valor é convertido de BRL para USDC.", Zap],
  ["4", "Liquidação na Solana", "O lojista recebe USDC na sua carteira Solana.", Wallet],
] as const;

export default function ComoFuncionaPage() {
  return (
    <>
      <Navbar />
      <main>
        <section className="bg-blue-50 px-6 py-24 text-center">
          <h1 className="text-5xl font-bold tracking-tight">Como funciona</h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg text-slate-600">
            Simples para o usuário. Poderoso para o desenvolvedor.
          </p>
        </section>
        <section className="mx-auto max-w-7xl px-6 py-20">
          <div className="grid gap-5 md:grid-cols-4">
            {steps.map(([number, title, description, Icon]) => (
              <Card key={number} className="relative p-6">
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><Icon /></div>
                <span className="mt-6 block text-xs font-bold text-blue-600">ETAPA {number}</span>
                <h2 className="mt-2 font-bold">{title}</h2>
                <p className="mt-2 text-sm leading-6 text-slate-500">{description}</p>
                {number !== "4" && <ArrowRight className="absolute -right-4 top-20 hidden text-slate-300 md:block" />}
              </Card>
            ))}
          </div>
        </section>
      </main>
      <Footer />
    </>
  );
}
EOF

cat > app/precos/page.tsx <<'EOF'
import Link from "next/link";
import { Check } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

const plans = [
  { name: "Gratuito", price: "R$ 0", items: ["Ambiente de testes (devnet)", "Volume limitado", "Suporte por comunidade"] },
  { name: "Pro", price: "R$ 99", featured: true, items: ["Volume maior", "Suporte prioritário", "Webhooks personalizados", "Relatórios avançados"] },
  { name: "Enterprise", price: "Sob consulta", items: ["Volumes altos", "Suporte dedicado", "Soluções personalizadas", "SLA"] },
];

export default function PrecosPage() {
  return (
    <>
      <Navbar />
      <main className="bg-slate-50 px-6 py-24">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-center text-5xl font-bold">Preços simples e transparentes</h1>
          <p className="mx-auto mt-5 max-w-2xl text-center text-slate-600">Comece gratuitamente e escale conforme seu volume.</p>
          <div className="mt-14 grid gap-6 md:grid-cols-3">
            {plans.map((plan) => (
              <Card key={plan.name} className={plan.featured ? "border-blue-500 p-8 ring-2 ring-blue-100" : "p-8"}>
                {plan.featured && <span className="rounded-full bg-blue-600 px-3 py-1 text-xs font-bold text-white">Mais popular</span>}
                <h2 className="mt-4 text-xl font-bold">{plan.name}</h2>
                <p className="mt-6 text-4xl font-bold">{plan.price}<span className="text-sm font-medium text-slate-400">/mês</span></p>
                <ul className="mt-8 space-y-4 text-sm text-slate-600">
                  {plan.items.map((item) => <li key={item} className="flex gap-2"><Check className="text-blue-600" size={18} />{item}</li>)}
                </ul>
                <Link href="/cadastro" className="mt-8 block rounded-xl bg-blue-600 py-3 text-center font-semibold text-white hover:bg-blue-700">
                  {plan.name === "Enterprise" ? "Falar com vendas" : "Começar agora"}
                </Link>
              </Card>
            ))}
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
EOF

cat > app/empresa/page.tsx <<'EOF'
import { Globe2, ShieldCheck, Zap } from "lucide-react";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

export default function EmpresaPage() {
  return (
    <>
      <Navbar />
      <main>
        <section className="bg-gradient-to-br from-blue-700 to-cyan-600 px-6 py-28 text-white">
          <div className="mx-auto max-w-5xl">
            <span className="text-sm font-semibold text-cyan-100">VIAPAY</span>
            <h1 className="mt-6 text-5xl font-bold">Uma nova forma de conectar o Brasil ao mundo.</h1>
            <p className="mt-6 max-w-2xl text-lg leading-8 text-blue-50">
              Infraestrutura de pagamentos orientada a APIs, Pix, conversão e liquidação em blockchain.
            </p>
          </div>
        </section>
        <section className="mx-auto grid max-w-6xl gap-6 px-6 py-20 md:grid-cols-3">
          <div><Zap className="text-blue-600" /><h2 className="mt-4 font-bold">Velocidade</h2><p className="mt-2 text-sm text-slate-500">Fluxos orientados a eventos e processamento assíncrono.</p></div>
          <div><ShieldCheck className="text-blue-600" /><h2 className="mt-4 font-bold">Segurança</h2><p className="mt-2 text-sm text-slate-500">Contratos explícitos, idempotência e rastreabilidade.</p></div>
          <div><Globe2 className="text-blue-600" /><h2 className="mt-4 font-bold">Global</h2><p className="mt-2 text-sm text-slate-500">Liquidação em USDC através da rede Solana.</p></div>
        </section>
      </main>
      <Footer />
    </>
  );
}
EOF

cat > app/contato/page.tsx <<'EOF'
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
EOF

# ------------------------------------------------------------
# 9. Login / Cadastro + onboarding do lojista
# ------------------------------------------------------------
cat > components/forms/LoginForm/LoginForm.tsx <<'EOF'
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
EOF

cat > components/forms/LoginForm/index.ts <<'EOF'
export { LoginForm } from "./LoginForm";
EOF

cat > components/forms/RegisterForm/RegisterForm.tsx <<'EOF'
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
EOF

cat > components/forms/RegisterForm/index.ts <<'EOF'
export { RegisterForm } from "./RegisterForm";
EOF

cat > app/login/page.tsx <<'EOF'
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
EOF

cat > app/cadastro/page.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";
import { RegisterForm } from "@/components/forms/RegisterForm";

export default function CadastroPage() {
  return (
    <main className="min-h-screen bg-slate-50 px-6 py-12">
      <div className="mx-auto max-w-lg rounded-3xl border border-slate-200 bg-white p-8 shadow-sm">
        <Logo />
        <h1 className="mt-10 text-3xl font-bold">Criar conta</h1>
        <p className="mt-2 text-sm text-slate-500">Comece sua integração com a ViaPay.</p>
        <RegisterForm />
        <p className="mt-6 text-center text-sm text-slate-500">
          Já possui conta? <Link href="/login" className="font-semibold text-blue-600">Entrar</Link>
        </p>
      </div>
    </main>
  );
}
EOF

cat > components/merchant/OnboardingStepper.tsx <<'EOF'
const steps = ["Criar conta", "Dados da empresa", "Carteira Solana", "Configurações", "Concluído"];

export function OnboardingStepper({ current = 2 }: { current?: number }) {
  return (
    <ol className="space-y-5">
      {steps.map((step, index) => (
        <li key={step} className="flex items-center gap-3">
          <span className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${
            index + 1 <= current ? "bg-blue-600 text-white" : "bg-slate-100 text-slate-400"
          }`}>{index + 1}</span>
          <span className={index + 1 === current ? "font-semibold text-slate-950" : "text-sm text-slate-500"}>{step}</span>
        </li>
      ))}
    </ol>
  );
}
EOF

cat > components/merchant/WalletConnect.tsx <<'EOF'
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
EOF

mkdir -p app/cadastro/empresa
cat > app/cadastro/empresa/page.tsx <<'EOF'
import Link from "next/link";
import { Button } from "@/components/Button";
import { Card } from "@/components/Card";
import { Input } from "@/components/Input";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";

export default function EmpresaOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={2} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Dados da empresa</h1>
            <p className="mt-2 text-sm text-slate-500">Vamos configurar sua conta para começar a receber pagamentos.</p>
            <div className="mt-8 grid gap-5 md:grid-cols-2">
              <Input placeholder="Sua empresa LTDA" />
              <Input placeholder="00.000.000/0000-00" />
              <Input placeholder="contato@suaempresa.com" type="email" />
              <Input placeholder="https://www.suaempresa.com" />
            </div>
            <Link href="/cadastro/carteira" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Continuar →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
EOF

mkdir -p app/cadastro/empresa app/cadastro/carteira app/cadastro/configuracoes

mkdir -p app/cadastro/carteira
cat > app/cadastro/carteira/page.tsx <<'EOF'
import Link from "next/link";
import { Card } from "@/components/Card";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";
import { WalletConnect } from "@/components/merchant/WalletConnect";

export default function CarteiraOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={3} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Conecte sua carteira Solana</h1>
            <p className="mt-2 text-sm text-slate-500">É aqui que você receberá os pagamentos em USDC.</p>
            <div className="mt-8"><WalletConnect /></div>
            <Link href="/cadastro/configuracoes" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Continuar →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
EOF

mkdir -p app/cadastro/configuracoes
cat > app/cadastro/configuracoes/page.tsx <<'EOF'
import Link from "next/link";
import { Card } from "@/components/Card";
import { Input } from "@/components/Input";
import { OnboardingStepper } from "@/components/merchant/OnboardingStepper";

export default function ConfiguracoesOnboardingPage() {
  return (
    <main className="min-h-screen bg-slate-50">
      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-[260px_1fr]">
        <aside className="border-r bg-white p-8"><OnboardingStepper current={4} /></aside>
        <section className="p-6 lg:p-12">
          <Card className="mx-auto max-w-3xl p-8">
            <h1 className="text-3xl font-bold">Configurações</h1>
            <p className="mt-2 text-sm text-slate-500">Defina as preferências iniciais da sua conta.</p>
            <div className="mt-8 space-y-5">
              <Input placeholder="URL de webhook" />
              <Input placeholder="E-mail para notificações" type="email" />
              <label className="flex items-center gap-3 text-sm"><input type="checkbox" defaultChecked /> Ativar notificações de pagamento</label>
            </div>
            <Link href="/dashboard" className="mt-8 inline-flex rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white">Concluir cadastro →</Link>
          </Card>
        </section>
      </div>
    </main>
  );
}
EOF

# ------------------------------------------------------------
# 10. Dashboard
# ------------------------------------------------------------
cat > components/dashboard/Sidebar/Sidebar.tsx <<'EOF'
import Link from "next/link";
import { ArrowLeftRight, BookOpen, CreditCard, LayoutDashboard, Settings, Wallet, Webhook } from "lucide-react";
import { Logo } from "@/components/Logo";

const navigation = [
  ["/dashboard", "Visão Geral", LayoutDashboard],
  ["/dashboard/pagamentos", "Pagamentos", CreditCard],
  ["/dashboard/liquidacoes", "Liquidações", ArrowLeftRight],
  ["/dashboard/carteiras", "Carteiras", Wallet],
  ["/dashboard/webhooks", "Webhooks", Webhook],
  ["/dashboard/documentacao", "Documentação", BookOpen],
  ["/dashboard/configuracoes", "Configurações", Settings],
] as const;

export function Sidebar() {
  return (
    <aside className="fixed inset-y-0 left-0 z-40 hidden w-64 border-r border-slate-800 bg-[#07142f] lg:block">
      <div className="flex h-16 items-center border-b border-white/10 px-5">
        <Link href="/" className="flex items-center gap-2 text-white"><span className="text-xl font-bold">ViaPay</span></Link>
      </div>
      <nav className="space-y-1 p-4">
        {navigation.map(([href, label, Icon]) => (
          <Link key={href} href={href} className="flex items-center gap-3 rounded-xl px-3 py-3 text-sm font-medium text-slate-300 hover:bg-white/10 hover:text-white">
            <Icon size={18} /> {label}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
EOF

cat > components/dashboard/Sidebar/index.ts <<'EOF'
export { Sidebar } from "./Sidebar";
EOF

cat > components/dashboard/DashboardShell/DashboardShell.tsx <<'EOF'
import type { ReactNode } from "react";
import { Sidebar } from "@/components/dashboard/Sidebar";

export function DashboardShell({ children }: { children: ReactNode }) {
  return <div className="min-h-screen bg-slate-50"><Sidebar /><main className="min-h-screen lg:pl-64">{children}</main></div>;
}
EOF

cat > components/dashboard/DashboardShell/index.ts <<'EOF'
export { DashboardShell } from "./DashboardShell";
EOF

cat > components/dashboard/StatCard/StatCard.tsx <<'EOF'
import { Card } from "@/components/Card";

export function StatCard({ title, value, change }: { title: string; value: string; change: string }) {
  return (
    <Card className="p-5">
      <p className="text-sm text-slate-500">{title}</p>
      <div className="mt-3 flex items-end justify-between gap-4">
        <strong className="text-2xl text-slate-950">{value}</strong>
        <span className="text-xs font-semibold text-emerald-600">{change}</span>
      </div>
    </Card>
  );
}
EOF

cat > components/dashboard/StatCard/index.ts <<'EOF'
export { StatCard } from "./StatCard";
EOF

cat > components/dashboard/PaymentTable/PaymentTable.tsx <<'EOF'
import Link from "next/link";
import { ArrowUpRight } from "lucide-react";
import { Badge } from "@/components/Badge";

const rows = [
  ["pay_01J2...", "Cliente Exemplo", "R$ 100,00", "18,42 USDC", "Liquidado", "30/10 14:32"],
  ["pay_01J25...", "Maria Silva", "R$ 250,00", "46,10 USDC", "Liquidado", "30/10 13:21"],
  ["pay_01J24...", "João Santos", "R$ 80,00", "14,73 USDC", "Processando", "30/10 12:45"],
  ["pay_01J23...", "Ana Costa", "R$ 150,00", "27,68 USDC", "Pago", "30/10 10:18"],
  ["pay_01J22...", "Pedro Lima", "R$ 320,00", "58,90 USDC", "Expirado", "30/10 09:12"],
] as const;

export function PaymentTable() {
  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white">
      <table className="w-full min-w-[800px] text-left text-sm">
        <thead className="border-b bg-slate-50 text-xs uppercase text-slate-500">
          <tr>{["ID", "Cliente", "Valor (BRL)", "USDC", "Status", "Data", ""].map((h) => <th key={h} className="px-5 py-4">{h}</th>)}</tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row[0]} className="border-b last:border-0 hover:bg-slate-50">
              {row.map((cell, i) => <td key={`${row[0]}-${i}`} className="px-5 py-4">{i === 4 ? <Badge>{cell}</Badge> : <span className={i === 0 ? "font-mono text-xs" : ""}>{cell}</span>}</td>)}
              <td className="px-5 py-4"><Link href="/dashboard/pagamentos/pay_01J25a7f3" className="text-blue-600"><ArrowUpRight size={17} /></Link></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
EOF

cat > components/dashboard/PaymentTable/index.ts <<'EOF'
export { PaymentTable } from "./PaymentTable";
EOF

cat > app/dashboard/layout.tsx <<'EOF'
import type { ReactNode } from "react";
import { DashboardShell } from "@/components/dashboard/DashboardShell";

export default function DashboardLayout({ children }: { children: ReactNode }) {
  return <DashboardShell>{children}</DashboardShell>;
}
EOF

cat > app/dashboard/page.tsx <<'EOF'
import { Card } from "@/components/Card";
import { StatCard } from "@/components/dashboard/StatCard";

export default function DashboardPage() {
  const metrics = [
    ["Volume Processado", "R$ 12.480,32", "+12%"],
    ["Pagamentos", "128", "+8%"],
    ["Liquidações", "124", "+10%"],
    ["USDC Recebido", "2.348,52 USDC", "+15%"],
  ] as const;

  const bars = [30,42,38,55,48,70,61,76,68,82,75,94];

  return (
    <>
      <header className="border-b bg-white px-6 py-6">
        <div className="mx-auto max-w-7xl"><p className="text-xs font-semibold uppercase tracking-wider text-blue-600">Últimos 30 dias</p><h1 className="mt-1 text-2xl font-bold">Visão Geral</h1></div>
      </header>
      <div className="mx-auto max-w-7xl space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-2 xl:grid-cols-4">
          {metrics.map(([title, value, change]) => <StatCard key={title} title={title} value={value} change={change} />)}
        </div>
        <Card className="p-6">
          <div className="flex items-center justify-between"><h2 className="font-bold">Volume de pagamentos</h2><select className="rounded-lg border border-slate-200 px-3 py-2 text-sm"><option>BRL</option><option>USDC</option></select></div>
          <div className="mt-8 flex h-64 items-end gap-2">
            {bars.map((height, index) => <div key={index} className="flex-1 rounded-t bg-blue-500" style={{ height: `${height}%` }} />)}
          </div>
          <div className="mt-3 flex justify-between text-xs text-slate-400"><span>1 out</span><span>8 out</span><span>15 out</span><span>22 out</span><span>30 out</span></div>
        </Card>
      </div>
    </>
  );
}
EOF

cat > app/dashboard/pagamentos/page.tsx <<'EOF'
import { Download, Filter, Search } from "lucide-react";
import { PaymentTable } from "@/components/dashboard/PaymentTable";

export default function PagamentosPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Pagamentos</h1><p className="mt-1 text-sm text-slate-500">Acompanhe todos os seus pagamentos em tempo real.</p></header>
      <div className="mx-auto max-w-7xl space-y-5 p-6">
        <div className="flex flex-col gap-3 md:flex-row">
          <div className="relative flex-1"><Search className="absolute left-3 top-3 text-slate-400" size={18} /><input className="w-full rounded-xl border border-slate-200 bg-white py-3 pl-10 pr-4 text-sm" placeholder="Buscar por ID, cliente ou valor..." /></div>
          <button className="inline-flex items-center justify-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold"><Filter size={17} />Filtro</button>
          <button className="inline-flex items-center justify-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold"><Download size={17} />Exportar</button>
        </div>
        <div className="overflow-x-auto"><PaymentTable /></div>
      </div>
    </>
  );
}
EOF

cat > app/dashboard/pagamentos/'[id]'/page.tsx <<'EOF'
import Link from "next/link";
import { ArrowLeft, CheckCircle2, Circle } from "lucide-react";
import { Badge } from "@/components/Badge";
import { Card } from "@/components/Card";

export default async function PaymentDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const timeline = [
    ["Pagamento criado", "14:32", true],
    ["QR Pix gerado", "14:32", true],
    ["Pagamento confirmado", "14:33", true],
    ["Conversão para USDC", "14:33", true],
    ["Transferência na Solana", "14:34", true],
    ["Liquidado", "14:34", true],
  ] as const;

  return (
    <div>
      <header className="border-b bg-white px-6 py-6">
        <div className="mx-auto max-w-7xl">
          <Link href="/dashboard/pagamentos" className="inline-flex items-center gap-2 text-sm text-slate-500"><ArrowLeft size={16} />Voltar para pagamentos</Link>
          <div className="mt-4 flex flex-wrap items-center gap-3"><h1 className="text-2xl font-bold">Pagamento #{id}</h1><Badge>Liquidado</Badge></div>
          <p className="mt-1 text-sm text-slate-500">Criado em 30 de outubro de 2026 às 14:32</p>
        </div>
      </header>
      <main className="mx-auto grid max-w-7xl gap-6 p-6 lg:grid-cols-2">
        <Card className="p-6">
          <h2 className="font-bold">Informações gerais</h2>
          <dl className="mt-6 divide-y divide-slate-100">
            {[
              ["Valor (BRL)", "R$ 100,00"],
              ["USDC recebido", "18,42 USDC"],
              ["Câmbio utilizado", "1 USDC = R$ 5,43"],
              ["Status", "Liquidado"],
              ["Cliente", "Cliente Exemplo"],
              ["Referência", "order_123"],
              ["Expira em", "30/10/2026 15:02"],
            ].map(([label, value]) => <div key={label} className="flex justify-between gap-6 py-4 text-sm"><dt className="text-slate-500">{label}</dt><dd className="font-semibold text-right">{value}</dd></div>)}
          </dl>
        </Card>
        <Card className="p-6">
          <h2 className="font-bold">Linha do tempo</h2>
          <div className="mt-6 space-y-5">
            {timeline.map(([label, time, done]) => <div key={label} className="flex gap-3"><div className="mt-0.5">{done ? <CheckCircle2 className="text-emerald-500" size={19} /> : <Circle size={19} />}</div><div className="flex-1 flex justify-between text-sm"><span>{label}</span><span className="text-slate-400">{time}</span></div></div>)}
          </div>
        </Card>
      </main>
    </div>
  );
}
EOF

cat > app/dashboard/liquidacoes/page.tsx <<'EOF'
import { ArrowUpRight, CheckCircle2 } from "lucide-react";
import { Card } from "@/components/Card";

export default function LiquidacoesPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Liquidações</h1><p className="mt-1 text-sm text-slate-500">Acompanhe as liquidações em USDC na Solana.</p></header>
      <main className="mx-auto max-w-7xl space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-3">
          <Card className="p-5"><p className="text-sm text-slate-500">Total liquidado</p><p className="mt-2 text-2xl font-bold">2.348,52 USDC</p></Card>
          <Card className="p-5"><p className="text-sm text-slate-500">Liquidações</p><p className="mt-2 text-2xl font-bold">124</p></Card>
          <Card className="p-5"><p className="text-sm text-slate-500">Status</p><p className="mt-2 flex items-center gap-2 text-2xl font-bold"><CheckCircle2 className="text-emerald-500" />Operacional</p></Card>
        </div>
        <Card className="overflow-hidden">
          <div className="border-b p-5 font-bold">Histórico de liquidações</div>
          <div className="divide-y">
            {["set_01J25a7", "set_01J25a1", "set_01J24ff"].map((id, i) => <div key={id} className="flex items-center justify-between p-5 text-sm"><div><p className="font-mono">{id}</p><p className="mt-1 text-slate-500">Pagamento pay_01J2... • 30/10/2026</p></div><div className="flex items-center gap-5"><strong>{[18.42,46.10,14.73][i].toFixed(2)} USDC</strong><ArrowUpRight className="text-blue-600" size={17} /></div></div>)}
          </div>
        </Card>
      </main>
    </>
  );
}
EOF

cat > app/dashboard/carteiras/page.tsx <<'EOF'
import { Copy, ExternalLink, Wallet } from "lucide-react";
import { Card } from "@/components/Card";

export default function CarteirasPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Carteiras</h1><p className="mt-1 text-sm text-slate-500">Carteira Solana usada para receber liquidações.</p></header>
      <main className="mx-auto max-w-5xl p-6">
        <Card className="p-6">
          <div className="flex items-center gap-3"><div className="rounded-xl bg-blue-50 p-3 text-blue-600"><Wallet /></div><div><h2 className="font-bold">Carteira de liquidação</h2><p className="text-sm text-slate-500">Solana • USDC</p></div></div>
          <div className="mt-8 rounded-2xl bg-slate-50 p-5"><p className="text-xs font-semibold uppercase text-slate-400">Endereço</p><div className="mt-2 flex items-center gap-2 break-all font-mono text-sm">7Yg...ViaPaySolanaWallet <Copy size={16} className="shrink-0 text-slate-400" /></div></div>
          <div className="mt-5 flex gap-3"><button className="rounded-xl border px-4 py-3 text-sm font-semibold">Alterar carteira</button><button className="inline-flex items-center gap-2 rounded-xl border px-4 py-3 text-sm font-semibold">Solana Explorer <ExternalLink size={16} /></button></div>
        </Card>
      </main>
    </>
  );
}
EOF

cat > app/dashboard/webhooks/page.tsx <<'EOF'
import { Card } from "@/components/Card";

export default function WebhooksPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Webhooks</h1><p className="mt-1 text-sm text-slate-500">Eventos enviados para sua aplicação.</p></header>
      <main className="mx-auto max-w-5xl space-y-6 p-6">
        <Card className="p-6"><h2 className="font-bold">Endpoint</h2><div className="mt-4 rounded-xl bg-slate-950 p-4 font-mono text-sm text-slate-200">https://suaempresa.com/api/viapay/webhook</div></Card>
        <Card className="overflow-hidden"><div className="border-b p-5 font-bold">Eventos</div><div className="divide-y">{["payment.created","payment.pix_confirmed","payment.settling","payment.settled"].map((event) => <div key={event} className="p-5 text-sm"><span className="font-mono text-blue-600">{event}</span><p className="mt-1 text-slate-500">Evento de ciclo de vida do pagamento.</p></div>)}</div></Card>
      </main>
    </>
  );
}
EOF

cat > app/dashboard/documentacao/page.tsx <<'EOF'
import { CodeBlock } from "@/components/developer/CodeBlock";
import { DocsSidebar } from "@/components/developer/DocsSidebar";

export default function DashboardDocumentationPage() {
  return (
    <div className="grid min-h-screen lg:grid-cols-[240px_1fr]">
      <DocsSidebar />
      <main className="p-6 lg:p-12">
        <div className="mx-auto max-w-4xl">
          <span className="text-xs font-semibold uppercase tracking-wider text-blue-600">Documentação</span>
          <h1 className="mt-3 text-4xl font-bold">Comece em 5 linhas</h1>
          <p className="mt-3 text-slate-500">Instale o SDK e comece a aceitar Pix.</p>
          <CodeBlock />
        </div>
      </main>
    </div>
  );
}
EOF

cat > app/dashboard/configuracoes/page.tsx <<'EOF'
import { Card } from "@/components/Card";
import { Input } from "@/components/Input";

export default function ConfiguracoesPage() {
  return (
    <>
      <header className="border-b bg-white px-6 py-6"><h1 className="text-2xl font-bold">Configurações</h1><p className="mt-1 text-sm text-slate-500">Gerencie sua conta e integrações.</p></header>
      <main className="mx-auto max-w-5xl space-y-6 p-6">
        <Card className="p-6"><h2 className="font-bold">Dados da empresa</h2><div className="mt-5 grid gap-4 md:grid-cols-2"><Input placeholder="Nome da empresa" /><Input placeholder="CNPJ" /><Input placeholder="E-mail comercial" /><Input placeholder="Site" /></div></Card>
        <Card className="p-6"><h2 className="font-bold">Integração</h2><div className="mt-5 space-y-4"><Input placeholder="Webhook URL" /><Input placeholder="API Key" type="password" /></div></Card>
      </main>
    </>
  );
}
EOF

cat > components/developer/CodeBlock.tsx <<'EOF'
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
EOF

cat > components/developer/DocsSidebar.tsx <<'EOF'
import Link from "next/link";

const items = ["Introdução", "Instalação", "Primeiros passos", "Exemplos", "API Reference", "Webhooks", "Ambiente de Testes", "Boas práticas"];

export function DocsSidebar() {
  return (
    <aside className="border-r bg-white p-6">
      <p className="font-bold">Documentação</p>
      <nav className="mt-5 space-y-1">{items.map((item, i) => <Link key={item} href="/dashboard/documentacao" className={`block rounded-lg px-3 py-2 text-sm ${i === 0 ? "bg-blue-50 font-semibold text-blue-700" : "text-slate-500 hover:bg-slate-50"}`}>{item}</Link>)}</nav>
    </aside>
  );
}
EOF

cat > app/desenvolvedores/page.tsx <<'EOF'
import Link from "next/link";
import { Code2, ExternalLink, Webhook } from "lucide-react";
import { Card } from "@/components/Card";
import { Footer } from "@/components/Footer";
import { Navbar } from "@/components/Navbar";

export default function DesenvolvedoresPage() {
  return (
    <>
      <Navbar />
      <main className="bg-slate-50 px-6 py-20">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-5xl font-bold">Desenvolvedores</h1>
          <p className="mt-4 max-w-2xl text-lg text-slate-600">Cadastro → credenciais → integração → cobrança → webhook → liquidação.</p>
          <div className="mt-12 grid gap-6 md:grid-cols-3">
            <Card className="p-6"><Code2 className="text-blue-600" /><h2 className="mt-5 font-bold">SDK</h2><p className="mt-2 text-sm text-slate-500">Integre a criação de cobranças de forma tipada.</p><Link href="/dashboard/documentacao" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Abrir documentação →</Link></Card>
            <Card className="p-6"><Webhook className="text-blue-600" /><h2 className="mt-5 font-bold">Webhooks</h2><p className="mt-2 text-sm text-slate-500">Receba eventos do ciclo de vida do pagamento.</p><Link href="/dashboard/webhooks" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Ver eventos →</Link></Card>
            <Card className="p-6"><ExternalLink className="text-blue-600" /><h2 className="mt-5 font-bold">API Reference</h2><p className="mt-2 text-sm text-slate-500">Contratos da API organizados por recurso.</p><Link href="/dashboard/documentacao" className="mt-5 inline-flex text-sm font-semibold text-blue-600">Consultar →</Link></Card>
          </div>
        </div>
      </main>
      <Footer />
    </>
  );
}
EOF

# ------------------------------------------------------------
# 11. Checkout Pix — telas 11 e 12
# ------------------------------------------------------------
cat > components/checkout/QRCode/QRCode.tsx <<'EOF'
import { QrCode as QrCodeIcon } from "lucide-react";

export function QRCode() {
  return (
    <div className="flex aspect-square max-w-[320px] items-center justify-center rounded-3xl border border-slate-200 bg-white shadow-sm">
      <QrCodeIcon size={230} strokeWidth={1.1} className="text-slate-950" />
    </div>
  );
}
EOF

cat > components/checkout/QRCode/index.ts <<'EOF'
export { QRCode } from "./QRCode";
EOF

cat > components/checkout/PaymentSummary/PaymentSummary.tsx <<'EOF'
import { Card } from "@/components/Card";

export function PaymentSummary() {
  return (
    <Card className="p-6">
      <div className="flex justify-between text-sm"><span className="text-slate-500">Valor</span><strong>R$ 100,00</strong></div>
      <div className="mt-4 flex justify-between text-sm"><span className="text-slate-500">Expira em</span><strong>14:58</strong></div>
    </Card>
  );
}
EOF

cat > components/checkout/PaymentSummary/index.ts <<'EOF'
export { PaymentSummary } from "./PaymentSummary";
EOF

cat > app/checkout/'[paymentId]'/page.tsx <<'EOF'
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
EOF

cat > app/checkout/'[paymentId]'/success/page.tsx <<'EOF'
import Link from "next/link";
import { CheckCircle2, ExternalLink } from "lucide-react";
import { Logo } from "@/components/Logo";

export default function CheckoutSuccessPage() {
  return (
    <main className="min-h-screen bg-slate-50 px-6 py-10">
      <div className="mx-auto max-w-2xl"><Logo />
        <div className="mt-16 text-center">
          <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-emerald-50 text-emerald-600"><CheckCircle2 size={48} /></div>
          <h1 className="mt-6 text-4xl font-bold">Pagamento confirmado!</h1>
          <p className="mt-2 text-slate-500">Seu pagamento foi processado com sucesso.</p>
        </div>
        <div className="mt-10 rounded-3xl border border-slate-200 bg-white p-7 shadow-sm">
          <div className="flex justify-between py-4 text-sm"><span className="text-slate-500">Valor pago</span><strong>R$ 100,00</strong></div>
          <div className="flex justify-between py-4 text-sm"><span className="text-slate-500">USDC recebido</span><strong>18,42 USDC</strong></div>
          <div className="flex justify-between gap-5 py-4 text-sm"><span className="text-slate-500">Transação na Solana</span><span className="font-mono font-semibold">5xK8...9zP2</span></div>
        </div>
        <a href="https://explorer.solana.com/" target="_blank" rel="noreferrer" className="mt-6 flex items-center justify-center gap-2 rounded-xl bg-blue-600 py-3 font-semibold text-white hover:bg-blue-700">Ver no Solana Explorer <ExternalLink size={17} /></a>
        <Link href="/" className="mt-5 block text-center text-sm text-slate-500">Obrigado por usar a ViaPay!</Link>
      </div>
    </main>
  );
}
EOF

# ------------------------------------------------------------
# 12. Validação
# ------------------------------------------------------------
cd "$ROOT"

echo
echo "=============================================="
echo " VALIDANDO"
echo "=============================================="

if [ "$PM" = "pnpm" ]; then
  pnpm exec tsc --noEmit -p apps/web/tsconfig.json
  pnpm --filter web build
else
  npx tsc --noEmit -p apps/web/tsconfig.json
  npm --prefix apps/web run build
fi

echo
echo "=============================================="
echo " VIAPAY PRONTO"
echo "=============================================="
echo "Rotas principais:"
echo "  /"
echo "  /como-funciona"
echo "  /precos"
echo "  /desenvolvedores"
echo "  /login"
echo "  /cadastro"
echo "  /cadastro/empresa"
echo "  /cadastro/carteira"
echo "  /cadastro/configuracoes"
echo "  /dashboard"
echo "  /dashboard/pagamentos"
echo "  /dashboard/pagamentos/pay_01J25a7f3"
echo "  /dashboard/liquidacoes"
echo "  /dashboard/carteiras"
echo "  /dashboard/webhooks"
echo "  /dashboard/documentacao"
echo "  /dashboard/configuracoes"
echo "  /checkout/pay_01J25a7f3"
echo "  /checkout/pay_01J25a7f3/success"
echo
echo "IMPORTANTE: o script cria a camada visual e os fluxos de UI."
echo "Integrações reais de Pix, câmbio, USDC e Solana continuam dependentes"
echo "dos providers/contratos do backend existentes."
