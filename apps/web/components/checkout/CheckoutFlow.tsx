"use client";

import { useState } from "react";

type CheckoutStep = 1 | 2 | 3;

export function CheckoutFlow() {
  const [step, setStep] = useState<CheckoutStep>(1);

  return (
    <section className="viapay-checkout">

      <header>
        <span className={step === 1 ? "active" : ""}>
          1. Dados
        </span>

        <span className={step === 2 ? "active" : ""}>
          2. Pagamento
        </span>

        <span className={step === 3 ? "active" : ""}>
          3. Confirmação
        </span>
      </header>

      {step === 1 && (
        <section>
          <h1>Dados do cliente</h1>
          <p>
            Coleta dos dados necessários para iniciar a operação.
          </p>

          <button onClick={() => setStep(2)}>
            Continuar
          </button>
        </section>
      )}

      {step === 2 && (
        <section>
          <h1>Pagamento</h1>
          <p>
            Seleção do método e processamento da operação.
          </p>

          <button onClick={() => setStep(3)}>
            Confirmar pagamento
          </button>
        </section>
      )}

      {step === 3 && (
        <section>
          <h1>Pagamento recebido</h1>
          <p>
            A operação foi enviada para processamento.
          </p>
        </section>
      )}
    </section>
  );
}
