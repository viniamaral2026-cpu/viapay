interface PaymentStatusProps {
  status: string;
}

export function PaymentStatus({ status }: PaymentStatusProps) {
  return (
    <span className="badge badge-info">
      {status}
    </span>
  );
}
