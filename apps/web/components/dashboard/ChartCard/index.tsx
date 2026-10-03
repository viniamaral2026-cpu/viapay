"use client";

import React from "react";

export interface ChartCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function ChartCard({
  className = "",
  children,
}: ChartCardProps) {
  return (
    <section
      className={className}
      data-component="ChartCard"
    >
      {children}
    </section>
  );
}

export default ChartCard;
