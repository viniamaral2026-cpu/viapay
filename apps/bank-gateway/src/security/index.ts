/**
 * Security boundary.
 *
 * Princípios:
 *
 * - least privilege
 * - deny by default
 * - MFA para operações sensíveis
 * - RBAC/ABAC
 * - auditabilidade
 * - secrets fora do código
 * - validação no backend
 */

export interface SecurityContext {
  actorId: string;
  tenantId: string;
  roles: string[];
  permissions: string[];
}
