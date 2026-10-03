"use client";

import React from "react";

export interface LayoutProps {
  className?: string;
  children?: React.ReactNode;
}

export function Layout({
  className = "",
  children,
}: LayoutProps) {
  return (
    <section
      className={className}
      data-component="Layout"
    >
      {children}
    </section>
  );
}

export default Layout;
