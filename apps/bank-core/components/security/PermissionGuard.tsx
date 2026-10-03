interface PermissionGuardProps {
  permission: string;
  children: React.ReactNode;
}

export function PermissionGuard({
  permission,
  children,
}: PermissionGuardProps) {
  return (
    <div data-required-permission={permission}>
      {children}
    </div>
  );
}
