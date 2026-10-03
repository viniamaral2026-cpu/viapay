"use client";

import React from "react";

export interface SidebarProps {
  className?: string;
  children?: React.ReactNode;
}

export function Sidebar({
  className = "",
  children,
}: SidebarProps) {
  return (
    <section
      className={className}
      data-component="Sidebar"
    >
      {children}
    </section>
  );
}

export default Sidebar;
