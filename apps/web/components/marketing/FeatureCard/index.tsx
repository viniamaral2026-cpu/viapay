"use client";

import React from "react";

export interface FeatureCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function FeatureCard({
  className = "",
  children,
}: FeatureCardProps) {
  return (
    <section
      className={className}
      data-component="FeatureCard"
    >
      {children}
    </section>
  );
}

export default FeatureCard;
