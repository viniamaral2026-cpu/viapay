"use client";

import React from "react";

export interface IntegrationsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Integrations({
  className = "",
  children,
}: IntegrationsProps) {
  return (
    <section
      className={className}
      data-component="Integrations"
    >
      {children}
    </section>
  );
}

export default Integrations;
