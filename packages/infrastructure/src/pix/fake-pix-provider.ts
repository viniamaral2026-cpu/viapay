import type {
  CreatePixChargeInput,
  PixCharge,
  PixProvider
} from "@viapay/application";

export class FakePixProvider implements PixProvider {
  async createCharge(
    input: CreatePixChargeInput
  ): Promise<PixCharge> {
    return {
      id: `pix_${input.paymentId}`,
      qrCode: `VIAPAY-PIX-${input.paymentId}`,
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }
}
