"use client";

import React from "react";

export interface CustomersProps {
  className?: string;
  children?: React.ReactNode;
}

export function Customers({
  className = "",
  children,
}: CustomersProps) {
  return (
    <section
      className={className}
      data-component="Customers"
    >
      {children}
    </section>
  );
}

export default Customers;
