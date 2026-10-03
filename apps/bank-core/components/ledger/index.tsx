"use client";

import React from "react";

export interface LedgerProps {
  className?: string;
  children?: React.ReactNode;
}

export function Ledger({
  className = "",
  children,
}: LedgerProps) {
  return (
    <section
      className={className}
      data-component="Ledger"
    >
      {children}
    </section>
  );
}

export default Ledger;
