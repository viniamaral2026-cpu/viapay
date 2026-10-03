import "./globals.css";
import { BankShell } from "@/components/layout/BankShell";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>
        <BankShell>{children}</BankShell>
      </body>
    </html>
  );
}
