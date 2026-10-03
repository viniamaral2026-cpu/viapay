export interface AuditEvent {
  id: string;
  actorId: string;
  action: string;
  resourceType: string;
  resourceId: string;
  before?: unknown;
  after?: unknown;
  correlationId: string;
  ipAddress?: string;
  userAgent?: string;
  createdAt: Date;
}
