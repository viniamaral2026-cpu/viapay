"use client";

import React from "react";

type Props = {
  children?: React.ReactNode;
  title?: string;
};

export function WebhookTable({ children, title }: Props) {
  return (
    <section className="vp-component">
      {title && <h3>{title}</h3>}
      {children}
    </section>
  );
}
