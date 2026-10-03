"use client";

import React from "react";

export interface SuccessCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function SuccessCard({
  className = "",
  children,
}: SuccessCardProps) {
  return (
    <section
      className={className}
      data-component="SuccessCard"
    >
      {children}
    </section>
  );
}

export default SuccessCard;
