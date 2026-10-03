export function PageHeader({
  title,
  description,
  action
}: {
  title: string;
  description: string;
  action?: React.ReactNode;
}) {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "flex-start",
        marginBottom: 24,
        gap: 20
      }}
    >
      <div>
        <h1 className="vp-title">{title}</h1>
        <p className="vp-subtitle">{description}</p>
      </div>

      {action}
    </div>
  );
}
