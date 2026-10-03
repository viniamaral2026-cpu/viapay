export interface PaymentLink {
  id: string;
  name: string;
  url: string;
  status: "active" | "inactive" | "expired";
  amount?: number;
  currency: string;
  createdAt: string;
}
