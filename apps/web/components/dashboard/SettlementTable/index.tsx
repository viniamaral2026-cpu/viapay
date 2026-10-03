"use client";

import React from "react";

export interface SettlementTableProps {
  className?: string;
  children?: React.ReactNode;
}

export function SettlementTable({
  className = "",
  children,
}: SettlementTableProps) {
  return (
    <section
      className={className}
      data-component="SettlementTable"
    >
      {children}
    </section>
  );
}

export default SettlementTable;
