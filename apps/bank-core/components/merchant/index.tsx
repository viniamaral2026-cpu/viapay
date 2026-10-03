"use client";

import React from "react";

export interface MerchantProps {
  className?: string;
  children?: React.ReactNode;
}

export function Merchant({
  className = "",
  children,
}: MerchantProps) {
  return (
    <section
      className={className}
      data-component="Merchant"
    >
      {children}
    </section>
  );
}

export default Merchant;
