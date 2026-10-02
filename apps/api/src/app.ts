import Fastify, {
  type FastifyInstance
} from "fastify";

import cors from "@fastify/cors";
import helmet from "@fastify/helmet";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";

import { paymentRoutes } from "./routes/payment-routes.js";
import { openApiSchemas } from "./openapi.js";
import redisPlugin from "./plugins/redis.js";

export function buildApp(): FastifyInstance {
  const app = Fastify({
    logger: true
  });

  void app.register(cors);

  void app.register(helmet);

  void app.register(redisPlugin);

  void app.register(swagger, {
    openapi: {
      openapi: "3.0.3",

      info: {
        title: "ViaPay API",
        description: "API de pagamentos da ViaPay",
        version: "1.0.0"
      },

      servers: [
        {
          url: "http://localhost:3001",
          description: "Local"
        }
      ],

      tags: [
        {
          name: "Health",
          description: "Health checks"
        },
        {
          name: "Payments",
          description: "Payment operations"
        }
      ]
    }
  });

  void app.register(swaggerUi, {
    routePrefix: "/docs"
  });

  for (const schema of Object.values(openApiSchemas)) {
    app.addSchema(schema);
  }

  app.get(
    "/health",
    {
      schema: {
        tags: ["Health"],
        summary: "Health check",

        response: {
          200: {
            $ref: "HealthResponse#"
          }
        }
      }
    },

    async () => {
      return {
        status: "ok",
        service: "viapay-api"
      };
    }
  );

  void app.register(paymentRoutes);

  return app;
}
