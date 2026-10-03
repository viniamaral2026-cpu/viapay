"use client";

import React from "react";

export interface PaymentStatusProps {
  className?: string;
  children?: React.ReactNode;
}

export function PaymentStatus({
  className = "",
  children,
}: PaymentStatusProps) {
  return (
    <section
      className={className}
      data-component="PaymentStatus"
    >
      {children}
    </section>
  );
}

export default PaymentStatus;
