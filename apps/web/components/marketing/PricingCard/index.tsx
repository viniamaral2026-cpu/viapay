"use client";

import React from "react";

export interface PricingCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function PricingCard({
  className = "",
  children,
}: PricingCardProps) {
  return (
    <section
      className={className}
      data-component="PricingCard"
    >
      {children}
    </section>
  );
}

export default PricingCard;
