"use client";

export function StatusBadge({ status }: { status: string }) {
  return (
    <span
      style={{
        display: "inline-flex",
        padding: "5px 10px",
        borderRadius: 999,
        background: "#eff6ff",
        color: "#1d4ed8",
        fontSize: 12,
        fontWeight: 700,
      }}
    >
      {status}
    </span>
  );
}
