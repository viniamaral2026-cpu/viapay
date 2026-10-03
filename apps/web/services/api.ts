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
