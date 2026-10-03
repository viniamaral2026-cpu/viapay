/**
 * ViaPay Domain
 *
 * Responsabilidade:
 * encapsular regras de negócio puras.
 *
 * Este módulo não deve depender de:
 * - HTTP
 * - Fastify
 * - Next.js
 * - Prisma
 * - Redis
 * - providers externos
 *
 * Dependências devem apontar para abstrações.
 */

export interface Ledger {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}
