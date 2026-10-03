"use client";

import React from "react";

export interface PageHeaderProps {
  className?: string;
  children?: React.ReactNode;
}

export function PageHeader({
  className = "",
  children,
}: PageHeaderProps) {
  return (
    <section
      className={className}
      data-component="PageHeader"
    >
      {children}
    </section>
  );
}

export default PageHeader;
