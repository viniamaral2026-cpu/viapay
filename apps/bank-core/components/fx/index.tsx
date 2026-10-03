"use client";

import React from "react";

export interface FxProps {
  className?: string;
  children?: React.ReactNode;
}

export function Fx({
  className = "",
  children,
}: FxProps) {
  return (
    <section
      className={className}
      data-component="Fx"
    >
      {children}
    </section>
  );
}

export default Fx;
