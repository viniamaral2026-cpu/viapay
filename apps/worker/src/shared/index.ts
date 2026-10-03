/**
 * ViaPay Worker Job Boundary.
 *
 * Workers devem ser idempotentes.
 * Jobs financeiros devem possuir correlationId
 * e mecanismos de retry controlado.
 */

export interface JobContext {
  jobId: string;
  correlationId: string;
  attempt: number;
}

export interface WorkerJob<T> {
  execute(payload: T, context: JobContext): Promise<void>;
}
