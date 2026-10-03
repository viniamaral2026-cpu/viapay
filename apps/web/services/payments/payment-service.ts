export interface CreatePaymentInput {
  amount: number;
  currency: string;
  customerId?: string;
  paymentMethod: string;
}

export interface Payment {
  id: string;
  status: string;
  amount: number;
  currency: string;
}

export async function createPayment(
  input: CreatePaymentInput,
): Promise<Payment> {
  const response = await fetch("/api/payments", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(input),
  });

  if (!response.ok) {
    throw new Error("Não foi possível criar o pagamento.");
  }

  return response.json();
}
