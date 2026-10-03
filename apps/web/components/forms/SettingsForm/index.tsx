"use client";

import React from "react";

export interface SettingsFormProps {
  className?: string;
  children?: React.ReactNode;
}

export function SettingsForm({
  className = "",
  children,
}: SettingsFormProps) {
  return (
    <section
      className={className}
      data-component="SettingsForm"
    >
      {children}
    </section>
  );
}

export default SettingsForm;
