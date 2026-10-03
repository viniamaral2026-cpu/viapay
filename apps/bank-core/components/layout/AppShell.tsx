import { Sidebar } from "./Sidebar";
import { Topbar } from "./Topbar";

export function AppShell({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="vp-shell">
      <Sidebar />

      <main className="vp-main">
        <Topbar />

        <section className="vp-content">
          {children}
        </section>
      </main>
    </div>
  );
}
