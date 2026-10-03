"use client";

import React from "react";

export interface PaymentTableProps {
  className?: string;
  children?: React.ReactNode;
}

export function PaymentTable({
  className = "",
  children,
}: PaymentTableProps) {
  return (
    <section
      className={className}
      data-component="PaymentTable"
    >
      {children}
    </section>
  );
}

export default PaymentTable;
