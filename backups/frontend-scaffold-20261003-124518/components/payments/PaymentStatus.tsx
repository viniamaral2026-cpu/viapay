interface PaymentStatusProps {
  status: string;
}

export function PaymentStatus({
  status,
}: PaymentStatusProps) {
  return (
    <span data-status={status}>
      {status}
    </span>
  );
}
