import type { RedisClient } from "./redis-client.js";

export interface RedisHealth {
  status: "up" | "down";
  latencyMs: number;
}

export async function checkRedisHealth(
  redis: RedisClient
): Promise<RedisHealth> {
  const startedAt = Date.now();

  try {
    const response = await redis.ping();

    return {
      status: response === "PONG" ? "up" : "down",
      latencyMs: Date.now() - startedAt
    };
  } catch {
    return {
      status: "down",
      latencyMs: Date.now() - startedAt
    };
  }
}
