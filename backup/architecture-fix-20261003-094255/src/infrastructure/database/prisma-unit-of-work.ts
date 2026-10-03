import { db } from "../../prisma/db.js";
import type { UnitOfWork } from "../../domain/repositories/unit-of-work.js";

export class PrismaUnitOfWork
  implements UnitOfWork
{
  async execute<T>(
    callback: (transaction: unknown) => Promise<T>,
  ): Promise<T> {
    return db.$transaction(
      async (tx) => callback(tx),
      {
        maxWait: 10_000,
        timeout: 30_000,
      },
    );
  }
}
