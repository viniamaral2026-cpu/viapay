"use client";

import React from "react";

export interface TopbarProps {
  className?: string;
  children?: React.ReactNode;
}

export function Topbar({
  className = "",
  children,
}: TopbarProps) {
  return (
    <section
      className={className}
      data-component="Topbar"
    >
      {children}
    </section>
  );
}

export default Topbar;
