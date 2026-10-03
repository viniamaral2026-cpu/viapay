export type PaymentStatus =
  | "pending"
  | "processing"
  | "authorized"
  | "paid"
  | "failed"
  | "cancelled"
  | "refunded"
  | "expired";

export type PaymentMethod =
  | "pix"
  | "card"
  | "bank_transfer"
  | "other";

export type Customer = {
  id: string;
  name: string;
  email?: string;
  document?: string;
  createdAt?: string;
};

export type Payment = {
  id: string;
  amount: number;
  currency: string;
  status: PaymentStatus;
  method?: PaymentMethod;
  customerId?: string;
  createdAt?: string;
};

export type WebhookEvent = {
  id: string;
  type: string;
  status: string;
  createdAt?: string;
};

export type ApiKey = {
  id: string;
  name: string;
  environment: "test" | "production";
  createdAt?: string;
};
