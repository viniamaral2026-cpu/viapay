export interface UnitOfWork {
  execute<T>(
    callback: (transaction: unknown) => Promise<T>,
  ): Promise<T>;
}
