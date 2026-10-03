"use client";

import { Bell, HelpCircle, Search } from "lucide-react";

export function Topbar() {
  return (
    <header className="vp-topbar">
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 10,
          color: "#64748b"
        }}
      >
        <Search size={17} />

        <input
          placeholder="Pesquisar no Bank Core..."
          style={{
            border: 0,
            outline: 0,
            width: 320,
            fontSize: 14
          }}
        />
      </div>

      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 18
        }}
      >
        <HelpCircle size={19} color="#64748b" />
        <Bell size={19} color="#64748b" />

        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: 9
          }}
        >
          <div
            style={{
              width: 34,
              height: 34,
              borderRadius: "50%",
              background: "#dbeafe",
              display: "grid",
              placeItems: "center",
              color: "#1d4ed8",
              fontWeight: 800
            }}
          >
            AD
          </div>

          <div>
            <div style={{ fontSize: 13, fontWeight: 700 }}>
              Admin Demo
            </div>

            <div style={{ fontSize: 11, color: "#64748b" }}>
              Bank Administrator
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
