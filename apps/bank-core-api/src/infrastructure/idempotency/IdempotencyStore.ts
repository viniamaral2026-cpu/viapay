export interface IdempotencyRecord {
  key: string;
  operation: string;
  responseHash?: string;
  responseBody?: unknown;
  statusCode?: number;
  createdAt: Date;
  expiresAt?: Date;
}

export interface IdempotencyStore {
  get(
    key: string,
    operation: string,
  ): Promise<IdempotencyRecord | null>;

  save(
    record: IdempotencyRecord,
  ): Promise<void>;
}
