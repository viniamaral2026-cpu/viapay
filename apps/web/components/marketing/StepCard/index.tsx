"use client";

import React from "react";

export interface StepCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function StepCard({
  className = "",
  children,
}: StepCardProps) {
  return (
    <section
      className={className}
      data-component="StepCard"
    >
      {children}
    </section>
  );
}

export default StepCard;
