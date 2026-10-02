import type { InputHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

type InputProps = InputHTMLAttributes<HTMLInputElement>;

export function Input({
  className,
  ...props
}: InputProps) {
  return (
    <input
      {...props}
      className={cn(
        "w-full rounded-lg border border-slate-200 bg-white px-3 py-3 text-sm outline-none transition placeholder:text-slate-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/10",
        className,
      )}
    />
  );
}
