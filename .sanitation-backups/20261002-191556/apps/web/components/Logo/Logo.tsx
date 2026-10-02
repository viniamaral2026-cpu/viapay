import Link from "next/link";
import { BrandMark } from "@/components/BrandMark";

export function Logo() {
  return (
    <Link
      href="/"
      className="inline-flex items-center gap-2"
      aria-label="ViaPay"
    >
      <BrandMark />

      <span className="text-xl font-bold tracking-tight text-slate-950">
        ViaPay
      </span>
    </Link>
  );
}
