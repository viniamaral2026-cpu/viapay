import { randomUUID } from "node:crypto";

import { Merchant } from "../../../domain/entities/merchant.js";
import { DomainError } from "../../../domain/errors/domain-error.js";
import type { MerchantRepository } from "../../../domain/repositories/merchant-repository.js";
import type { CreateMerchantInput } from "../../dto/create-merchant.dto.js";

export class CreateMerchant {
  constructor(
    private readonly merchantRepository: MerchantRepository,
  ) {}

  async execute(input: CreateMerchantInput): Promise<Merchant> {
    const document = input.document?.trim() || null;

    if (document) {
      const existing =
        await this.merchantRepository.findByDocument(document);

      if (existing) {
        throw new DomainError(
          "A merchant with this document already exists.",
        );
      }
    }

    const merchant = Merchant.create({
      id: input.id || randomUUID(),
      name: input.name,
      document,
      wallet: input.wallet?.trim() || null,
      active: true,
    });

    return this.merchantRepository.create(merchant);
  }
}
