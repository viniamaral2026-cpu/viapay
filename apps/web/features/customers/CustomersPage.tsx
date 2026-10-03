import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/DashboardShell/DashboardShell";

interface Customer {
  id: string;
  name: string;
  email: string;
  status: "active" | "inactive" | "pending";
  createdAt: string;
}

const mockCustomers: Customer[] = [
  { id: "cust_001", name: "João Silva", email: "joao@exemplo.com", status: "active", createdAt: "2024-01-10" },
  { id: "cust_002", name: "Maria Oliveira", email: "maria@exemplo.com", status: "active", createdAt: "2024-01-12" },
  { id: "cust_003", name: "Pedro Santos", email: "pedro@exemplo.com", status: "pending", createdAt: "2024-01-15" },
];

export function CustomersPage() {
  return (
    <DashboardShell>
      <header className="border-b bg-white px-6 py-5">
        <h1 className="text-2xl font-bold">Clientes</h1>
      </header>

      <div className="p-6">
        <ul>
          <li>cust_001: João Silva - active - 2024-01-10</li>
          <li>cust_002: Maria Oliveira - active - 2024-01-12</li>
          <li>cust_003: Pedro Santos - pending - 2024-01-15</li>
        </ul>
      </div>
    </DashboardShell>
  );
}
