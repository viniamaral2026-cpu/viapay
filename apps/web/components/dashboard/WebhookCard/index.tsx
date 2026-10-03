"use client";

import React from "react";

export interface WebhookCardProps {
  className?: string;
  children?: React.ReactNode;
}

export function WebhookCard({
  className = "",
  children,
}: WebhookCardProps) {
  return (
    <section
      className={className}
      data-component="WebhookCard"
    >
      {children}
    </section>
  );
}

export default WebhookCard;
