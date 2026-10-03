export interface ApprovalRequest {
  operationId: string;
  actorId: string;
  requiredLevel: string;
  amount: string;
  currency: string;
  reason?: string;
}
