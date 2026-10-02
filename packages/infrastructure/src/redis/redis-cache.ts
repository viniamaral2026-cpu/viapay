import type { Cache } from "@viapay/application";
import type { RedisClient } from "./redis-client.js";

export class RedisCache implements Cache {
  constructor(
    private readonly redis: RedisClient
  ) {}

  async get<T = unknown>(
    key: string
  ): Promise<T | null> {
    const value = await this.redis.get(key);

    if (value === null) {
      return null;
    }

    try {
      return JSON.parse(value) as T;
    } catch {
      return value as T;
    }
  }

  async set<T = unknown>(
    key: string,
    value: T,
    ttlSeconds?: number
  ): Promise<void> {
    await this.redis.set(
      key,
      JSON.stringify(value),
      ttlSeconds
    );
  }

  async delete(key: string): Promise<void> {
    await this.redis.delete(key);
  }

  async exists(key: string): Promise<boolean> {
    return this.redis.exists(key);
  }
}
