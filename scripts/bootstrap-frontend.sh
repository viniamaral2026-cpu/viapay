#!/usr/bin/env bash

set -euo pipefail

ROOT="/mnt/ai-knowledge/viapay/apps/web"

echo "🚀 ViaPay — Enterprise Frontend Bootstrap"
echo "📁 $ROOT"

cd "$ROOT"

echo "📦 Instalando dependências..."

pnpm add lucide-react clsx tailwind-merge class-variance-authority

echo "📂 Criando estrutura..."

mkdir -p \
app \
app/login \
app/cadastro \
app/como-funciona \
app/precos \
app/empresa \
app/contato \
app/onboarding/empresa \
app/onboarding/carteira \
app/onboarding/configuracao \
app/dashboard \
app/dashboard/pagamentos \
app/dashboard/pagamentos/'[id]' \
app/dashboard/liquidacoes \
app/dashboard/carteiras \
app/dashboard/webhooks \
app/dashboard/documentacao \
app/dashboard/configuracoes \
app/checkout/'[paymentId]' \
app/checkout/'[paymentId]'/success \
components/Layout \
components/Navbar \
components/Footer \
components/Logo \
components/BrandMark \
components/Button \
components/Input \
components/Card \
components/Badge \
components/Section \
components/Hero \
components/marketing/FeatureCard \
components/marketing/StepCard \
components/marketing/PricingCard \
components/dashboard/DashboardShell \
components/dashboard/Sidebar \
components/dashboard/Topbar \
components/dashboard/StatCard \
components/dashboard/ChartCard \
components/dashboard/PaymentTable \
components/dashboard/PaymentRow \
components/dashboard/SettlementTable \
components/dashboard/WalletCard \
components/dashboard/WebhookCard \
components/dashboard/EmptyState \
components/dashboard/PageHeader \
components/checkout/CheckoutCard \
components/checkout/QRCode \
components/checkout/PaymentSummary \
components/checkout/PaymentStatus \
components/checkout/SuccessCard \
components/forms/LoginForm \
components/forms/RegisterForm \
components/forms/CompanyForm \
components/forms/WalletForm \
components/forms/SettingsForm \
lib \
services \
types \
constants \
config \
hooks \
styles

echo "🧩 Criando componentes..."

cat > components/Logo/Logo.tsx <<'EOF'
import Link from "next/link";
import { BrandMark } from "@/components/BrandMark";

export function Logo() {
  return (
    <Link href="/" className="flex items-center gap-2">
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

cat > components/Logo/Logo.css <<'EOF'
.logo {}
EOF

cat > components/BrandMark/BrandMark.tsx <<'EOF'
export function BrandMark() {
  return (
    <div className="relative h-9 w-9 shrink-0">
      <div className="absolute left-1 top-2 h-6 w-3 -skew-x-[18deg] rounded-b-lg bg-blue-600" />
      <div className="absolute right-1 top-0 h-7 w-3 skew-x-[18deg] rounded-b-lg bg-cyan-400" />
      <div className="absolute left-3 top-2 h-5 w-2.5 -skew-x-[18deg] rounded-b-lg bg-indigo-500" />
    </div>
  );
}
EOF

cat > components/BrandMark/index.ts <<'EOF'
export { BrandMark } from "./BrandMark";
EOF

cat > components/BrandMark/BrandMark.css <<'EOF'
.brand-mark {}
EOF

cat > components/Navbar/Navbar.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <Logo />

        <nav className="hidden items-center gap-7 md:flex">
          <Link href="/como-funciona">Como funciona</Link>
          <Link href="/precos">Preços</Link>
          <Link href="/empresa">Empresa</Link>
          <Link href="/contato">Contato</Link>
        </nav>

        <div className="flex items-center gap-3">
          <Link href="/login" className="text-sm font-medium">
            Entrar
          </Link>

          <Link
            href="/cadastro"
            className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white"
          >
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

cat > components/Navbar/Navbar.css <<'EOF'
.navbar {}
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
            Infraestrutura de pagamentos para conectar o Pix brasileiro
            ao sistema financeiro global.
          </p>
        </div>

        <div>
          <h3 className="font-semibold">Produto</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link href="/como-funciona" className="block">
              Como funciona
            </Link>
            <Link href="/precos" className="block">
              Preços
            </Link>
          </div>
        </div>

        <div>
          <h3 className="font-semibold">Desenvolvedores</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link href="/dashboard/documentacao" className="block">
              Documentação
            </Link>
            <Link href="/dashboard/webhooks" className="block">
              Webhooks
            </Link>
          </div>
        </div>

        <div>
          <h3 className="font-semibold">Empresa</h3>
          <div className="mt-4 space-y-3 text-sm text-slate-500">
            <Link href="/empresa" className="block">
              Sobre
            </Link>
            <Link href="/contato" className="block">
              Contato
            </Link>
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

cat > components/Footer/Footer.css <<'EOF'
.footer {}
EOF

cat > components/Button/Button.tsx <<'EOF'
import { cn } from "@/lib/utils";

type ButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement>;

export function Button({ className, ...props }: ButtonProps) {
  return (
    <button
      {...props}
      className={cn(
        "rounded-lg bg-blue-600 px-5 py-3 text-sm font-semibold text-white transition hover:bg-blue-700",
        className,
      )}
    />
  );
}
EOF

cat > components/Button/index.ts <<'EOF'
export { Button } from "./Button";
EOF

cat > components/Button/Button.css <<'EOF'
.button {}
EOF

cat > components/Input/Input.tsx <<'EOF'
import { cn } from "@/lib/utils";

type InputProps = React.InputHTMLAttributes<HTMLInputElement>;

export function Input({ className, ...props }: InputProps) {
  return (
    <input
      {...props}
      className={cn(
        "w-full rounded-lg border border-slate-200 bg-white px-3 py-3 text-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-500/10",
        className,
      )}
    />
  );
}
EOF

cat > components/Input/index.ts <<'EOF'
export { Input } from "./Input";
EOF

cat > components/Input/Input.css <<'EOF'
.input {}
EOF

cat > components/Card/Card.tsx <<'EOF'
import { cn } from "@/lib/utils";

export function Card({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "rounded-xl border border-slate-200 bg-white shadow-sm",
        className,
      )}
    >
      {children}
    </div>
  );
}
EOF

cat > components/Card/index.ts <<'EOF'
export { Card } from "./Card";
EOF

cat > components/Card/Card.css <<'EOF'
.card {}
EOF

cat > components/Badge/Badge.tsx <<'EOF'
export function Badge({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <span className="inline-flex rounded-full bg-blue-50 px-2.5 py-1 text-xs font-semibold text-blue-700">
      {children}
    </span>
  );
}
EOF

cat > components/Badge/index.ts <<'EOF'
export { Badge } from "./Badge";
EOF

cat > components/Badge/Badge.css <<'EOF'
.badge {}
EOF

cat > components/dashboard/StatCard/StatCard.tsx <<'EOF'
import { Card } from "@/components/Card";

export function StatCard({
  title,
  value,
  change,
}: {
  title: string;
  value: string;
  change: string;
}) {
  return (
    <Card className="p-5">
      <p className="text-sm text-slate-500">{title}</p>

      <div className="mt-3 flex items-end justify-between">
        <strong className="text-2xl text-slate-950">{value}</strong>

        <span className="text-xs font-semibold text-emerald-600">
          {change}
        </span>
      </div>
    </Card>
  );
}
EOF

cat > components/dashboard/StatCard/index.ts <<'EOF'
export { StatCard } from "./StatCard";
EOF

cat > components/dashboard/StatCard/StatCard.css <<'EOF'
.stat-card {}
EOF

cat > components/dashboard/Sidebar/Sidebar.tsx <<'EOF'
import Link from "next/link";
import {
  LayoutDashboard,
  CreditCard,
  ArrowLeftRight,
  Wallet,
  Webhook,
  BookOpen,
  Settings,
} from "lucide-react";
import { Logo } from "@/components/Logo";

const items = [
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
    <aside className="fixed inset-y-0 left-0 hidden w-64 border-r border-slate-800 bg-[#07142f] lg:block">
      <div className="flex h-16 items-center border-b border-white/10 px-5">
        <Logo />
      </div>

      <nav className="space-y-1 p-4">
        {items.map(([href, label, Icon]) => (
          <Link
            key={href}
            href={href}
            className="flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white"
          >
            <Icon size={18} />
            {label}
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

cat > components/dashboard/Sidebar/Sidebar.css <<'EOF'
.sidebar {}
EOF

cat > components/dashboard/DashboardShell/DashboardShell.tsx <<'EOF'
import { Sidebar } from "@/components/dashboard/Sidebar";

export function DashboardShell({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-slate-50">
      <Sidebar />

      <main className="lg:pl-64">
        {children}
      </main>
    </div>
  );
}
EOF

cat > components/dashboard/DashboardShell/index.ts <<'EOF'
export { DashboardShell } from "./DashboardShell";
EOF

cat > components/dashboard/DashboardShell/DashboardShell.css <<'EOF'
.dashboard-shell {}
EOF

cat > components/checkout/QRCode/QRCode.tsx <<'EOF'
import { QrCode as QrIcon } from "lucide-react";

export function QRCode() {
  return (
    <div className="flex aspect-square items-center justify-center rounded-2xl bg-white p-8">
      <QrIcon size={190} strokeWidth={1.4} className="text-slate-950" />
    </div>
  );
}
EOF

cat > components/checkout/QRCode/index.ts <<'EOF'
export { QRCode } from "./QRCode";
EOF

cat > components/checkout/QRCode/QRCode.css <<'EOF'
.qr-code {}
EOF

cat > components/checkout/PaymentSummary/PaymentSummary.tsx <<'EOF'
import { Card } from "@/components/Card";

export function PaymentSummary() {
  return (
    <Card className="p-5">
      <div className="flex justify-between text-sm">
        <span className="text-slate-500">Valor</span>
        <strong>R$ 100,00</strong>
      </div>

      <div className="mt-4 flex justify-between text-sm">
        <span className="text-slate-500">Liquidação</span>
        <strong>USDC / Solana</strong>
      </div>
    </Card>
  );
}
EOF

cat > components/checkout/PaymentSummary/index.ts <<'EOF'
export { PaymentSummary } from "./PaymentSummary";
EOF

cat > components/checkout/PaymentSummary/PaymentSummary.css <<'EOF'
.payment-summary {}
EOF

echo "📄 Criando páginas..."

cat > app/layout.tsx <<'EOF'
import "@/styles/globals.css";

export const metadata = {
  title: "ViaPay",
  description: "Payment Settlement Infrastructure",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
EOF

cat > app/page.tsx <<'EOF'
import Link from "next/link";
import { ArrowRight, Globe2, QrCode, ShieldCheck } from "lucide-react";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { Card } from "@/components/Card";

export default function HomePage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="overflow-hidden bg-gradient-to-br from-white via-blue-50 to-cyan-50">
          <div className="mx-auto grid max-w-7xl gap-16 px-6 py-24 lg:grid-cols-2 lg:items-center">
            <div>
              <span className="rounded-full border border-blue-100 bg-white px-3 py-1 text-xs font-semibold text-blue-700">
                Payment Settlement Infrastructure
              </span>

              <h1 className="mt-7 text-5xl font-bold tracking-tight text-slate-950 md:text-6xl">
                Pagamentos brasileiros conectados ao mundo.
              </h1>

              <p className="mt-6 max-w-xl text-lg leading-8 text-slate-600">
                Receba Pix, processe pagamentos e liquide em USDC através de
                uma infraestrutura construída para desenvolvedores.
              </p>

              <div className="mt-8 flex gap-3">
                <Link
                  href="/cadastro"
                  className="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white"
                >
                  Começar agora
                  <ArrowRight size={17} />
                </Link>

                <Link
                  href="/como-funciona"
                  className="rounded-lg border border-slate-200 bg-white px-5 py-3 font-semibold"
                >
                  Como funciona
                </Link>
              </div>

              <div className="mt-10 grid max-w-xl grid-cols-3 gap-5">
                <div>
                  <QrCode className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Pix
                  </p>
                </div>

                <div>
                  <Globe2 className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Global
                  </p>
                </div>

                <div>
                  <ShieldCheck className="text-blue-600" />
                  <p className="mt-2 text-sm font-semibold">
                    Seguro
                  </p>
                </div>
              </div>
            </div>

            <Card className="p-7 shadow-2xl">
              <div className="text-sm font-semibold text-slate-500">
                ViaPay Checkout
              </div>

              <div className="mt-7 rounded-2xl bg-slate-50 p-8 text-center">
                <QrCode className="mx-auto" size={170} />
                <p className="mt-5 text-2xl font-bold">R$ 100,00</p>
                <p className="mt-1 text-sm text-slate-500">
                  Pague com Pix
                </p>
              </div>

              <div className="mt-5 rounded-xl bg-blue-50 p-4">
                <p className="text-xs text-slate-500">Liquidação</p>
                <p className="font-semibold">USDC • Solana</p>
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
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { Card } from "@/components/Card";

const steps = [
  ["01", "Crie a cobrança", "Sua aplicação cria o pagamento através da API."],
  ["02", "Cliente paga", "O cliente paga normalmente utilizando Pix."],
  ["03", "Processamento", "A ViaPay processa a operação."],
  ["04", "Liquidação", "O valor é liquidado em USDC na Solana."],
];

export default function ComoFuncionaPage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="bg-blue-50 px-6 py-24 text-center">
          <h1 className="text-5xl font-bold">Como funciona</h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg text-slate-600">
            Uma infraestrutura simples na experiência e robusta por baixo.
          </p>
        </section>

        <section className="mx-auto grid max-w-6xl gap-5 px-6 py-20 md:grid-cols-4">
          {steps.map(([number, title, description]) => (
            <Card key={number} className="p-6">
              <span className="text-sm font-bold text-blue-600">{number}</span>
              <h2 className="mt-6 font-bold">{title}</h2>
              <p className="mt-2 text-sm leading-6 text-slate-500">
                {description}
              </p>
            </Card>
          ))}
        </section>
      </main>

      <Footer />
    </>
  );
}
EOF

cat > app/precos/page.tsx <<'EOF'
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { Card } from "@/components/Card";

export default function PrecosPage() {
  const plans = [
    ["Developer", "R$ 0"],
    ["Pro", "R$ 99"],
    ["Enterprise", "Sob consulta"],
  ];

  return (
    <>
      <Navbar />

      <main className="bg-slate-50 px-6 py-24">
        <div className="mx-auto max-w-6xl">
          <h1 className="text-center text-5xl font-bold">
            Preços transparentes
          </h1>

          <div className="mt-14 grid gap-6 md:grid-cols-3">
            {plans.map(([name, price]) => (
              <Card key={name} className="p-8">
                <h2 className="text-xl font-bold">{name}</h2>
                <p className="mt-6 text-4xl font-bold">{price}</p>

                <button className="mt-8 w-full rounded-lg bg-blue-600 py-3 font-semibold text-white">
                  Começar
                </button>
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
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";

export default function EmpresaPage() {
  return (
    <>
      <Navbar />

      <main>
        <section className="bg-[#07142f] px-6 py-24 text-white">
          <div className="mx-auto max-w-5xl">
            <span className="text-sm font-semibold text-cyan-400">
              VIAPAY
            </span>

            <h1 className="mt-6 text-5xl font-bold">
              Infraestrutura financeira programável.
            </h1>

            <p className="mt-6 max-w-2xl text-lg leading-8 text-slate-300">
              Construímos infraestrutura para conectar pagamentos locais,
              aplicações modernas e liquidação global.
            </p>
          </div>
        </section>
      </main>

      <Footer />
    </>
  );
}
EOF

cat > app/contato/page.tsx <<'EOF'
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { Input } from "@/components/Input";
import { Button } from "@/components/Button";
import { Card } from "@/components/Card";

export default function ContatoPage() {
  return (
    <>
      <Navbar />

      <main className="bg-slate-50 px-6 py-24">
        <Card className="mx-auto max-w-xl p-8">
          <h1 className="text-3xl font-bold">Entre em contato</h1>

          <div className="mt-8 space-y-4">
            <Input placeholder="Nome" />
            <Input placeholder="E-mail" />
            <Input placeholder="Empresa" />
            <textarea
              className="min-h-32 w-full rounded-lg border border-slate-200 p-3"
              placeholder="Mensagem"
            />
            <Button className="w-full">
              Enviar mensagem
            </Button>
          </div>
        </Card>
      </main>

      <Footer />
    </>
  );
}
EOF

cat > app/login/page.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";
import { LoginForm } from "@/components/forms/LoginForm";

export default function LoginPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6">
      <div className="w-full max-w-md rounded-2xl border bg-white p-8 shadow-sm">
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
          <Link href="/cadastro" className="font-semibold text-blue-600">
            Criar conta
          </Link>
        </p>
      </div>
    </main>
  );
}
EOF

cat > components/forms/LoginForm/LoginForm.tsx <<'EOF'
import { Input } from "@/components/Input";
import { Button } from "@/components/Button";

export function LoginForm() {
  return (
    <form className="mt-8 space-y-4">
      <Input type="email" placeholder="E-mail" />
      <Input type="password" placeholder="Senha" />

      <Button type="submit" className="w-full">
        Entrar
      </Button>
    </form>
  );
}
EOF

cat > components/forms/LoginForm/index.ts <<'EOF'
export { LoginForm } from "./LoginForm";
EOF

cat > components/forms/LoginForm/LoginForm.css <<'EOF'
.login-form {}
EOF

cat > app/cadastro/page.tsx <<'EOF'
import Link from "next/link";
import { Logo } from "@/components/Logo";
import { RegisterForm } from "@/components/forms/RegisterForm";

export default function CadastroPage() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6 py-12">
      <div className="w-full max-w-lg rounded-2xl border bg-white p-8 shadow-sm">
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
          <Link href="/login" className="font-semibold text-blue-600">
            Entrar
          </Link>
        </p>
      </div>
    </main>
  );
}
EOF

cat > components/forms/RegisterForm/RegisterForm.tsx <<'EOF'
import { Input } from "@/components/Input";
import { Button } from "@/components/Button";

export function RegisterForm() {
  return (
    <form className="mt-8 space-y-4">
      <Input placeholder="Nome completo" />
      <Input type="email" placeholder="E-mail profissional" />
      <Input placeholder="Empresa" />
      <Input type="password" placeholder="Senha" />

      <Button type="submit" className="w-full">
        Criar conta
      </Button>
    </form>
  );
}
EOF

cat > components/forms/RegisterForm/index.ts <<'EOF'
export { RegisterForm } from "./RegisterForm";
EOF

cat > components/forms/RegisterForm/RegisterForm.css <<'EOF'
.register-form {}
EOF

cat > app/dashboard/page.tsx <<'EOF'
import { DashboardShell } from "@/components/dashboard/DashboardShell";
import { StatCard } from "@/components/dashboard/StatCard";
import { Card } from "@/components/Card";

export default function DashboardPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Visão Geral</h1>
        <p className="mt-1 text-sm text-slate-500">
          Acompanhe sua operação.
        </p>
      </header>

      <div className="space-y-6 p-6">
        <div className="grid gap-5 md:grid-cols-2 xl:grid-cols-4">
          <StatCard title="Volume Processado" value="R$ 12.480,32" change="+12%" />
          <StatCard title="Pagamentos" value="128" change="+8%" />
          <StatCard title="Liquidações" value="124" change="+10%" />
          <StatCard title="USDC Recebido" value="2.548,32" change="+15%" />
        </div>

        <Card className="p-6">
          <h2 className="font-bold">Volume de pagamentos</h2>

          <div className="mt-8 flex h-64 items-end gap-2">
            {[30, 42, 38, 55, 48, 70, 61, 76, 68, 82, 75, 94].map(
              (height, index) => (
                <div
                  key={index}
                  className="flex-1 rounded-t bg-blue-500"
                  style={{ height: `${height}%` }}
                />
              ),
            )}
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
EOF

cat > app/dashboard/pagamentos/page.tsx <<'EOF'
import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell";
import { Card } from "@/components/Card";

const payments = [
  ["pay_001", "Cliente A", "R$ 100,00", "18,42 USDC"],
  ["pay_002", "Cliente B", "R$ 250,00", "46,10 USDC"],
  ["pay_003", "Cliente C", "R$ 80,00", "14,73 USDC"],
];

export default function PagamentosPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Pagamentos</h1>
      </header>

      <div className="p-6">
        <Card>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50">
                <tr>
                  <th className="px-5 py-4">ID</th>
                  <th className="px-5 py-4">Cliente</th>
                  <th className="px-5 py-4">BRL</th>
                  <th className="px-5 py-4">USDC</th>
                </tr>
              </thead>

              <tbody>
                {payments.map(([id, customer, brl, usdc]) => (
                  <tr key={id} className="border-t">
                    <td className="px-5 py-4">
                      <Link
                        href={`/dashboard/pagamentos/${id}`}
                        className="font-semibold text-blue-600"
                      >
                        {id}
                      </Link>
                    </td>
                    <td className="px-5 py-4">{customer}</td>
                    <td className="px-5 py-4">{brl}</td>
                    <td className="px-5 py-4">{usdc}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
EOF

cat > app/dashboard/pagamentos/'[id]'/page.tsx <<'EOF'
import { DashboardShell } from "@/components/dashboard/DashboardShell";
import { Card } from "@/components/Card";

export default async function PagamentoDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">
          Pagamento {id}
        </h1>
      </header>

      <div className="grid gap-6 p-6 lg:grid-cols-2">
        <Card className="p-6">
          <h2 className="font-bold">Detalhes</h2>

          <div className="mt-6 space-y-4 text-sm">
            <div className="flex justify-between">
              <span className="text-slate-500">Valor</span>
              <strong>R$ 100,00</strong>
            </div>

            <div className="flex justify-between">
              <span className="text-slate-500">USDC</span>
              <strong>18,42 USDC</strong>
            </div>

            <div className="flex justify-between">
              <span className="text-slate-500">Status</span>
              <strong className="text-emerald-600">
                Liquidado
              </strong>
            </div>
          </div>
        </Card>

        <Card className="p-6">
          <h2 className="font-bold">Timeline</h2>

          <div className="mt-6 space-y-5">
            {[
              "Pagamento criado",
              "Pix gerado",
              "Pix confirmado",
              "Conversão realizada",
              "Liquidação confirmada",
            ].map((event) => (
              <div key={event} className="flex gap-3 text-sm">
                <span className="mt-1 h-2.5 w-2.5 rounded-full bg-emerald-500" />
                {event}
              </div>
            ))}
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
EOF

for PAGE in liquidacoes carteiras webhooks documentacao configuracoes; do
cat > "app/dashboard/$PAGE/page.tsx" <<EOF
import { DashboardShell } from "@/components/dashboard/DashboardShell";
import { Card } from "@/components/Card";

export default function ${PAGE^}Page() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">${PAGE^}</h1>
        <p className="mt-1 text-sm text-slate-500">
          Gerencie sua operação ViaPay.
        </p>
      </header>

      <div className="p-6">
        <Card className="p-8">
          <h2 className="font-bold">Área ${PAGE^}</h2>
          <p className="mt-2 text-sm text-slate-500">
            Componente preparado para integração com a API ViaPay.
          </p>
        </Card>
      </div>
    </DashboardShell>
  );
}
EOF
done

cat > app/checkout/'[paymentId]'/page.tsx <<'EOF'
import { QRCode } from "@/components/checkout/QRCode";
import { PaymentSummary } from "@/components/checkout/PaymentSummary";

export default async function CheckoutPage({
  params,
}: {
  params: Promise<{ paymentId: string }>;
}) {
  const { paymentId } = await params;

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6 py-12">
      <div className="w-full max-w-md rounded-3xl border bg-white p-7 shadow-xl">
        <div className="text-center">
          <span className="font-bold text-blue-600">
            ViaPay
          </span>

          <h1 className="mt-5 text-2xl font-bold">
            Pague com Pix
          </h1>

          <p className="mt-1 text-sm text-slate-500">
            Pagamento {paymentId}
          </p>
        </div>

        <div className="mt-7 rounded-2xl bg-slate-50 p-5">
          <QRCode />
        </div>

        <div className="mt-5">
          <PaymentSummary />
        </div>
      </div>
    </main>
  );
}
EOF

cat > app/checkout/'[paymentId]'/success/page.tsx <<'EOF'
import Link from "next/link";
import { CheckCircle2 } from "lucide-react";
import { Card } from "@/components/Card";

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
EOF

echo "🧠 Criando infraestrutura..."

cat > lib/utils.ts <<'EOF'
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
EOF

cat > styles/globals.css <<'EOF'
@import "tailwindcss";

:root {
  --viapay-blue: #0b5fff;
  --viapay-primary: #2563eb;
  --viapay-cyan: #06b6d4;
  --viapay-white: #ffffff;
}

* {
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
}

body {
  margin: 0;
  background: var(--viapay-white);
  color: #0f172a;
  font-family: Arial, Helvetica, sans-serif;
}

a {
  text-decoration: none;
  color: inherit;
}
EOF

echo "⚙️ Configurando alias @/..."

node <<'NODE'
const fs = require("fs");

const file = "tsconfig.json";

if (fs.existsSync(file)) {
  const data = JSON.parse(fs.readFileSync(file, "utf8"));

  data.compilerOptions ??= {};
  data.compilerOptions.baseUrl = ".";
  data.compilerOptions.paths = {
    ...(data.compilerOptions.paths || {}),
    "@/*": ["./*"],
  };

  fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
}
NODE

echo "🔎 Verificando imports relativos..."

if grep -RInE 'from ["'\''](\./|\.\./)' app components 2>/dev/null; then
  echo "❌ Foram encontrados imports relativos."
  exit 1
fi

echo "✅ Nenhum import relativo encontrado."

echo "🧪 Executando TypeScript..."

pnpm exec tsc --noEmit

echo ""
echo "=============================================="
echo "✅ VIAPAY FRONTEND CRIADO"
echo "=============================================="
echo ""
echo "Estrutura:"
echo "  app/          → somente rotas/composição"
echo "  components/   → componentes isolados"
echo "  lib/          → utilidades"
echo "  services/     → integração futura com API"
echo "  types/        → contratos"
echo "  styles/       → estilos globais"
echo ""
echo "Imports:"
echo "  @/components/..."
echo "  @/lib/..."
echo "  @/services/..."
echo ""
echo "🚀 Para executar:"
echo ""
echo "  cd /mnt/ai-knowledge/viapay"
echo "  pnpm --filter web dev"
echo ""
echo "🌐 http://localhost:3000"
echo ""
