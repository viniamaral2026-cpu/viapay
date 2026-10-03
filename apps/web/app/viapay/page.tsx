import { Sidebar } from "../../components/viapay/sidebar";
import { Dashboard } from "../../components/viapay/dashboard";

export default function ViaPayPage() {
  return (
    <div
      style={{
        display: "flex",
        minHeight: "100vh",
        background: "#f8fafc",
      }}
    >
      <Sidebar />
      <div style={{ flex: 1 }}>
        <Dashboard />
      </div>
    </div>
  );
}
