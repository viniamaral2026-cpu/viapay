"use client";

import React from "react";

export interface CompanyFormProps {
  className?: string;
  children?: React.ReactNode;
}

export function CompanyForm({
  className = "",
  children,
}: CompanyFormProps) {
  return (
    <section
      className={className}
      data-component="CompanyForm"
    >
      {children}
    </section>
  );
}

export default CompanyForm;
