export interface AuthorizationContext {
  userId: string;
  roles: string[];
  permissions: string[];
  attributes: Record<string, string>;
  amountMinor?: bigint;
  currency?: string;
}

export interface AuthorizationPolicy {
  permission: string;
  maximumAmountMinor?: bigint;
  requiredApprovalLevel?: string;
}
