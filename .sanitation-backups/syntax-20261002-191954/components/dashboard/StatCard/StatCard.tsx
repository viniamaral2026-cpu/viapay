import { Card } from "@/components/Card/Card;

interface StatCardProps {
  title: string;
  value: string;
  change: string;
}

export function StatCard({
  title,
  value,
  change,
}: StatCardProps) {
  return (
    <Card className="p-5">
      <p className="text-sm text-slate-500">
        {title}
      </p>

      <div className="mt-3 flex items-end justify-between gap-4">
        <strong className="text-2xl text-slate-950">
          {value}
        </strong>

        <span className="text-xs font-semibold text-emerald-600">
          {change}
        </span>
      </div>
    </Card>
  );
}
