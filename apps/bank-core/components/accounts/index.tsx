"use client";

import React from "react";

export interface AccountsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Accounts({
  className = "",
  children,
}: AccountsProps) {
  return (
    <section
      className={className}
      data-component="Accounts"
    >
      {children}
    </section>
  );
}

export default Accounts;
