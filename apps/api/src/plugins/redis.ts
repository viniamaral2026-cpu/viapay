import fp from "fastify-plugin";

import {
  createRedisClient,
  RedisCache
} from "@viapay/infrastructure";

declare module "fastify" {
  interface FastifyInstance {
    redis: ReturnType<typeof createRedisClient>;
    cache: RedisCache;
  }
}

export default fp(
  async (app) => {
    const redis = createRedisClient();

    const cache = new RedisCache(
      redis
    );

    app.decorate(
      "redis",
      redis
    );

    app.decorate(
      "cache",
      cache
    );

    app.addHook(
      "onClose",
      async () => {
        await redis.quit();
      }
    );
  },
  {
    name: "viapay-redis"
  }
);
