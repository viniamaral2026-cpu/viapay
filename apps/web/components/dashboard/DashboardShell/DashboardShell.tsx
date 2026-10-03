import type { ReactNode } from "react";
import { Sidebar } from "@/components/dashboard/Sidebar";

export function DashboardShell({ children }: { children: ReactNode }) {
  return <div className="min-h-screen bg-slate-50"><Sidebar /><main className="min-h-screen lg:pl-64">{children}</main></div>;
}
