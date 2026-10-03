"use client";

import React from "react";

export interface DashboardProps {
  className?: string;
  children?: React.ReactNode;
}

export function Dashboard({
  className = "",
  children,
}: DashboardProps) {
  return (
    <section
      className={className}
      data-component="Dashboard"
    >
      {children}
    </section>
  );
}

export default Dashboard;
