"use client";

import React from "react";

export interface SandboxProps {
  className?: string;
  children?: React.ReactNode;
}

export function Sandbox({
  className = "",
  children,
}: SandboxProps) {
  return (
    <section
      className={className}
      data-component="Sandbox"
    >
      {children}
    </section>
  );
}

export default Sandbox;
