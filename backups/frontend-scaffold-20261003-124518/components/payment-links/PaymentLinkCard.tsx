interface PaymentLinkCardProps {
  name: string;
  status: string;
  url: string;
}

export function PaymentLinkCard({
  name,
  status,
  url,
}: PaymentLinkCardProps) {
  return (
    <article>
      <h3>{name}</h3>
      <p>Status: {status}</p>
      <code>{url}</code>
    </article>
  );
}
