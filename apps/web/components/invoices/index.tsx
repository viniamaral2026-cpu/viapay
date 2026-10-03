"use client";

import React from "react";

export interface InvoicesProps {
  className?: string;
  children?: React.ReactNode;
}

export function Invoices({
  className = "",
  children,
}: InvoicesProps) {
  return (
    <section
      className={className}
      data-component="Invoices"
    >
      {children}
    </section>
  );
}

export default Invoices;
