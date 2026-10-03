"use client";

import React from "react";

export interface PaymentsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Payments({
  className = "",
  children,
}: PaymentsProps) {
  return (
    <section
      className={className}
      data-component="Payments"
    >
      {children}
    </section>
  );
}

export default Payments;
