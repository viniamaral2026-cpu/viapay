"use client";

import React from "react";

export interface EmptyStateProps {
  className?: string;
  children?: React.ReactNode;
}

export function EmptyState({
  className = "",
  children,
}: EmptyStateProps) {
  return (
    <section
      className={className}
      data-component="EmptyState"
    >
      {children}
    </section>
  );
}

export default EmptyState;
