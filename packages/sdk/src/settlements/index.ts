/**
 * ViaPay Public SDK boundary.
 *
 * O SDK nunca deve conter segredo privado.
 * Chaves privadas e credenciais devem permanecer
 * no ambiente seguro do cliente.
 */

export interface ViaPayClientOptions {
  baseUrl: string;
  apiKey?: string;
}

export class ViaPayClient {
  constructor(
    public readonly options: ViaPayClientOptions,
  ) {}
}
