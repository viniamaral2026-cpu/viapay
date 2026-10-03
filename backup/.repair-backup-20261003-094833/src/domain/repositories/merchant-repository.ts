import type { Merchant } from "../entities/merchant.js";

export interface MerchantRepository {
  create(merchant: Merchant): Promise<Merchant>;

  findById(id: string): Promise<Merchant | null>;

  findByDocument(document: string): Promise<Merchant | null>;

  save(merchant: Merchant): Promise<Merchant>;
}
