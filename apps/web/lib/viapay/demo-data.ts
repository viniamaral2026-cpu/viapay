export const dashboardData = {
  balance: "R$ 1.284.530,42",
  available: "R$ 1.104.320,18",
  processing: "R$ 180.210,24",
  todayVolume: "R$ 483.920,10",
  transactions: 1284,
};

export const payments = [
  {
    id: "PAY-000001",
    customer: "Cliente Sandbox",
    merchant: "Merchant Demo",
    amount: "R$ 109,00",
    currency: "BRL",
    rail: "SANDBOX",
    status: "AUTHORIZED",
  },
  {
    id: "PAY-000002",
    customer: "Customer China",
    merchant: "Merchant Brasil",
    amount: "¥ 156,00",
    currency: "CNY",
    rail: "CROSS-BORDER",
    status: "PROCESSING",
  },
  {
    id: "PAY-000003",
    customer: "Customer UK",
    merchant: "Merchant Brasil",
    amount: "£ 20,00",
    currency: "GBP",
    rail: "THUNES",
    status: "SETTLED",
  },
];
