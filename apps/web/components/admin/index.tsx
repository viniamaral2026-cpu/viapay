"use client";

import React from "react";

export interface AdminProps {
  className?: string;
  children?: React.ReactNode;
}

export function Admin({
  className = "",
  children,
}: AdminProps) {
  return (
    <section
      className={className}
      data-component="Admin"
    >
      {children}
    </section>
  );
}

export default Admin;
