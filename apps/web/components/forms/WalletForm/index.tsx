"use client";

import React from "react";

export interface WalletFormProps {
  className?: string;
  children?: React.ReactNode;
}

export function WalletForm({
  className = "",
  children,
}: WalletFormProps) {
  return (
    <section
      className={className}
      data-component="WalletForm"
    >
      {children}
    </section>
  );
}

export default WalletForm;
