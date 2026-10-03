"use client";

import React from "react";

export interface MerchantsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Merchants({
  className = "",
  children,
}: MerchantsProps) {
  return (
    <section
      className={className}
      data-component="Merchants"
    >
      {children}
    </section>
  );
}

export default Merchants;
