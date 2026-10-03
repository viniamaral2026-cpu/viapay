"use client";

import React from "react";

export interface StatusBadgeProps {
  status: string;
  className?: string;
}

function normalizeStatus(status: string): string {
  return status
    .replace(/[_-]+/g, " ")
    .trim()
    .toUpperCase();
}

export function StatusBadge({
  status,
  className = "",
}: StatusBadgeProps) {
  const normalized = normalizeStatus(status);

  return (
    <span
      className={className}
      data-status={normalized}
      style={{
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "4px 10px",
        borderRadius: "999px",
        backgroundColor: "#eff6ff",
        color: "#1d4ed8",
        border: "1px solid #bfdbfe",
        fontSize: "12px",
        fontWeight: 700,
        lineHeight: 1.4,
        whiteSpace: "nowrap",
      }}
    >
      {normalized}
    </span>
  );
}

export default StatusBadge;
