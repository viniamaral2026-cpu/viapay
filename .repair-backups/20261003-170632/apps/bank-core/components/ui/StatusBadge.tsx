export function StatusBadge({
  status
}: {
  status: string;
}) {
  const normalized = status.toUpperCase();

  let className = "vp-badge-info";

  if (
    [
      "ACTIVE",
      "COMPLETED",
      "CONFIRMED",
      "SETTLED",
      "DELIVERED",
      "SUCCESS",
      "APPROVED"
    ].includes(normalized)
  ) {
    className = "vp-badge-success";
  }

  if (
    [
      "PENDING",
      "PROCESSING",
      "CREATED",
      "REQUIRES_APPROVAL",
      "LOCKED"
    ].includes(normalized)
  ) {
    className = "vp-badge-warning";
  }

  if (
    [
      "FAILED",
      "BLOCKED",
      "CANCELLED",
      "EXPIRED",
      "DENIED",
      "SUSPENDED"
    ].includes(normalized)
  ) {
    className = "vp-badge-danger";
  }

  return (
    <span className={
