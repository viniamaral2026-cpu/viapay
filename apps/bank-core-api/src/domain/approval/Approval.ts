export type ApprovalStatus =
  | "PENDING"
  | "APPROVED"
  | "REJECTED"
  | "EXPIRED";

export interface Approval {
  id: string;
  operationId: string;
  requestedBy: string;
  approvedBy?: string;
  requiredLevel: string;
  status: ApprovalStatus;
  createdAt: Date;
}
