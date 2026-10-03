# ViaPay

Plataforma de pagamentos e infraestrutura financeira construída com arquitetura modular, princípios de Clean Architecture, separação de responsabilidades e componentes preparados para evolução para ambientes distribuídos.

O ViaPay foi estruturado como um monorepo TypeScript com separação explícita entre domínio, aplicação, infraestrutura, contratos, SDK e API.

---

## Status do Projeto

> **Status:** Em desenvolvimento ativo

A infraestrutura principal da API já possui:

- API HTTP baseada em Fastify
- Health Check
- Documentação OpenAPI/Swagger
- CORS
- Helmet
- Redis
- Camada de cache
- Infraestrutura de pagamentos em memória
- Fake PIX Provider para desenvolvimento
- Casos de uso de pagamentos
- PostgreSQL preparado para integração
- Solana/USDC preparado para integração
- Arquitetura modular em monorepo
- TypeScript strict-ready
- Testes automatizados com Vitest

### Validações atuais

A infraestrutura Redis foi validada com sucesso:

```text
PING: PONG
GET: OK
EXISTS: true
AFTER DELETE: null
REDIS TEST: OK

A API também foi validada:

GET /health
HTTP/1.1 200 OK
1. Visão Geral

O ViaPay tem como objetivo fornecer uma infraestrutura de pagamentos modular, extensível e preparada para integração com diferentes provedores financeiros.

A arquitetura foi projetada para permitir que regras de negócio permaneçam independentes de:

banco de dados;
Redis;
APIs externas;
provedores PIX;
blockchain;
infraestrutura HTTP;
mecanismos de cache;
serviços externos.

A aplicação segue o princípio:

Domain
   ↓
Application
   ↓
Infrastructure
   ↓
API

As dependências devem apontar para abstrações e contratos, evitando acoplamento direto entre regras de negócio e infraestrutura.

2. Objetivos Arquiteturais

Os principais objetivos do projeto são:

Alta coesão;
Baixo acoplamento;
Separação de responsabilidades;
Testabilidade;
Evolução incremental;
Substituição de provedores;
Isolamento de infraestrutura;
Segurança;
Observabilidade;
Escalabilidade horizontal;
Compatibilidade com ambientes distribuídos.

A arquitetura deve permitir substituir componentes sem alterar as regras centrais de negócio.

Exemplo:

PIX Provider
     │
     ├── Banco A
     ├── Banco B
     ├── Banco C
     └── Mock/Fake

O domínio não deve conhecer nenhum desses provedores.

3. Stack Tecnológica
Runtime
Node.js
TypeScript
pnpm
API
Fastify
@fastify/cors
@fastify/helmet
@fastify/swagger
@fastify/swagger-ui
Persistência
PostgreSQL
Cache / Infraestrutura
Redis
ioredis
Blockchain
Solana Web3.js
SPL Token
Testes
Vitest
Arquitetura
Clean Architecture
DDD
Ports & Adapters
Dependency Inversion
Separation of Concerns
4. Estrutura do Monorepo
viapay/
│
├── apps/
│   │
│   └── api/
│       ├── src/
│       │   ├── app.ts
│       │   ├── server.ts
│       │   │
│       │   ├── composition/
│       │   │   └── container.ts
│       │   │
│       │   ├── controllers/
│       │   │   └── payment-controller.ts
│       │   │
│       │   ├── plugins/
│       │   │   └── redis.ts
│       │   │
│       │   ├── routes/
│       │   │   └── payment-routes.ts
│       │   │
│       │   ├── openapi.ts
│       │   │
│       │   └── __tests__/
│       │       └── payments.test.ts
│       │
│       ├── package.json
│       └── tsconfig.json
│
├── packages/
│   │
│   ├── application/
│   │   ├── src/
│   │   │   ├── payment/
│   │   │   │   ├── ports/
│   │   │   │   ├── use-cases/
│   │   │   │   └── __tests__/
│   │   │   │
│   │   │   └── ports/
│   │   │       └── cache.ts
│   │   │
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   ├── domain/
│   │   ├── src/
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   ├── infrastructure/
│   │   ├── src/
│   │   │   ├── payment/
│   │   │   │   └── in-memory-payment-repository.ts
│   │   │   │
│   │   │   ├── pix/
│   │   │   │   └── fake-pix-provider.ts
│   │   │   │
│   │   │   ├── redis/
│   │   │   │   ├── redis-cache.ts
│   │   │   │   ├── redis-client.ts
│   │   │   │   ├── redis-health.ts
│   │   │   │   └── index.ts
│   │   │   │
│   │   │   └── __tests__/
│   │   │       └── redis.test.ts
│   │   │
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   ├── contracts/
│   │   ├── src/
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   ├── sdk/
│   │   ├── src/
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── shared/
│       ├── src/
│       ├── package.json
│       └── tsconfig.json
│
├── .env.example
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
└── README.md
5. Arquitetura

A aplicação é organizada em camadas.

Domain

Responsável pelas regras fundamentais do negócio.

O Domain não deve depender de:

Fastify;
Redis;
PostgreSQL;
ioredis;
HTTP;
SDKs externos.

Exemplo conceitual:

Domain
 ├── Entities
 ├── Value Objects
 ├── Domain Services
 ├── Domain Errors
 └── Business Rules
Application

Contém os casos de uso da aplicação.

Exemplos atuais:

CreatePayment
GetPayment
HandlePixPayment

Os casos de uso coordenam as operações necessárias para executar uma determinada ação do sistema.

Exemplo:

Controller
    ↓
Use Case
    ↓
Port
    ↓
Infrastructure Adapter
Infrastructure

Implementa os contratos definidos pelas camadas superiores.

Atualmente inclui:

Redis
Payment Repository
PIX Provider
Solana

Exemplo:

Application
     │
     │ PaymentRepository
     ▼
Infrastructure
     │
     └── InMemoryPaymentRepository

O repositório em memória pode posteriormente ser substituído por PostgreSQL sem alterar o caso de uso.

API

A API é responsável por:

HTTP;
rotas;
controllers;
plugins;
autenticação futura;
validação de requests;
serialização;
documentação OpenAPI;
integração das dependências.

A API não deve conter regras complexas de negócio.

6. Dependency Rule

As dependências devem respeitar a direção arquitetural:

              ┌─────────────┐
              │   DOMAIN    │
              └──────┬──────┘
                     │
                     ▼
              ┌─────────────┐
              │ APPLICATION │
              └──────┬──────┘
                     │
             ┌───────┴────────┐
             ▼                ▼
       Infrastructure        API

A infraestrutura pode implementar contratos da aplicação.

O domínio não deve depender da infraestrutura.

7. Redis

O Redis é utilizado como infraestrutura de cache e pode futuramente suportar:

cache;
idempotência;
locks distribuídos;
sessões;
rate limiting;
filas auxiliares;
controle temporário de estados.

A integração está encapsulada em:

packages/infrastructure/src/redis/

Principais componentes:

RedisClient
RedisCache
checkRedisHealth
createRedisClient
getRedis
8. Redis Client

O RedisClient encapsula o acesso ao Redis.

Operações disponíveis:

connect()
get()
set()
del()
delete()
exists()
ping()
quit()
disconnect()
close()

Exemplo:

const redis = createRedisClient({
  keyPrefix: "viapay:"
});

await redis.set(
  "payment:123",
  JSON.stringify(payment),
  60
);

const value = await redis.get(
  "payment:123"
);

await redis.quit();
9. Redis Cache

A abstração RedisCache implementa o contrato de cache definido pela aplicação.

Operações:

get()
set()
delete()
exists()

O cache suporta valores serializados em JSON.

Exemplo:

await cache.set(
  "payment:123",
  {
    id: "123",
    status: "pending"
  },
  60
);

const payment =
  await cache.get("payment:123");
10. Redis Health Check

A infraestrutura possui verificação de disponibilidade do Redis.

O resultado possui o formato:

{
  status: "up",
  latencyMs: 2
}

Ou:

{
  status: "down",
  latencyMs: 10
}

Isso permite integrar o Redis posteriormente ao sistema de health checks e observabilidade.

11. PostgreSQL

O PostgreSQL é o banco de dados relacional previsto para persistência principal.

Configuração:

DATABASE_URL=postgresql://viapay:viapay@localhost:5432/viapay

Verificação local:

pg_isready

Resultado esperado:

/var/run/postgresql:5432 - accepting connections

A persistência definitiva deve substituir progressivamente os repositórios em memória.

12. API

A API utiliza Fastify.

Inicialização:

apps/api/src/server.ts

Construção da aplicação:

apps/api/src/app.ts

A aplicação atualmente utiliza:

Fastify;
CORS;
Helmet;
Swagger;
Swagger UI;
Redis Plugin;
Payment Routes.
13. Health Check

Endpoint:

GET /health

Exemplo:

curl -i http://127.0.0.1:3001/health

Resposta esperada:

HTTP/1.1 200 OK
Content-Type: application/json

Payload:

{
  "status": "ok",
  "service": "viapay-api"
}
14. API Documentation

A documentação OpenAPI é disponibilizada através do Swagger UI.

Endpoint:

/docs

Localmente:

http://localhost:3001/docs

A especificação é registrada em:

apps/api/src/openapi.ts
15. Payments

O módulo de pagamentos está organizado em:

packages/application/src/payment/

Incluindo casos de uso:

CreatePayment
GetPayment
HandlePixPayment

Ports:

PaymentRepository
PixProvider
ExchangeProvider
SolanaProvider

Essa abordagem permite substituir implementações sem alterar os casos de uso.

16. Payment Repository

O projeto atualmente possui uma implementação em memória:

InMemoryPaymentRepository

Localização:

packages/infrastructure/src/payment/

Ela é adequada para:

desenvolvimento;
testes;
prototipação;
testes de integração controlados.

Para produção, deverá ser implementado um repositório persistente baseado em PostgreSQL.

17. PIX

A arquitetura possui uma abstração:

PixProvider

e uma implementação fake:

FakePixProvider

Isso permite desenvolver os casos de uso sem depender imediatamente de um provedor financeiro externo.

Posteriormente:

PixProvider
      │
      ├── FakePixProvider
      ├── Provider A
      ├── Provider B
      └── Provider C
18. Solana

A infraestrutura inclui dependências para integração com Solana:

@solana/web3.js
@solana/spl-token

Configuração prevista:

SOLANA_RPC=https://api.devnet.solana.com
SOLANA_NETWORK=devnet
SOLANA_TREASURY_PUBLIC_KEY=
SOLANA_TREASURY_SECRET=
USDC_MINT_DEVNET=

O ambiente padrão de desenvolvimento utiliza:

devnet

Chaves privadas nunca devem ser versionadas.

19. Environment Variables

Arquivo de referência:

.env.example

Configuração atual:

NODE_ENV=development

DATABASE_URL=postgresql://viapay:viapay@localhost:5432/viapay

API_PORT=3001

PIX_API_KEY=
PIX_API_URL=

SOLANA_RPC=https://api.devnet.solana.com
SOLANA_NETWORK=devnet
SOLANA_TREASURY_PUBLIC_KEY=
SOLANA_TREASURY_SECRET=
USDC_MINT_DEVNET=

EXCHANGE_RATE_PROVIDER=
EXCHANGE_RATE_API_KEY=

WEBHOOK_BASE_URL=

NEXT_PUBLIC_API_URL=http://localhost:3001

Em produção, utilizar gerenciamento seguro de secrets.

Nunca versionar:

.env
.env.local
.env.production
private keys
API keys
tokens
credentials
20. Instalação

Requisitos:

Node.js
pnpm
PostgreSQL
Redis

Verificar Node:

node --version

Verificar pnpm:

pnpm --version

Instalar dependências:

pnpm install
21. Infraestrutura Local
PostgreSQL

Verificar:

pg_isready

Esperado:

accepting connections
Redis

Verificar:

redis-cli ping

Esperado:

PONG

Verificar versão:

redis-cli INFO server | grep -E 'redis_version|redis_mode'
22. Build

Build da aplicação:

pnpm --filter @viapay/application build

Build da infraestrutura:

pnpm --filter @viapay/infrastructure build

Build da API:

pnpm --filter api build
23. Typecheck

Application:

pnpm --filter @viapay/application typecheck

Infrastructure:

pnpm --filter @viapay/infrastructure typecheck

API:

pnpm --filter api typecheck

O projeto deve ser considerado pronto para commit somente quando o typecheck estiver limpo.

24. Testes

Executar testes da infraestrutura:

pnpm --filter @viapay/infrastructure test

Os testes utilizam:

Vitest

Exemplo de teste de integração Redis:

PING
GET
SET
EXISTS
DELETE
QUIT
25. Executando a API

Build:

pnpm --filter api build

Inicialização:

pnpm --filter api start

A API utiliza a porta:

3001

Endpoint:

http://localhost:3001

Health:

http://localhost:3001/health

Swagger:

http://localhost:3001/docs
26. Verificação da Porta

Para verificar se a API está executando:

ss -lntp | grep ':3001'

Exemplo:

LISTEN 0 511 0.0.0.0:3001

Se aparecer:

EADDRINUSE

significa que a porta 3001 já está sendo utilizada por outro processo.

Verificar:

ss -lntp | grep ':3001'

Não iniciar uma segunda instância na mesma porta.

27. Teste Manual da API

Health:

curl -i \
  http://127.0.0.1:3001/health

Teste de pagamento inexistente:

curl -i \
  http://127.0.0.1:3001/payments/payment_123

Um pagamento inexistente deve retornar um erro de recurso não encontrado conforme o contrato da API.

28. Teste Manual do Redis

Executar:

node --input-type=module <<'EOF'
import {
  createRedisClient
} from "./packages/infrastructure/dist/index.js";

const redis = createRedisClient({
  keyPrefix: "viapay:test:"
});

console.log(
  "PING:",
  await redis.ping()
);

await redis.set(
  "connection-test",
  "OK",
  60
);

console.log(
  "GET:",
  await redis.get("connection-test")
);

console.log(
  "EXISTS:",
  await redis.exists("connection-test")
);

await redis.delete(
  "connection-test"
);

console.log(
  "AFTER DELETE:",
  await redis.get("connection-test")
);

await redis.quit();

console.log(
  "REDIS TEST: OK"
);
EOF

Resultado esperado:

PING: PONG
GET: OK
EXISTS: true
AFTER DELETE: null
REDIS TEST: OK
29. Desenvolvimento

Fluxo recomendado:

1. Alterar código
2. Executar typecheck
3. Executar testes
4. Executar build
5. Executar testes de integração
6. Revisar git diff
7. Commit
8. Push

Comandos:

pnpm --filter @viapay/application typecheck
pnpm --filter @viapay/infrastructure typecheck
pnpm --filter api typecheck

Depois:

pnpm --filter @viapay/infrastructure test

E:

pnpm --filter @viapay/application build
pnpm --filter @viapay/infrastructure build
pnpm --filter api build
30. Git Workflow

Verificar alterações:

git status

Adicionar arquivos:

git add -A

Criar commit:

git commit -m "feat: implement payment infrastructure"

Enviar:

git push origin main

Verificar histórico:

git log --oneline -10
31. Segurança

Segurança é requisito arquitetural do ViaPay.

Nunca armazenar no Git:

senhas;
API keys;
tokens;
secrets;
chaves privadas;
credenciais bancárias;
private keys de blockchain.

A chave:

SOLANA_TREASURY_SECRET=

deve permanecer exclusivamente no ambiente seguro de execução.

32. Idempotência

Operações financeiras devem ser projetadas para suportar idempotência.

Operações como:

CreatePayment
PIX charge creation
Webhook processing
Settlement

não devem gerar efeitos financeiros duplicados quando a mesma requisição for processada mais de uma vez.

Redis poderá ser utilizado futuramente como mecanismo auxiliar de idempotência distribuída.

33. Webhooks

A arquitetura prevê integração com webhooks de provedores externos.

O fluxo recomendado é:

Provider
   │
   ▼
Webhook API
   │
   ▼
Validation
   │
   ▼
Idempotency
   │
   ▼
Application
   │
   ▼
Domain
   │
   ▼
Persistence

Webhooks devem ser tratados como operações potencialmente duplicadas.

34. Observabilidade

A arquitetura deve evoluir para observabilidade completa.

Componentes planejados:

Logs
Metrics
Tracing
Health Checks
Audit Logs

A implementação futura deve permitir acompanhar:

request;
payment;
PIX;
webhook;
provider;
database;
Redis;
blockchain.
35. Error Handling

Erros de infraestrutura não devem vazar diretamente para a camada HTTP.

Exemplo:

Redis Error
     ↓
Infrastructure Error
     ↓
Application Result
     ↓
API Error
     ↓
HTTP Response

A API deve fornecer respostas previsíveis e estruturadas.

36. Result Pattern

O projeto possui infraestrutura compartilhada para resultados:

packages/shared/src/result.ts

A utilização do Result Pattern permite representar operações com sucesso ou falha sem depender exclusivamente de exceções para fluxo de negócio.

Modelo conceitual:

Result<T, E>
37. API Contracts

Os contratos públicos da plataforma devem permanecer separados da implementação.

Package:

@viapay/contracts

Objetivos:

contratos HTTP;
DTOs;
schemas;
tipos compartilhados;
compatibilidade entre clientes e API.
38. SDK

O projeto possui o package:

@viapay/sdk

Objetivo:

fornecer uma interface tipada para consumidores da API.

Arquiteturalmente:

Application
      │
      ▼
     API
      │
      ▼
     SDK
      │
      ▼
 Client Applications
39. Princípios de Código

O projeto deve seguir:

SOLID;
Clean Code;
DRY;
KISS;
Dependency Inversion;
Single Responsibility;
Separation of Concerns;
Explicit Dependencies;
Immutability quando apropriado;
Fail Fast;
Secure by Default.

Evitar:

lógica de negócio em controllers;
acesso direto ao banco em controllers;
dependência direta de infraestrutura no domínio;
singleton global sem necessidade;
secrets no código;
funções excessivamente grandes;
acoplamento entre módulos.
40. Test Strategy

A estratégia de testes deve evoluir em camadas.

Unit Tests

Testam:

Domain
Use Cases
Value Objects
Business Rules

Sem dependências externas.

Integration Tests

Testam:

Redis
PostgreSQL
Providers
Repositories
API Tests

Testam:

HTTP
Routes
Validation
Controllers
Error Responses
End-to-End

Validam fluxos completos:

Client
  ↓
API
  ↓
Application
  ↓
Infrastructure
  ↓
Database / Provider
41. Roadmap Técnico
Fase 1 — Fundação
 Monorepo
 TypeScript
 Fastify
 Application package
 Infrastructure package
 Domain package
 Contracts package
 SDK package
 Redis
 Redis Cache
 Health Check
 Swagger
 Vitest
Fase 2 — Payments
 Payment use cases
 Payment repository abstraction
 In-memory repository
 PIX provider abstraction
 Fake PIX provider
Fase 3 — Persistência
 PostgreSQL repository
 Database migrations
 Transaction boundaries
 Persistence integration tests
 Idempotency persistence
Fase 4 — PIX
 Provider real
 Webhooks
 Webhook signature validation
 Idempotency
 Retry strategy
 Reconciliation
Fase 5 — Blockchain
 Solana provider
 USDC transactions
 Transaction confirmation
 Blockchain reconciliation
 Treasury management
Fase 6 — Segurança
 Authentication
 Authorization
 API keys
 Rate limiting
 Request validation
 Audit logs
 Secret management
Fase 7 — Observabilidade
 Structured logging
 Metrics
 Distributed tracing
 OpenTelemetry
 Alerts
 Operational dashboards
Fase 8 — Produção
 Docker
 CI/CD
 Production PostgreSQL
 Managed Redis
 Secret management
 Horizontal scaling
 Disaster recovery
 Backup strategy
 Operational runbooks
42. Production Readiness

Antes de produção financeira, o sistema deverá possuir pelo menos:

[ ] Persistent database
[ ] Database migrations
[ ] Transaction management
[ ] Idempotency
[ ] Authentication
[ ] Authorization
[ ] Rate limiting
[ ] Input validation
[ ] Secure secrets
[ ] Audit trail
[ ] Structured logging
[ ] Monitoring
[ ] Alerting
[ ] Backup
[ ] Disaster recovery
[ ] Provider reconciliation
[ ] Webhook verification
[ ] Automated tests
[ ] CI/CD
[ ] Security review

O fato de a API responder 200 OK não significa que o sistema esteja pronto para processar operações financeiras reais.

43. Environment Architecture

Desenvolvimento:

Developer Machine
       │
       ├── Node.js
       ├── PostgreSQL
       ├── Redis
       └── ViaPay API

Staging:

CI/CD
  │
  ▼
Staging
  ├── API
  ├── PostgreSQL
  ├── Redis
  └── External Providers

Produção:

Load Balancer
      │
      ▼
┌───────────────┐
│ API Instance  │
├───────────────┤
│ API Instance  │
├───────────────┤
│ API Instance  │
└───────────────┘
       │
       ├──────── PostgreSQL
       │
       ├──────── Redis
       │
       └──────── External Providers
44. Monorepo Dependency Model

Os packages devem possuir responsabilidades claras.

@viapay/domain
       ↑
@viapay/application
       ↑
@viapay/infrastructure
       ↑
@viapay/api

Packages auxiliares:

@viapay/contracts
@viapay/sdk
@viapay/shared

A regra principal é evitar dependências circulares.

45. Definition of Done

Uma funcionalidade somente deve ser considerada concluída quando:

implementação finalizada;
tipos compilando;
testes implementados;
testes passando;
documentação atualizada;
tratamento de erros implementado;
logs adequados;
segurança considerada;
contratos atualizados;
build funcionando;
revisão de código realizada.
46. Comandos Rápidos

Instalar:

pnpm install

Typecheck completo:

pnpm --filter @viapay/application typecheck
pnpm --filter @viapay/infrastructure typecheck
pnpm --filter api typecheck

Build:

pnpm --filter @viapay/application build
pnpm --filter @viapay/infrastructure build
pnpm --filter api build

Testes:

pnpm --filter @viapay/infrastructure test

Redis:

redis-cli ping

PostgreSQL:

pg_isready

API:

pnpm --filter api start

Health:

curl http://127.0.0.1:3001/health

Swagger:

http://localhost:3001/docs
47. Repository

Repositório oficial:

https://github.com/viniamaral2026-cpu/viapay

Branch principal:

main
48. Licença

A licença definitiva do projeto deverá ser definida antes da distribuição pública ou comercial.

49. Engineering Principles

O ViaPay deve evoluir como uma plataforma de engenharia financeira, e não apenas como uma API.

Toda nova funcionalidade deve responder às seguintes perguntas:

Qual é a regra de negócio?
Em qual camada ela pertence?
Qual contrato precisa ser definido?
Qual infraestrutura implementará esse contrato?
Como a funcionalidade será testada?
Como será observada em produção?
Como será recuperada em caso de falha?
Como evitar processamento duplicado?
Como proteger dados sensíveis?
Como substituir o provedor no futuro?

A arquitetura deve privilegiar evolução segura, previsibilidade operacional e baixo acoplamento.

ViaPay

Payment Infrastructure • Modular Architecture • TypeScript • Fastify

Construído para evoluir de uma infraestrutura local de desenvolvimento para uma plataforma de pagamentos distribuída, observável e preparada para produção.