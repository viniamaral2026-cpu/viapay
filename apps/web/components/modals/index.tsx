"use client";

import React from "react";

export interface ModalsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Modals({
  className = "",
  children,
}: ModalsProps) {
  return (
    <section
      className={className}
      data-component="Modals"
    >
      {children}
    </section>
  );
}

export default Modals;
