"use client";

import React from "react";

export interface NavigationProps {
  className?: string;
  children?: React.ReactNode;
}

export function Navigation({
  className = "",
  children,
}: NavigationProps) {
  return (
    <section
      className={className}
      data-component="Navigation"
    >
      {children}
    </section>
  );
}

export default Navigation;
