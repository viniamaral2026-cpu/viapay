"use client";

import React from "react";

export interface HeroProps {
  className?: string;
  children?: React.ReactNode;
}

export function Hero({
  className = "",
  children,
}: HeroProps) {
  return (
    <section
      className={className}
      data-component="Hero"
    >
      {children}
    </section>
  );
}

export default Hero;
