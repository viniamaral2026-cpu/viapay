"use client";

import React from "react";

export interface HeaderProps {
  className?: string;
  children?: React.ReactNode;
}

export function Header({
  className = "",
  children,
}: HeaderProps) {
  return (
    <section
      className={className}
      data-component="Header"
    >
      {children}
    </section>
  );
}

export default Header;
