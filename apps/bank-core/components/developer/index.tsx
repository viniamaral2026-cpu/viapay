"use client";

import React from "react";

export interface DeveloperProps {
  className?: string;
  children?: React.ReactNode;
}

export function Developer({
  className = "",
  children,
}: DeveloperProps) {
  return (
    <section
      className={className}
      data-component="Developer"
    >
      {children}
    </section>
  );
}

export default Developer;
