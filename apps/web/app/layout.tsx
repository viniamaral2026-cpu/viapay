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
