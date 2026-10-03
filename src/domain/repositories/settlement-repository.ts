import type { Settlement } from "@/domain/entities/settlement.js";

export interface SettlementRepository {
  create(settlement: Settlement): Promise<Settlement>;

  findById(id: string): Promise<Settlement | null>;

  findByPaymentId(
    paymentId: string,
  ): Promise<Settlement | null>;

  findByExternalId(
    externalId: string,
  ): Promise<Settlement | null>;

  save(settlement: Settlement): Promise<Settlement>;
}
