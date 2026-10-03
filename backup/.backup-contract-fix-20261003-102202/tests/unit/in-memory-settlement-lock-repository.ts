import type { Settlement } from "@/domain/entities/settlement.js";
import type { SettlementRepository } from "@/domain/repositories/settlement-repository.js";
import type { SettlementLockRepository } from "@/domain/repositories/settlement-lock-repository.js";

export class InMemorySettlementLockRepository
  implements SettlementLockRepository
{
  constructor(
    private readonly repository: SettlementRepository,
  ) {}

  async findByIdForUpdate(
    _transaction: unknown,
    id: string,
  ): Promise<Settlement | null> {
    return this.repository.findById(id);
  }

  async save(
    settlement: Settlement,
  ): Promise<Settlement> {
    return this.repository.save(settlement);
  }
}
