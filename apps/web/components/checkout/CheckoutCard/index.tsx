"use client";

import React from "react";

export interface CheckoutCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function CheckoutCard({
  className = "",
  children,
}: CheckoutCardProps) {
  return (
    <section
      className={className}
      data-component="CheckoutCard"
    >
      {children}
    </section>
  );
}

export default CheckoutCard;
