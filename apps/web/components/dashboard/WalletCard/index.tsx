"use client";

import React from "react";

export interface WalletCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function WalletCard({
  className = "",
  children,
}: WalletCardProps) {
  return (
    <section
      className={className}
      data-component="WalletCard"
    >
      {children}
    </section>
  );
}

export default WalletCard;
