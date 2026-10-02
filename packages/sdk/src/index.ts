export class ViaPay {
  constructor(
    private readonly config: {
      apiKey: string;
      baseUrl?: string;
    }
  ) {}

  payments = {
    create: async (input: {
      amountBRL: number;
      merchantWallet: string;
    }) => {
      throw new Error("Not implemented");
    },

    get: async (_paymentId: string) => {
      throw new Error("Not implemented");
    }
  };
}
