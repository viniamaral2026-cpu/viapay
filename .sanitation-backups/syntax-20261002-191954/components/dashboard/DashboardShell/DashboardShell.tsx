import type { ReactNode } from "react";
import { Sidebar } from "@/components/dashboard/Sidebar/Sidebar;

interface DashboardShellProps {
  children: ReactNode;
}

export function DashboardShell({
  children,
}: DashboardShellProps) {
  return (
    <div className="min-h-screen bg-slate-50">
      <Sidebar />

      <main className="min-h-screen lg:pl-64">
        {children}
      </main>
    </div>
  );
}
