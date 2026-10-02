import * as IORedisModule from "ioredis";

interface RedisInstance {
  status: string;

  get(key: string): Promise<string | null>;

  set(
    key: string,
    value: string,
    mode?: string,
    ttl?: number
  ): Promise<unknown>;

  del(key: string): Promise<number>;

  exists(key: string): Promise<number>;

  ping(): Promise<string>;

  connect(): Promise<void>;

  quit(): Promise<string>;

  disconnect(): void;
}

interface RedisConstructor {
  new (
    url?: string,
    options?: {
      keyPrefix?: string;
      lazyConnect?: boolean;
      maxRetriesPerRequest?: number;
    }
  ): RedisInstance;
}

function resolveRedisConstructor(): RedisConstructor {
  const module = IORedisModule as unknown as {
    default?: RedisConstructor;
  };

  if (module.default) {
    return module.default;
  }

  return IORedisModule as unknown as RedisConstructor;
}

export interface RedisClientOptions {
  url?: string;
  keyPrefix?: string;
}

export class RedisClient {
  private readonly client: RedisInstance;

  constructor(options: RedisClientOptions = {}) {
    const Redis = resolveRedisConstructor();

    this.client = new Redis(
      options.url ??
        process.env.REDIS_URL ??
        "redis://127.0.0.1:6379",
      {
        keyPrefix: options.keyPrefix ?? "",
        lazyConnect: false,
        maxRetriesPerRequest: 3
      }
    );
  }

  async connect(): Promise<void> {
    if (this.client.status === "wait") {
      await this.client.connect();
    }
  }

  async get(key: string): Promise<string | null> {
    return this.client.get(key);
  }

  async set(
    key: string,
    value: string,
    ttlSeconds?: number
  ): Promise<void> {
    if (ttlSeconds !== undefined) {
      await this.client.set(
        key,
        value,
        "EX",
        ttlSeconds
      );

      return;
    }

    await this.client.set(key, value);
  }

  async del(key: string): Promise<void> {
    await this.client.del(key);
  }

  async delete(key: string): Promise<void> {
    await this.del(key);
  }

  async exists(key: string): Promise<boolean> {
    return (await this.client.exists(key)) === 1;
  }

  async ping(): Promise<string> {
    return this.client.ping();
  }

  async quit(): Promise<void> {
    if (
      this.client.status !== "end" &&
      this.client.status !== "wait"
    ) {
      await this.client.quit();
    }
  }

  async disconnect(): Promise<void> {
    if (this.client.status === "wait") {
      this.client.disconnect();
      return;
    }

    if (this.client.status !== "end") {
      await this.client.quit();
    }
  }

  async close(): Promise<void> {
    await this.disconnect();
  }

  get raw(): RedisInstance {
    return this.client;
  }
}

export function createRedisClient(
  options: RedisClientOptions = {}
): RedisClient {
  return new RedisClient(options);
}

let defaultRedisClient: RedisClient | null = null;

export function getRedis(): RedisClient {
  if (!defaultRedisClient) {
    defaultRedisClient = createRedisClient();
  }

  return defaultRedisClient;
}
