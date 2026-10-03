"use client";

import { dashboardData, payments } from "../../lib/viapay/demo-data";
import { StatusBadge } from "./status-badge";

function Card({
  title,
  value,
  description,
}: {
  title: string;
  value: string;
  description: string;
}) {
  return (
    <div
      style={{
        background: "#ffffff",
        border: "1px solid #e5e7eb",
        borderRadius: 14,
        padding: 20,
      }}
    >
      <div
        style={{
          color: "#64748b",
          fontSize: 13,
          fontWeight: 600,
        }}
      >
        {title}
      </div>

      <div
        style={{
          marginTop: 10,
          fontSize: 25,
          fontWeight: 800,
          color: "#0f172a",
        }}
      >
        {value}
      </div>

      <div
        style={{
          marginTop: 8,
          color: "#94a3b8",
          fontSize: 12,
        }}
      >
        {description}
      </div>
    </div>
  );
}

export function Dashboard() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: "#f8fafc",
        padding: 32,
      }}
    >
      <div
        style={{
          maxWidth: 1500,
          margin: "0 auto",
        }}
      >
        <header
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: 28,
          }}
        >
          <div>
            <h1
              style={{
                margin: 0,
                fontSize: 30,
                fontWeight: 800,
                color: "#0f172a",
              }}
            >
              Banking Console
            </h1>

            <p
              style={{
                marginTop: 8,
                color: "#64748b",
              }}
            >
              ViaPay Financial Infrastructure
            </p>
          </div>

          <div
            style={{
              padding: "8px 14px",
              borderRadius: 999,
              background: "#ecfdf5",
              color: "#047857",
              fontSize: 13,
              fontWeight: 700,
            }}
          >
            Sandbox Online
          </div>
        </header>

        <section
          style={{
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit, minmax(220px, 1fr))",
            gap: 16,
          }}
        >
          <Card
            title="Ledger Balance"
            value={dashboardData.balance}
            description="Saldo contabilizado"
          />

          <Card
            title="Available Balance"
            value={dashboardData.available}
            description="Disponível para settlement"
          />

          <Card
            title="Processing"
            value={dashboardData.processing}
            description="Transações em processamento"
          />

          <Card
            title="Today's Volume"
            value={dashboardData.todayVolume}
            description={`${dashboardData.transactions} transações`}
          />
        </section>

        <section
          style={{
            marginTop: 28,
            background: "#ffffff",
            border: "1px solid #e5e7eb",
            borderRadius: 14,
            overflow: "hidden",
          }}
        >
          <div
            style={{
              padding: 20,
              borderBottom: "1px solid #e5e7eb",
              fontWeight: 800,
              color: "#0f172a",
            }}
          >
            Recent Payments
          </div>

          <div style={{ overflowX: "auto" }}>
            <table
              style={{
                width: "100%",
                borderCollapse: "collapse",
              }}
            >
              <thead>
                <tr
                  style={{
                    textAlign: "left",
                    color: "#64748b",
                    fontSize: 12,
                  }}
                >
                  <th style={{ padding: 16 }}>Payment</th>
                  <th style={{ padding: 16 }}>Customer</th>
                  <th style={{ padding: 16 }}>Merchant</th>
                  <th style={{ padding: 16 }}>Amount</th>
                  <th style={{ padding: 16 }}>Rail</th>
                  <th style={{ padding: 16 }}>Status</th>
                </tr>
              </thead>

              <tbody>
                {payments.map((payment) => (
                  <tr
                    key={payment.id}
                    style={{
                      borderTop: "1px solid #f1f5f9",
                      fontSize: 13,
                    }}
                  >
                    <td style={{ padding: 16, fontWeight: 700 }}>
                      {payment.id}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.customer}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.merchant}
                    </td>

                    <td style={{ padding: 16, fontWeight: 700 }}>
                      {payment.amount}
                    </td>

                    <td style={{ padding: 16 }}>
                      {payment.rail}
                    </td>

                    <td style={{ padding: 16 }}>
                      <StatusBadge status={payment.status} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section
          style={{
            marginTop: 28,
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit, minmax(260px, 1fr))",
            gap: 16,
          }}
        >
          {[
            ["Payment Router", "PIX / Bank / Card / Blockchain"],
            ["FX Engine", "Multi-currency quotation"],
            ["Settlement", "Batch and real-time settlement"],
            ["Reconciliation", "Ledger versus providers"],
          ].map(([title, description]) => (
            <div
              key={title}
              style={{
                background: "#ffffff",
                border: "1px solid #e5e7eb",
                borderRadius: 14,
                padding: 20,
              }}
            >
              <div
                style={{
                  fontWeight: 800,
                  color: "#0f172a",
                }}
              >
                {title}
              </div>

              <div
                style={{
                  marginTop: 8,
                  color: "#64748b",
                  fontSize: 13,
                }}
              >
                {description}
              </div>
            </div>
          ))}
        </section>
      </div>
    </main>
  );
}
