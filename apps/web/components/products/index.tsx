"use client";

import React from "react";

export interface ProductsProps {
  className?: string;
  children?: React.ReactNode;
}

export function Products({
  className = "",
  children,
}: ProductsProps) {
  return (
    <section
      className={className}
      data-component="Products"
    >
      {children}
    </section>
  );
}

export default Products;
