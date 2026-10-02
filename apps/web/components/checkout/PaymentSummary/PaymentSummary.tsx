import { Card } from "@/components/Card/Card";

export function PaymentSummary() {
  return (
    <Card className="p-5">
      <div className="flex justify-between text-sm">
        <span className="text-slate-500">
          Valor
        </span>

        <strong>R$ 100,00</strong>
      </div>

      <div className="mt-4 flex justify-between text-sm">
        <span className="text-slate-500">
          Liquidação
        </span>

        <strong>USDC / Solana</strong>
      </div>
    </Card>
  );
}
