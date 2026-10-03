interface MetricCardProps {
  label: string;
  value: string;
  description?: string;
}

export function MetricCard({
  label,
  value,
  description,
}: MetricCardProps) {
  return (
    <article className="viapay-metric-card">
      <span>{label}</span>
      <strong>{value}</strong>
      {description && <small>{description}</small>}
    </article>
  );
}
