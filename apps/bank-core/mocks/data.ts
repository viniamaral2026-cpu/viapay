import type {
  Account,
  ApiApplication,
  AuditLog,
  Customer,
  FxQuote,
  LedgerEntry,
  Merchant,
  Payment,
  Settlement,
  WebhookEvent
} from "@/types/domain";

export const dashboardStats = {
  totalAccounts: 128450,
  activeCustomers: 98420,
  activeMerchants: 7310,
  paymentsToday: 18420,
  paymentVolumeToday: "R$ 12.480.392,10",
  pendingApprovals: 17,
  settlementPending: 23,
  reconciliationCases: 4
};

export const customers: Customer[] = [
  {
    id: "cus_001",
    name: "Cliente Sandbox",
    email: "cliente@example.test",
    country: "BR",
    status: "ACTIVE"
  },
  {
    id: "cus_002",
    name: "Global Test Customer",
    email: "global@example.test",
    country: "US",
    status: "ACTIVE"
  },
  {
    id: "cus_003",
    name: "Empresa Demo",
    email: "empresa@example.test",
    country: "BR",
    status: "PENDING"
  }
];

export const merchants: Merchant[] = [
  {
    id: "mrc_001",
    legalName: "Mercado Demo LTDA",
    displayName: "Mercado Demo",
    country: "BR",
    status: "ACTIVE"
  },
  {
    id: "mrc_002",
    legalName: "Global Commerce Inc.",
    displayName: "Global Commerce",
    country: "US",
    status: "ACTIVE"
  }
];

export const accounts: Account[] = [
  {
    id: "acc_001",
    customerId: "cus_001",
    type: "CHECKING",
    currency: "BRL",
    balance: "18500.00",
    availableBalance: "17200.00",
    status: "ACTIVE"
  },
  {
    id: "acc_002",
    customerId: "cus_002",
    type: "SETTLEMENT",
    currency: "USD",
    balance: "42000.00",
    availableBalance: "42000.00",
    status: "ACTIVE"
  },
  {
    id: "acc_sandbox_001",
    customerId: "cus_001",
    type: "TEST",
    currency: "BRL",
    balance: "100000.00",
    availableBalance: "100000.00",
    status: "ACTIVE"
  }
];

export const payments: Payment[] = [
  {
    id: "pi_001",
    merchantId: "mrc_001",
    amount: "109.00",
    currency: "BRL",
    status: "CONFIRMED",
    description: "Sandbox checkout",
    createdAt: "2026-10-03T10:15:00Z"
  },
  {
    id: "pi_002",
    merchantId: "mrc_001",
    amount: "249.90",
    currency: "BRL",
    status: "SETTLED",
    description: "Order #10021",
    createdAt: "2026-10-03T10:12:00Z"
  },
  {
    id: "pi_003",
    merchantId: "mrc_002",
    amount: "19.00",
    currency: "USDC",
    status: "PAYMENT_DETECTED",
    description: "Blockchain simulation",
    createdAt: "2026-10-03T10:05:00Z"
  },
  {
    id: "pi_004",
    merchantId: "mrc_001",
    amount: "1500.00",
    currency: "BRL",
    status: "REQUIRES_APPROVAL",
    description: "High value test transaction",
    createdAt: "2026-10-03T09:54:00Z"
  }
];

export const ledgerEntries: LedgerEntry[] = [
  {
    id: "le_001",
    transactionId: "tx_001",
    accountId: "acc_sandbox_001",
    direction: "DEBIT",
    amount: "109.00",
    currency: "BRL",
    createdAt: "2026-10-03T10:15:02Z"
  },
  {
    id: "le_002",
    transactionId: "tx_001",
    accountId: "acc_001",
    direction: "CREDIT",
    amount: "109.00",
    currency: "BRL",
    createdAt: "2026-10-03T10:15:02Z"
  }
];

export const settlements: Settlement[] = [
  {
    id: "set_001",
    paymentId: "pi_002",
    amount: "249.90",
    currency: "BRL",
    status: "COMPLETED",
    provider: "SANDBOX_SETTLEMENT",
    createdAt: "2026-10-03T10:30:00Z"
  },
  {
    id: "set_002",
    paymentId: "pi_003",
    amount: "19.00",
    currency: "USDC",
    status: "PROCESSING",
    provider: "SANDBOX_BLOCKCHAIN",
    createdAt: "2026-10-03T10:06:00Z"
  }
];

export const fxQuotes: FxQuote[] = [
  {
    id: "fxq_001",
    baseCurrency: "BRL",
    quoteCurrency: "USDC",
    baseAmount: "109.00",
    quoteAmount: "19.00",
    rate: "0.1743119",
    fee: "0.50",
    status: "LOCKED"
  },
  {
    id: "fxq_002",
    baseCurrency: "EUR",
    quoteCurrency: "BRL",
    baseAmount: "100.00",
    quoteAmount: "620.00",
    rate: "6.20",
    fee: "1.20",
    status: "CREATED"
  }
];

export const applications: ApiApplication[] = [
  {
    id: "app_001",
    name: "Global Commerce Sandbox",
    environment: "sandbox",
    status: "ACTIVE",
    createdAt: "2026-10-01T14:00:00Z"
  },
  {
    id: "app_002",
    name: "Bank Integration Test",
    environment: "sandbox",
    status: "ACTIVE",
    createdAt: "2026-09-28T09:00:00Z"
  }
];

export const webhookEvents: WebhookEvent[] = [
  {
    id: "evt_001",
    type: "payment.confirmed",
    status: "DELIVERED",
    attempts: 1,
    createdAt: "2026-10-03T10:15:04Z"
  },
  {
    id: "evt_002",
    type: "settlement.completed",
    status: "DELIVERED",
    attempts: 1,
    createdAt: "2026-10-03T10:30:04Z"
  },
  {
    id: "evt_003",
    type: "payment.failed",
    status: "FAILED",
    attempts: 3,
    createdAt: "2026-10-03T09:45:04Z"
  }
];

export const auditLogs: AuditLog[] = [
  {
    id: "audit_001",
    actor: "manager.demo",
    action: "PAYMENT_APPROVED",
    resource: "payment",
    resourceId: "pi_004",
    result: "SUCCESS",
    timestamp: "2026-10-03T10:01:00Z"
  },
  {
    id: "audit_002",
    actor: "operator.demo",
    action: "PAYMENT_CREATED",
    resource: "payment",
    resourceId: "pi_001",
    result: "SUCCESS",
    timestamp: "2026-10-03T10:15:00Z"
  }
];
