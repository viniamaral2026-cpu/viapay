interface PageHeaderProps {
  title: string;
  description?: string;
  action?: string;
}

export function PageHeader({
  title,
  description,
  action,
}: PageHeaderProps) {
  return (
    <header className="viapay-page-header">
      <div>
        <h1>{title}</h1>
        {description && <p>{description}</p>}
      </div>

      {action && (
        <button type="button">
          {action}
        </button>
      )}
    </header>
  );
}
