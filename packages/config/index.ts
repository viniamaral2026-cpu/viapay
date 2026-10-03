/**
 * Central configuration boundary.
 *
 * Não coloque segredos reais neste arquivo.
 */

export interface ViaPayConfig {
  environment: "development" | "test" | "sandbox" | "production";
  apiUrl: string;
  databaseUrl?: string;
  redisUrl?: string;
  rabbitmqUrl?: string;
}

export function loadConfig(): ViaPayConfig {
  return {
    environment:
      (process.env.NODE_ENV as ViaPayConfig["environment"]) ??
      "development",

    apiUrl:
      process.env.VIAPAY_API_URL ??
      "http://localhost:3000",
  };
}
