import type { Settlement } from "../entities/settlement.js";

export interface SettlementLockRepository {
  findByIdForUpdate(
    transaction: unknown,
    id: string,
  ): Promise<Settlement | null>;
}
