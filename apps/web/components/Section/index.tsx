"use client";

import React from "react";

export interface SectionProps {
  className?: string;
  children?: React.ReactNode;
}

export function Section({
  className = "",
  children,
}: SectionProps) {
  return (
    <section
      className={className}
      data-component="Section"
    >
      {children}
    </section>
  );
}

export default Section;
