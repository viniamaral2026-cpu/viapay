/**
 * ViaPay Contracts
 *
 * Contratos compartilhados entre consumidores e providers.
 *
 * Evitar colocar regras de negócio neste pacote.
 */

export interface ApiError {
  code: string;
  message: string;
  requestId?: string;
  correlationId?: string;
}

export interface ApiMeta {
  requestId: string;
  correlationId: string;
}
