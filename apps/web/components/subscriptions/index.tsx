"use client";

import React from "react";

export interface SubscriptionsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Subscriptions({
  className = "",
  children,
}: SubscriptionsProps) {
  return (
    <section
      className={className}
      data-component="Subscriptions"
    >
      {children}
    </section>
  );
}

export default Subscriptions;
