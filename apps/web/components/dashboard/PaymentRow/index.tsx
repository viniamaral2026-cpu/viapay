"use client";

import React from "react";

export interface PaymentRowProps {
  className?: string;
  children?: React.ReactNode;
}

export function PaymentRow({
  className = "",
  children,
}: PaymentRowProps) {
  return (
    <section
      className={className}
      data-component="PaymentRow"
    >
      {children}
    </section>
  );
}

export default PaymentRow;
