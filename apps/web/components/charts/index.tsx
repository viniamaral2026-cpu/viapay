"use client";

import React from "react";

export interface ChartsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Charts({
  className = "",
  children,
}: ChartsProps) {
  return (
    <section
      className={className}
      data-component="Charts"
    >
      {children}
    </section>
  );
}

export default Charts;
