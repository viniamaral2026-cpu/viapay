export interface CreateMerchantInput {
  id: string;
  name: string;
  document?: string | null;
  wallet?: string | null;
}
