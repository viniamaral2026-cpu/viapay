"use client";

import React from "react";

export interface ReconciliationProps {
  className?: string;
  children?: React.ReactNode;
}

export function Reconciliation({
  className = "",
  children,
}: ReconciliationProps) {
  return (
    <section
      className={className}
      data-component="Reconciliation"
    >
      {children}
    </section>
  );
}

export default Reconciliation;
