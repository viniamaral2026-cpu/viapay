import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell";
import { Card } from "@/components/Card/Card";

export function CheckoutPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Checkout</h1>
      </header>

      <div className="p-6">
        <Card>
          <h2>Finalizar Compra</h2>
          <p>Selecione o método de pagamento</p>

          <div className="space-y-4">
            <div>
              <h3>PIX</h3>
              <p>QR Code e Copia e Cola</p>
              <button className="vp-button vp-button-primary">Gerar Cobrança</button>
            </div>

            <div>
              <h3>Cartão de Crédito</h3>
              <p>Parcelamento em até 12x</p>
              <button className="vp-button vp-button-primary">Pagar com Cartão</button>
            </div>

            <div>
              <h3>Transferência Bancária</h3>
              <p>Dados para PAGAMENTO</p>
              <button className="vp-button vp-button-primary">Confirmar Transferência</button>
            </div>
          </div>
        </Card>
      </div>
    </DashboardShell>
  );
}
