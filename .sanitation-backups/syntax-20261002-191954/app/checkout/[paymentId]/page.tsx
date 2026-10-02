import { PaymentSummary } from "@/components/checkout/PaymentSummary/PaymentSummary;
import { QRCode } from "@/components/checkout/QRCode/QRCode;

interface CheckoutPageProps {
  params: Promise<{
    paymentId: string;
  }>;
}

export default async function CheckoutPage({
  params,
}: CheckoutPageProps) {
  const { paymentId } = await params;

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6 py-12">
      <div className="w-full max-w-md rounded-3xl border border-slate-200 bg-white p-7 shadow-xl">
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
