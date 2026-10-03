import { Card } from "@/components/Card";

export function PaymentSummary() {
  return (
    <Card className="p-6">
      <div className="flex justify-between text-sm"><span className="text-slate-500">Valor</span><strong>R$ 100,00</strong></div>
      <div className="mt-4 flex justify-between text-sm"><span className="text-slate-500">Expira em</span><strong>14:58</strong></div>
    </Card>
  );
}
