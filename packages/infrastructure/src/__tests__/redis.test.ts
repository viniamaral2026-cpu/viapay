import {
  afterAll,
  beforeAll,
  describe,
  expect,
  it
} from "vitest";

import {
  RedisCache,
  RedisClient,
  checkRedisHealth
} from "../index.js";

describe("Redis Infrastructure", () => {
  const redis = new RedisClient({
    url: process.env.REDIS_URL ?? "redis://127.0.0.1:6379",
    keyPrefix: "viapay:test:"
  });

  const cache = new RedisCache(redis);

  beforeAll(async () => {
    await redis.connect();
  });

  afterAll(async () => {
    await redis.delete("redis-test-key");
    await redis.delete("redis-test-object");
    await redis.disconnect();
  });

  it("deve responder PONG", async () => {
    const response = await redis.ping();

    expect(response).toBe("PONG");
  });

  it("deve gravar e ler valor", async () => {
    await redis.set(
      "redis-test-key",
      "hello"
    );

    const value = await redis.get(
      "redis-test-key"
    );

    expect(value).toBe("hello");
  });

  it("deve trabalhar com cache JSON", async () => {
    const payload = {
      id: "payment_test",
      amountBRL: 49.9,
      status: "PIX_PENDING"
    };

    await cache.set(
      "redis-test-object",
      payload,
      60
    );

    const result =
      await cache.get<typeof payload>(
        "redis-test-object"
      );

    expect(result).toEqual(payload);
  });

  it("deve informar health do Redis", async () => {
    const health =
      await checkRedisHealth(redis);

    expect(health.status).toBe("up");
    expect(health.latencyMs).toBeTypeOf("number");
  });
});
