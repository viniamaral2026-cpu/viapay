"use client";

import React from "react";

export interface PixProps {
  className?: string;
  children?: React.ReactNode;
}

export function Pix({
  className = "",
  children,
}: PixProps) {
  return (
    <section
      className={className}
      data-component="Pix"
    >
      {children}
    </section>
  );
}

export default Pix;
