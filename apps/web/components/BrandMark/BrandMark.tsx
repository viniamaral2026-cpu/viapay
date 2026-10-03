export function BrandMark() {
  return (
    <span
      aria-label="ViaPay"
      className="relative inline-block h-9 w-9 shrink-0"
    >
      <span className="absolute left-1 top-2 h-6 w-3 -skew-x-[18deg] rounded-b-lg bg-blue-600" />
      <span className="absolute right-1 top-0 h-7 w-3 skew-x-[18deg] rounded-b-lg bg-cyan-400" />
      <span className="absolute left-3 top-2 h-5 w-2.5 -skew-x-[18deg] rounded-b-lg bg-indigo-500" />
    </span>
  );
}
