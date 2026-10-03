import type { PixCharge } from "@/domain/entities/pix-charge.js";

export interface PixChargeRepository {
  create(pixCharge: PixCharge): Promise<PixCharge>;

  findById(id: string): Promise<PixCharge | null>;

  findByPaymentId(paymentId: string): Promise<PixCharge | null>;

  findByProviderId(providerId: string): Promise<PixCharge | null>;

  save(pixCharge: PixCharge): Promise<PixCharge>;
}
