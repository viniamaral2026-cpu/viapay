"use client";

import React from "react";

export interface ModalProps {
  className?: string;
  children?: React.ReactNode;
}

export function Modal({
  className = "",
  children,
}: ModalProps) {
  return (
    <section
      className={className}
      data-component="Modal"
    >
      {children}
    </section>
  );
}

export default Modal;
