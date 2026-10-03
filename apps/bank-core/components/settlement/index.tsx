"use client";

import React from "react";

export interface SettlementProps {
  className?: string;
  children?: React.ReactNode;
}

export function Settlement({
  className = "",
  children,
}: SettlementProps) {
  return (
    <section
      className={className}
      data-component="Settlement"
    >
      {children}
    </section>
  );
}

export default Settlement;
