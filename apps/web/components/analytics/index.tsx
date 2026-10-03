"use client";

import React from "react";

export interface AnalyticsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Analytics({
  className = "",
  children,
}: AnalyticsProps) {
  return (
    <section
      className={className}
      data-component="Analytics"
    >
      {children}
    </section>
  );
}

export default Analytics;
