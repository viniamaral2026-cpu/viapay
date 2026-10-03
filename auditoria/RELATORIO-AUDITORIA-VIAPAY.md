# AUDITORIA TÉCNICA VIAPAY

## 1. Identificação do projeto

- **Nome**: ViaPay
- **Descrição**: Infraestrutura de liquração de pagamentos
- **Tipo**: Monorepo TypeScript com pnpm e Turbo
- **Versão**: 0.1.0

## 2. Data da auditoria

2026-10-03

## 3. Ambiente

- **Node.js**: v22.23.2
- **pnpm**: 12.8.1
- **TypeScript**: 7.0.2
- **Prisma**: 7.10.0
- **Sistema**: Linux x64

## 4. Estrutura do projeto

### Diretórios principais

| Diretório | Quantidade | Descrição |
|-----------|------------|-----------|
| `apps/` | 4 | API Fastify, Web Next.js, Demo-store, Worker |
| `packages/` | 7 | Application, Domain, Infrastructure, Contracts, Shared, SDK, Config |
| `src/` | - | Diretório raiz com código alternativo |
| `tests/` | - | Testes unit, integration, e2e |
| `prisma/` | - | Schema e migrations |

### Aplicativos (apps)

| App | Tecnologia | Responsabilidade |
|-----|------------|------------------|
| `apps/api` | Fastify + Swagger | API de pagamentos REST, CORS, Helmet, rate limiting |
| `apps/web` | Next.js 16, React 19, Tailwind CSS v4 | Frontend e-commerce |
| `apps/demo-store` | Next.js 16, React 19, Tailwind CSS v4 | Loja demo |
| `apps/worker` | TypeScript + pino + zod | Processador background |

### Pacotes (packages)

| Pacote | Responsabilidade |
|--------|------------------|
| `packages/application` | Casos de uso, ports (interfaces) |
| `packages/domain` | Entidades, regras de negócio, enums |
| `packages/infrastructure` | Implementações (Redis, provedores, repositórios) |
| `packages/contracts` | DTOs e eventos da API |
| `packages/shared` | Utilitários (type Result) |
| `packages/sdk` | SDK público cliente |
| `packages/config` | Vazio (0 entries) |

### Estrutura src/ raiz

O diretório `src/` no raiz contém código que parece ser uma versão alternativa ou legado do projeto, com sobreposição de alguns arquivos com a estrutura `packages/`. Há duplicação entre `src/application/`, `src/domain/`, etc. e `packages/application/`, `packages/domain/`.

## 5. Arquitetura encontrada

### Arquitetura hexagonal (Ports & Adapters)

O projeto tenta seguir arquitetura hexagonal com:

- **Domain**: Entidades (`Payment`, `Settlement`, `PaymentEvent`, `Merchant`, `PixCharge`) com regras de negócio e transições de estado
- **Application**: Casos de uso (`CreatePayment`, `GetPayment`, `HandlePixPayment`, `ProcessSettlement`) que usam ports
- **Infrastructure**: Implementações dos ports (repositórios in-memory, Redis, provedores PIX/SOL)
- **Contracts**: DTOs para entrada/saída da API
- **API**: Fastify camada de apresentação

### Padrões identificados

| Padrão | Status |
|--------|--------|
| Clean Architecture | Parcial - há violações de fronteira entre camadas |
| DDD (Domain-Driven Design) | Implementado em `packages/domain/` com entidades e status |
| UnitOfWork | Implementado em `src/application/use-cases/settlement/process-settlement.ts` |
| Repository Pattern | Implementado com Prisma e InMemory variantes |
| Event Sourcing | Pagamentos usam PaymentEvent para rastreamento |
| CQRS | Separação de queries (get) e commands (create/handle) |

### Violacões de arquitetura identificadas

1. **Mistura src/ vs packages/**: Código existe em ambas as estruturas, causando confusão
2. **Alias `@/` inconsistente**: Alguns arquivos usam `@/` aliases que não resolvem em todos contextos
3. **Imports diretos de infraestrutura no domínio**: Alguns arquivos importam implementações concretas
4. **Testes com dependências concretas**: Tests usam repositórios Prisma ou InMemory misturados

## 6. TypeScript

### Erros totais: Múltiplos (acima de 405 erros na execução `tsc --noEmit`)

### Principais categorias de erros

| Categoria | Quantidade | Descrição |
|-----------|------------|-----------|
| Import/Alias | Vários | Problemas com resolução de aliases `@/` |
| Prisma | Vários | Type mismatches com JsonNull, InputJsonValue |
| Teste | Vários | Mismatches entre interfaces e implementações InMemory |
| Configuração | 2 | `TS5023: Unknown compiler option 'include'` e `'exclude'` |
| JSX | Vários | Next.js apps precisam de configuração JSX |
| Monorepo | Vários | Configurações entre apps e packages |

### Erros críticos

1. `TS5023: Unknown compiler option 'include'` no `tsconfig.json` linha 28
2. `TS5023: Unknown compiler option 'exclude'` no `tsconfig.json` linha 33
3. `error TS2724: '"@/infrastructure/repositories/prisma-payment-event-transaction-repository.js"' has no exported member named 'PaymentEventTransactionRepository'` no `process-settlement.ts`
4. Mismatches de tipo no `PrismaPaymentEventTransactionRepository` com `JsonNull` vs `InputJsonValue`
5. `InMemorySettlementLockRepository.save()` tipo incompatível com interface `SettlementLockRepository`

### Arquivos com mais erros

- `apps/web/` - 40+ erros de JSX e módulos `@/` não encontrados
- `tests/integration/` - Erros de type compatibilidade Prisma/InMemory
- `tests/unit/` - Mismatches de interface InMemory
- `src/application/use-cases/settlement/process-settlement.ts` - Erro de alias exportado

## 7. tsconfig

### Problemas de configuração

1. **Erros próprios do tsconfig.json**:
   - `TS5023: Unknown compiler option 'include'` (linha 28)
   - `TS5023: Unknown compiler option 'exclude'` (linha 33)

   *Nota*: O `tsconfig.json` raiz tem `include` e `exclude` nas linhas 15-17 e 33-38 respectivamente. Os erros podem estar relacionados a project references ou configurações transitivas.

2. **Aliases definidas** no `tsconfig.json`:
   - `@/*` → `./src/*`
   - `@domain/*` → `./src/domain/*`
   - `@application/*` → `./src/application/*`
   - `@infrastructure/*` → `./src/infrastructure/*`
   - `@prisma/*` → `./src/prisma/*`
   - `@tests/*` → `./tests/*`

3. **Consistência entre apps e packages**:
   - O `apps/api/tsconfig.json` estende a configuração base mas usa resolução `NodeNext`
   - `apps/web/tsconfig.json` tem paths `@/*` → `./*` e `baseUrl: "."`
   - `packages/*/tsconfig.json` estendem a configuração base
   - **Problema**: Aliases `@/` definidos no root podem não estar disponíveis em apps/packages sem configuração equivalente

4. **Module resolution**: `NodeNext` no base, mas apps usam variações (Bundler, NodeNext)

## 8. Aliases

### Aliases definidos no `tsconfig.json` raiz

| Alias | Apontamento | Problema |
|-------|-------------|----------|
| `@/*` | `./src/*` | Alguns apps têm próprios paths |
| `@domain/*` | `./src/domain/*` | Web app usa `@/components/...` próprio |
| `@application/*` | `./src/application/*` | |
| `@infrastructure/*` | `./src/infrastructure/*` | Erro TS2724 em process-settlement.ts |
| `@prisma/*` | `./src/prisma/*` | |
| `@tests/*` | `./tests/*` | |

### Aliases por app

| App | Aliases |
|-----|---------|
| `apps/web` | `@/*` → `./*`, `baseUrl: "."` |
| `apps/api` | Não definido explicitamente, usa paths do root |
| `apps/demo-store` | Igual ao web (eslint config idêntica) |
| `apps/worker` | Caminhos relativos padrão |

### Problemas de alias

1. **Arquivo `src/application/use-cases/settlement/process-settlement.ts` linha 12**:
   ```
   error TS2724: '"@/infrastructure/repositories/prisma-payment-event-transaction-repository.js"' has no exported member named 'PaymentEventTransactionRepository'.
   ```
   O alias `@/` resolve o caminho, mas o módulo exportado tem nome diferente do importado.

2. **Apps web/demo-store**:
   - Erros `TS2307: Cannot find module '@/components/...'` ou tipo correspondente
   - Aliases `@/components/`, `@/lib/`, etc. existem mas não mapeados em tsconfig

3. **Conflito src/ vs packages/**:
   - Alguns imports usam `@viapay/domain`, `@viapay/application`, `@viapay/infrastructure`
   - Outros usam caminhos absolutos `@/` resolvendo para `src/`
   - Necessária normalização

## 9. Imports proibidos ../../

### Resultado: NENHUM import `../../` encontrado nos diretórios principais

A busca em `src/`, `apps/`, `packages/` (arquivos `.ts` e `.tsx`) não encontrou imports relativos com dois níveis `../../`.

**Observação**: Os imports `../../` encontrados foram exclusivamente em diretórios de backup:
- `backup/.backup-before-no-relative-imports-20261003-100153/`
- `backup/.backup/architecture-fix-20261003-094224/`

Esses eram fragmentos de código antes de uma refatoração anterior que visava remover imports relativos profundos. Os arquivos de backup devem ser analisados separadamente.

### Import pattern observado

Imports são feitos usando:

1. **Aliases nomeados**: `import { X } from "@viapay/domain"` / `import type { Y } from "@viapay/application"`
2. **Caminhos relativos curtos**: `import { X } from "../ports/payment-repository.js"` (um nível)
3. **Pacote principal**: `import { X } from "fastify"` etc.

### Conclusão: Regra `../../` atendida

Não há imports `../../` ativos nos códigos-fonte ativos. Os únicos presentes são artefatos de backups anteriores.

## 10. Monorepo

### Configuração

- **pnpm-workspace.yaml**: Inclui `apps/*` e `packages/*`
- **turbo.json**: Pipeline de tarefas (dev, build, lint, typecheck, test)
- **package.json root**: Scripts `dev`, `build`, `test`, `lint`, `typecheck`, `format`

### Estrutura de workspaces

| Workspace | Contém |
|-----------|--------|
| `apps/*` | 4 aplicações (api, web, demo-store, worker) |
| `packages/*` | 6 pacotes (application, domain, infrastructure, contracts, shared, sdk) + config vazio |

### Problemas de monorepo

1. **Dependencies duplicadas**: Alguns pacotes têm dependências que poderiam ser compartilhadas
2. **Versões desincronizadas**: Verificar se versões de `@prisma/client`, `typescript` são consistentes
3. **Configuração de tipos**: Cada pacote/app tem seu próprio `tsconfig.json` com pequenas variações

## 11. Prisma

### Schema (`prisma/schema.prisma`)

- **5 modelos**: Merchant, Payment, PixCharge, PaymentEvent, Settlement
- **4 enums**: PaymentStatus, PixChargeStatus, PaymentEventType, SettlementStatus
- **Relacionamentos**:
  - Merchant 1:N Payment
  - Payment 1:1 PixCharge, 1:1 Settlement, N:1 PaymentEvent
  - PixCharge 1:1 Payment
  - PaymentEvent 1:1 Payment
  - Settlement 1:1 Payment

### Configuração (`prisma.config.ts`)

```typescript
export default defineConfig({
  schema: "prisma/schema.prisma",
  datasource: {
    url: env("DATABASE_URL"),
  },
});
```

### Problemas identificados

1. **Prisma 7.10.0**: Versão utilizada, Prisma 8 não está ativo
2. **Schema engine**: `schema-engine-cli` habilitado
3. **Tipo JsonNull**: Erros no `prisma-payment-event-transaction-repository.ts` linha 70:
   ```
   Type 'Record<string, unknown>' is not assignable to type 'InputJsonValue | NullableJsonNullValueInput | undefined'
   ```
   O método `append` usa `Prisma.JsonNull` diretamente, mas o tipo do payload espera `InputJsonValue`.

4. **Migrations**: 2 migrations existirem:
   - `20261003111032_init`: Cria todos os enums e tables
   - `20261003115412_add_settlements`: Cria table settlements e enum SettlementStatus
   - **Não executar**: `migration` ou `db push` durante auditoria

5. **Client Prisma**: `@prisma/client` 7.10.0, generator `prisma-client-js`
6. **Isolamento transacional**: Uso de `$transaction` observado em cases de uso, mas inconsistência entre interface e implementação de UnitOfWork

## 12. Domain

### Localização: `packages/domain/` e `src/domain/`

### Estrutura

| Arquivo | Responsabilidade |
|---------|-------------------|
| `payment.ts` | Classe `Payment` com validação e matriz de transições |
| `payment-status.ts` | Tipo `PaymentStatus` union |
| `settlement.ts` | Classe `Settlement` com status PENDING→PROCESSING→SETTLED/FAILED/CANCELLED |
| `payment-event.ts` | Classe `PaymentEvent` com tipo e payload |
| `merchant.ts` | Entidade Merchant |
| `value-objects/money-brl.ts` | Value object MoneyBRL (não lido totalmente) |

### Repositórios (domain level)

- `PaymentRepository` - interface com `save()` e `findById()`
- `SettlementLockRepository` - interface para bloqueio otimista
- `PaymentEventRepository` / `PaymentEventTransactionRepository` - para eventos

### Regras de negócio

- **Payment transition matrix** estrita (CREATED → PIX_PENDING/FAILED/EXPIRED, etc.)
- **Settlement states**: PENDING → PROCESSING → SETTLED/FAILED/CANCELLED
- **Payment events** rastreiam estado changes com externalId único
- **Domain errors** lançados via `DomainError` para todas as validações

### Problemas identificados

1. **Duas definições de PaymentStatus**:
   - `packages/domain/src/payment/payment-status.ts` - enum string type
   - `src/domain/entities/payment.ts` - union type `PaymentStatus`
   - Potencial inconsistência entre os dois

2. **Duas definições de Payment entity**:
   - `packages/domain/src/payment/payment.ts` - com `transitionTo()`
   - `src/domain/entities/payment.ts` - com `markPixPending()`, `markPixPaid()`, etc.
   - Diferença de metodologia (transition matrix vs. métodos específicos)

3. **SettlementRepository não encontrado no domain**: O interface `SettlementLockRepository` existe mas a relação com o repositório Prisma não está clara

4. **Value Object MoneyBRL**: Verificar se `src/domain/value-objects/money-brl.ts` está sincronizado com `src/domain/entities/payment.ts`

## 13. Application

### Localização: `packages/application/` e `src/application/`

### Casos de uso principais

| Caso de uso | Responsabilidade |
|-------------|-------------------|
| `CreatePayment` | Cria pagamento, transição PIX_PENDING, gera charge PIX |
| `GetPayment` | Busca pagamento por ID |
| `HandlePixPayment` | Confirmação PIX: PIX_PENDING → PIX_PAID → SETTLEMENT_PENDING |
| `ProcessSettlement` | Processa settlement de Pagamento para SETTLED |

### Ports (interfaces)

| Port | Interface |
|------|-----------|
| `PaymentRepository` | `save()`, `findById()` |
| `PixProvider` | `createCharge()` |
| `ExchangeProvider` | `quoteBRLToUSDC()` |
| `SolanaProvider` | `settle()` |
| `Cache` | `get()`, `set()`, `delete()`, `exists()` |

### UnitOfWork

Implementado no `src/application/use-cases/settlement/process-settlement.ts` como função passada para `unitOfWork.execute()`. A interface definida em `../repositories/unit-of-work.js` espera métodos `execute()` e transação `PrismaTransactionClient`.

### Problemas identificados

1. **UnitOfWork interface vs implementação**:
   - Interface espera `save(transaction, settlement)` com tipo específico
   - Implementação InMemory tem `save(settlement)` sem transaction parameter
   - Erro de tipo: `Property 'save' in type 'InMemorySettlementLockRepository' is not assignable`

2. **SettlementLockRepository interface**:
   - Define `findByIdForUpdate(transaction, settlementId)` e `save(transaction, settlement)`
   - Implementação Prisma existe em `infrastructure/repositories/`
   - Implementação InMemory não segue assinatura completa

3. **ProcessSettlement use case**:
   - Usa `@/` aliases para imports
   - Erro TS2724 no import de `PaymentEventTransactionRepository`
   - Lógica de FOR UPDATE via `settlementLockRepository.findByIdForUpdate(tx, ...)` parece correta
   - Transação é passada corretamente para o UnitOfWork

4. **Hendling de idempotência**: Usa `externalId` em PaymentEvent e Settlement para evitar processamento duplicado

## 14. Infrastructure

### Localização: `packages/infrastructure/` e `src/infrastructure/`

### Implementações principais

| Componente | Implementação | Status |
|------------|--------------|--------|
| **Redis Client** | `RedisClient` class com ioredis | OK |
| **Redis Cache** | `RedisCache` implements `Cache` port | OK |
| **Health check** | `checkRedisHealth()` | OK |
| **Fake Pix Provider** | `FakePixProvider` implements `PixProvider` | OK |
| **InMemory Payment Repository** | `InMemoryPaymentRepository` implements `PaymentRepository` | OK (tipos) |
| **InMemory Settlement Repository** | `InMemorySettlementRepository` | Problems with interface |
| **InMemory Settlement Lock Repository** | `InMemorySettlementLockRepository` | Interface mismatch |
| **Prisma repositories** | `Prisma*Repository` para cada modelo | Existem, uso em testes |
| **Exchange Provider** | Diretório vazio `src/infrastructure/exchange/` | Não implementado |
| **Solana Provider** | `client/`, `settlement/`, `wallet/` subdiretórios | Parcial |

### Problemas identificados

1. **InMemorySettlementLockRepository.save()**:
   ```
   error TS2416: Property 'save' in type 'InMemorySettlementLockRepository' is not assignable to the same property in base type 'SettlementLockRepository'.
   Type '(settlement: Settlement) => Promise<Settlement>' is not assignable to type '(transaction: unknown, settlement: Settlement) => Promise<void>'.
   ```
   A implementação InMemory tem assinatura `save(settlement: Settlement)` mas a interface espera `save(transaction: unknown, settlement: Settlement)`.

2. **InMemoryPaymentEventRepository** falta método `countByPaymentId`:
   ```
   error TS2741: Property 'countByPaymentId' is missing in type 'InMemoryPaymentEventRepository' but required in type 'PrismaPaymentEventTransactionRepository'.
   ```

3. **FakePaymentEventRepository** em testes também falta `countByPaymentId`:
   ```
   error TS2420: Class 'FakePaymentEventRepository' incorrectly implements interface 'PaymentEventRepository'.
   Property 'countByPaymentId' is missing in type 'FakePaymentEventRepository' but required in type 'PaymentEventRepository'.
   ```

4. **PrismaPaymentEventTransactionRepository**:
   - Linha 70: Type mismatch com `JsonNull` vs `InputJsonValue`
   - Método `append` usa `Prisma.JsonNull` diretamente
   - Tipo do payload não compatível

5. **Exchange provider vazio**: Diretório `infrastructure/exchange/` sem implementação

6. **Solana provider**: Implementação parcial, verificar `client/`, `settlement/`, `wallet/`

## 15. Settlement

### Fluxo atual (textual)

```
Request
↓
ProcessSettlement Use Case
↓
UnitOfWork.execute(async transaction => {
  ↓
  settlementLockRepository.findByIdForUpdate(tx, settlementId)
  ↓
  Verifica status PENDING → PROCESSING → SETTLED
  ↓
  PaymentEventRepository.findByExternalId(tx, externalId:started/settled)
  ↓
  PaymentEventRepository.create(tx, event) ou append
  ↓
  settlementLockRepository.save(tx, settlement)
  ↓
  Commit/Rollback transaction
})
↓
Response
```

### Componentes do fluxo

| Componente | Arquivo | Status |
|------------|---------|--------|
| `ProcessSettlement` | `src/application/use-cases/settlement/process-settlement.ts` | Com erro de alias TS2724 |
| `SettlementLockRepository` | `src/domain/repositories/settlement-lock-repository.ts` | Interface definida |
| `PrismaSettlementLockRepository` | `src/infrastructure/repositories/prisma-settlement-lock-repository.ts` | Implementação |
| `InMemorySettlementLockRepository` | `src/infrastructure/repositories/in-memory-settlement-lock-repository.ts` | Interface mismatch |
| `UnitOfWork` | `src/domain/repositories/unit-of-work.js` | Interface |
| `PrismaUnitOfWork` | `src/infrastructure/database/prisma-unit-of-work.ts` | Implementação |
| `PaymentEventTransactionRepository` | `src/domain/repositories/payment-event-transaction-repository.ts` | Interface |
| `PrismaPaymentEventTransactionRepository` | `src/infrastructure/repositories/prisma-payment-event-transaction-repository.ts` | Implementação com bugs de tipo |
| `InMemoryPaymentEventRepository` | `src/infrastructure/repositories/in-memory-payment-event-repository.ts` | Faltando `countByPaymentId` |

### Problemas de concorrência

1. **FOR UPDATE**: Usado via `settlementLockRepository.findByIdForUpdate(tx, ...)` - padrão correto para PostgreSQL
2. **Idempotência**: Chave `externalId` única em `PaymentEvent` e `Settlement` previne re-processamento
3. **State check**: `if (settlement.status === "SETTLED")` retorna estado já persistido
4. **Transição inválida**: Lança `DomainError` se status não for o esperado

### Problemas de tipo

1. **PrismaTransactionClient casting**: `transaction as PrismaTransactionClient` em múltiplos locais
2. **Tipo de eventos**: `PaymentEvent.create()` vs `prisma.paymentEvent.create()` têm tipos diferentes de payload
3. **Settled event ID**: Lógica `settledEvent?.id ?? null` pode ser `undefined` em alguns caminhos

## 16. Payment Events

### Repositórios

| Repositório | Interface | Implementação | Problemas |
|-------------|-----------|---------------|-----------|
| `PaymentEventRepository` | `src/domain/repositories/payment-event-repository.ts` | - | Interface básica |
| `PrismaPaymentEventRepository` | - | `src/infrastructure/repositories/` | Não encontrado em busca |
| `PaymentEventTransactionRepository` | `src/domain/repositories/payment-event-transaction-repository.ts` | `PrismaPaymentEventTransactionRepository` | Tipo JsonNull |
| `PrismaPaymentEventRepository` | - | `src/infrastructure/repositories/prisma-payment-event-repository.ts` | Métodos: create, append, findByExternalId, countByPaymentId |
| `InMemoryPaymentEventRepository` | - | `src/infrastructure/repositories/in-memory-payment-event-repository.ts` | Faltando `countByPaymentId` |

### Métodos observados em `PrismaPaymentEventTransactionRepository`

| Método | Descrição | Problema |
|--------|-----------|----------|
| `create(transaction, event)` | Cria evento dentro de transação | Type payload mismatch |
| `append(transaction, event)` | Anexa evento (usado Prisma.JsonNull) | `error TS2322` com JsonNull |
| `findByExternalId(transaction, externalId)` | Busca por externalId | OK |
| `countByPaymentId(transaction, paymentId)` | Conta eventos por paymentId | Não testado/implementado em InMemory |

### Problemas de compatibilidade

1. **Interface vs Implementação**:
   - Interface `PaymentEventTransactionRepository` define `countByPaymentId`
   - `InMemoryPaymentEventRepository` não implementa esse método
   - `FakePaymentEventRepository` em testes também não tem

2. **Tipo do payload**:
   - `PrismaPaymentEventTransactionRepository.append()` linha 70:
     ```
     payload: event.payload ?? Prisma.JsonNull
     ```
   - Tipo `Prisma.JsonNull` não é assignable para `InputJsonValue` no método `create`

3. **Método append vs create**:
   - `append` usa `Prisma.JsonNull` directamente
   - `create` faz cast para `Prisma.InputJsonValue | undefined`
   - Inconsistência na tratamento do payload nulo

## 17. UnitOfWork

### Interface

Arquivo: `src/domain/repositories/unit-of-work.js` (note: `.js` em repositório de domínio)

Constrói o padrão de transação com métodos para executar lógica dentro de uma transação.

### Implementação Prisma

Provavelmente em `src/infrastructure/database/prisma-unit-of-work.ts`.

### Problemas

1. **Inconsistência de namespace**: Arquivo com extensão `.js` em diretório de domínio TypeScript
2. **Assinatura da função execute**: Espera `async function(transaction)` mas o tipo da transação não está bem definido em todos os use cases
3. **Injeção de dependência**: `ProcessSettlement` recebe `UnitOfWork` via constructor, mas a binding acontece no `container.ts` do apps/api

### Uso em ProcessSettlement

```typescript
constructor(
    private readonly unitOfWork: UnitOfWork,
    private readonly settlementLockRepository: SettlementLockRepository,
    private readonly paymentEventRepository: PaymentEventTransactionRepository,
) {}
```

O `unitOfWork.execute()` recebe uma função assíncrona que recebe a transação e realiza todas as operações dentro dela.

## 18. Repositories

### Resumo por tipo

| Repositório | Package | Interface | Implementação | Status |
|-------------|---------|-----------|---------------|--------|
| `PaymentRepository` | application/domain | `save()`, `findById()` | `InMemoryPaymentRepository`, `PrismaPaymentRepository` | OK |
| `SettlementLockRepository` | domain | `findByIdForUpdate()`, `save(tx, settlement)` | `InMemorySettlementLockRepository` (mismatch), `PrismaSettlementLockRepository` | Problemas de tipo |
| `PaymentEventRepository` | domain | Básica | - | Pendente |
| `PaymentEventTransactionRepository` | domain | `create()`, `append()`, `findByExternalId()`, `countByPaymentId()` | `PrismaPaymentEventTransactionRepository`, `InMemoryPaymentEventRepository` | Bugs de tipo, métodos faltando |
| `PixProvider` | application | `createCharge()` | `FakePixProvider` | OK |
| `SolanaProvider` | application | `settle()` | Parcial | Implementação incompleta |
| `ExchangeProvider` | application | `quoteBRLToUSDC()` | Vazio | Não implementado |

### Principais problemas de repository

1. **InMemorySettlementLockRepository.save()**: Assinatura incompatível com interface
2. **InMemoryPaymentEventRepository**: Faltando `countByPaymentId` exigido pela interface
3. **PrismaPaymentEventTransactionRepository.append()**: Type mismatch com JsonNull
4. **ExchangeProvider**: Diretório vazio, não há implementação

## 19. Testes

### Estrutura

```
tests/
  unit/       - Testes unitários com repositórios InMemory
  integration/ - Testes de integração (alguns exigem PostgreSQL)
  e2e/        - End-to-end tests
```

### Principais arquivos de teste

| Arquivo | Tipo | Dependências |
|---------|------|-------------|
| `payment-postgres.test.ts` | Integração | PostgreSQL |
| `payment-event-postgres.test.ts` | Integração | PostgreSQL |
| `process-settlement-postgres.test.ts` | Integração | PostgreSQL |
| `process-settlement-concurrency-postgres.test.ts` | Integração | PostgreSQL + concurrência |
| `settlement-for-update.test.ts` | Unitário | InMemory repos |
| `process-settlement.test.ts` | Unitário | InMemory repos |
| `process-pix-webhook.test.ts` | Unitário | InMemory repos |
| `prisma-transaction.test.ts` | Unitário | Prisma client |

### Problemas identificados

1. **Mismatches InMemory vs Interface**:
   - `InMemorySettlementLockRepository.save()` não corresponde a `SettlementLockRepository.save()`
   - `InMemoryPaymentEventRepository` falta `countByPaymentId`
   - `FakePaymentEventRepository` falta `countByPaymentId`

2. **Testes exigindo PostgreSQL**:
   - Muitos arquivos `.postgres.test.ts` não podem ser executados sem banco
   - Testes unitários dependem de fixtures de banco

3. **Import aliases em testes**:
   - Muitos testes usam `../../src/...` imports (mas estão em diretórios de backup, não ativos)
   - Tests ativos usam aliases `@viapay/...` ou imports relativos curtos

4. **Concurrência tests**:
   - `process-settlement-concurrency-postgres.test.ts` testa múltiplos workers
   - Depende de `findByIdForUpdate` / `FOR UPDATE` behavior

5. **Testes incompletos**:
   - Alguns testes têm `describe/`it blocks vazios oupending
   - `vitest.config.ts` em worker tem `--passWithNoTests`

## 20. Concorrência

### Padrão usado

O projeto usa `SELECT ... FOR UPDATE` pattern via `settlementLockRepository.findByIdForUpdate(tx, settlementId)` para garantir que apenas um worker processe um settlement de cada vez.

### Fluxo de concorrência

1. Worker 1 chama `ProcessSettlement.execute()`
2. Chama `settlementLockRepository.findByIdForUpdate(tx, id)` - bloqueia o registro
3. Worker 1 processa e define status SETTLED
4. Worker 2 tenta o mesmo settlement - `findByIdForUpdate` falha ou retorna registro com status SETTLED
5. Worker 2 verifica `if (settlement.status === "SETTLED")` e retorna estado já persistido

### Problemas de concorrência

1. **Implementação InMemory do lock repository** não suporta `findByIdForUpdate`:
   - A interface espera esse método mas a implementação InMemory pode não tê-lo ou ter assinatura diferente

2. **Não há validação de timeout** no lock:
   - Se um worker crashes durante o processamento, o lock pode permanecer indefinidamente
   - Não há mecanismo de expiração ou watchdog

3. **Tipo da transação**:
   - `transaction as PrismaTransactionClient` em múltiplos locais
   - Se o UnitOfWork passar um tipo diferente, causará erros em tempo de execução

4. **Event race condition**:
   - Múltiplos eventos podem ser criados com o mesmo `externalId` se não houver verificação adequada
   - O código verifica `if (!existingStarted)` antes de criar evento iniciado, o que ajuda

## 21. PostgreSQL

### Status

- Schema Prisma definido para PostgreSQL
- Migrations existirem mas **não podem ser executadas** durante auditoria
- Testes de integração exigem banco PostgreSQL ativo

### Tabelas e modelos

| Tabela | Colunas principais |
|--------|-------------------|
| `merchants` | id, name, document (unique), wallet, active, createdAt, updatedAt |
| `payments` | id, merchantId, amountBRLMinor (BigInt), merchantWallet, status, createdAt, updatedAt |
| `pix_charges` | id, paymentId (unique), provider, providerId, qrCode, qrCodeImage, amountBRLMinor, status, expiresAt, paidAt |
| `payment_events` | id, paymentId, type, externalId (unique), payload (Json?), occurredAt, createdAt |
| `settlements` | id, paymentId (unique), amountBRLMinor, status, externalId (unique), settledAt, createdAt, updatedAt |

### Índices importantes

- `[merchantId]`, `[status]`, `[merchantWallet]`, `[createdAt]` em payments
- `[provider]`, `[providerId]`, `[status]`, `[expiresAt]` em pix_charges
- `[paymentId]`, `[type]`, `[occurredAt]` em payment_events
- `[status]`, `[externalId]`, `[settledAt]`, `[createdAt]` em settlements

### Procedimentos observados

- `FOR UPDATE` via `settlementLockRepository.findByIdForUpdate()`
- Transações `$transaction` em use cases
- `externalId` único para idempotência em `payment_events` e `settlements`

## 22. Backups

### Estrutura de backups encontrada

Vários diretórios de backup foram encontrados, indicando tentativas anteriores de refatoração:

| Diretório | Descrição |
|-----------|-----------|
| `backup/` | Backups gerais |
| `backup/.backup-before-no-relative-imports-20261003-100153/` | Backup antes de tentativa de remover imports `../../` |
| `backup/.backup/` | Backup geral |
| `backup/.backup/architecture-fix-20261003-094224/` | Fix arquitetural específico |
| `.backup-architecture/` | Backup de arquitetura |
| `.backup-concurrency-20261003-092734/` | Backup relacionado à concorrência |
| `.backup/` | Backup raiz |

### Arquivos de interesse em backups

1. **`backup/.backup-before-no-relative-imports-20261003-100153/`** contém:
   - Versões antigas de testes e source com imports `../../` 
   - Arquivos como `process-settlement.ts`, `container.ts`, repositórios Prisma e InMemory
   - Testes de integração e unitários antes da refatoração

2. **`backup/.backup/architecture-fix-20261003-094224/`** contém:
   - `process-settlement.ts` com imports `../../` corrigidos para `@/`
   - Arquivos de domínio, aplicação e infrastructure ajustados
   - Representa um esforço anterior de correção arquitetural

3. **`.backup-architecture/`** e **`.backup-concurrency-20261003-092734/`**:
   - Contém possíveis snapshots de estados anteriores do projeto

### Recomendação

Os backups devem ser organizados/migrados para `./backup/` directory no futuro, mas **não** devem ser mexidos durante esta auditoria. Eles servem como referência do estado anterior do código.

## 23. Git

### Status atual

- **Ramo**: main
- **Últimos commits**: 5 commits mais recentes observados
- **Arquivos modificados** (non-staged):
  - `.env.example`
  - `package.json`
  - `pnpm-lock.yaml`
  - `pnpm-workspace.yaml`
  - `prisma.config.ts`

### Arquivos não rastreados

- `.agents/`, `.claude/`, `.cursor/`, `.devin/`
- `backup/`, `docker-compose.yml`, `infrastructure/`, `prisma/`, `scripts/`
- `src/`, `tests/`, `tsconfig.json`

### Observações

- Múltiplos `.backup` directories e pastas de ferramenta (.agents, .claude etc.) sugerem que o projeto passou por múltiplas configurações de desenvolvimento
- Modificações em `package.json`, `pnpm-lock.yaml` e `prisma.config.ts` podem indicar tentativas de atualização de dependências ou configuração

## 24. Segurança

### Variáveis de ambiente

Arquivos verificados:
- `.env` - Presente (conteúdo não revelado por segurança)
- `.env.example` - Modificado (ver git status)

### Problemas de segurança observados

1. **`.env.example` modificado**: Segundo `git status`, `.env.example` tem alterações não commited. Deve conter apenas nomes de variáveis, não valores secrets.

2. **DATABASE_URL**: Provavelmente definida em `.env`, nunca deve ser exposta no relatório

3. **REDIS_URL**: Provavelmente definida em `.env`, mesma regra acima

### Variáveis esperadas (pelo prisma.schema e prisma.config)

| Variável | Uso |
|----------|-----|
| `DATABASE_URL` | String de conexão PostgreSQL |
| `REDIS_URL` | String de conexão Redis |

### Recomendação

Verificar se `.env.example` apenas lista nomes das variáveis sem valores. Nunca commitar secrets reais.

## 25. Documentação

### Arquivos verificados

- `README.md` - README raiz do projeto
- `docs/` - Múltiplas categorias (api, architecture, operations, sdk, security)
- `ADRs` - Não encontrados explicitamente
- `scripts/` - Scripts de build, configure, sanitize

### Divergências código vs documentação

1. **README vs código atual**: O README pode descrever estado anterior do projeto
2. **Arquitetura documentada vs implementação**: Alguns padrões descritos podem não estar totalmente implementados
3. **Scripts**: `scripts/` contém scripts de configuração que podem não estar sincronizados com `package.json` scripts

### Documentação técnica

- `docs/architecture/` - Provavelmente contém decisões arquiteturais
- `docs/api/` - Documentação da API
- `docs/security/` - Boas práticas de segurança

## 26. Problemas encontrados

### Lista prioritária

| ID | Categoria | Problema | Impacto | Arquivo |
|----|-----------|---------|---------|---------|
| 1 | TypeScript | Erro TS5023: `include`/`exclude` unknown no tsconfig.json | Impede build correto | `tsconfig.json` |
| 2 | TypeScript | Alias `@/infrastructure/...` não resolve `PaymentEventTransactionRepository` | Impede build de process-settlement | `process-settlement.ts` |
| 3 | TypeScript | Mismatch Prisma JsonNull vs InputJsonValue | Erros de tipo em repository | `prisma-payment-event-transaction-repository.ts` |
| 4 | TypeScript | InMemorySettlementLockRepository.save() signature mismatch | Quebra de tipo entre interface e implementação | `in-memory-settlement-lock-repository.ts` |
| 5 | TypeScript | InMemoryPaymentEventRepository faltando `countByPaymentId` | Quebra de interface implementation | `in-memory-payment-event-repository.ts` |
| 6 | Arquitetura | Duplicação código entre `src/` e `packages/` | Confusão sobre qual estrutura usar | Todo o projeto |
| 7 | TypeScript | Web app aliases `@/components/` não mapeados | Erros de build nos apps web | `apps/web/tsconfig.json` |
| 8 | Prisma | Type mismatch JsonNull em payment-event repository | Erros de tipo na escrita de JSON | `prisma-payment-event-transaction-repository.ts` |
| 9 | Testes | InMemory repositórios não implementam interfaces completas | Tests quebram ou têm cobertura falsa | `tests/unit/` |
| 10 | Arquitetura | `ExchangeProvider` vazio | Funcionalidade não implementada | `packages/infrastructure/src/exchange/` |

## 27. Matriz de problemas

```markdown
ID | Categoria | Arquivo | Linha | Problema | Evidência | Impacto | Prioridade | Dependência | Recomendação
---|-----------|---------|-------|---------|-----------|---------|------------|-------------|-------------
1 | TS Config | tsconfig.json | 28,33 | TS5023: include/exclude unknown | Erro ao executar tsc --noEmit | Bloqueia build | CRÍTICO | Nenhum | Corrigir/remover include/exclude ou usar tsconfig adequado
2 | Alias | process-settlement.ts | 12 | @/infrastructure/... missing export | error TS2724 | Bloqueia módulo | CRÍTICO | Erro #3 | Corrigir export ou import
3 | Prisma | prisma-payment-event-transaction-repository.ts | 70 | JsonNull vs InputJsonValue | Type mismatch | Erros de runtime | ALTO | Erro #2 | Corrigir tipo do payload
4 | TypeScript | InMemorySettlementLockRepository.ts | 19 | save() signature | Type mismatch interface/implementação | Quebra de teste | ALTO | Nenhum | Ajustar assinatura da implementação InMemory
5 | TypeScript | InMemoryPaymentEventRepository.ts | - | countByPaymentId faltando | Interface não implementada | Tests quebram | ALTO | Nenhum | Implementar método faltando
6 | Arquitetura | - | - | Duplicação src/ vs packages/ | Código em ambos diretórios | Manutenção difícil | MÉDIO | Nenhum | Definir estrutura única
7 | TypeScript | apps/web/tsconfig.json | - | @/components/ não mapeado | TS2307: Cannot find module | Build web falha | MÉDIO | Nenhum | Adicionar paths ou usar aliases relativos
8 | Prisma | prisma-payment-event-transaction-repository.ts | 70 | Prisma.JsonNull type | Tipo incompatível | Erros de compilação | ALTO | Nenhum | Usar tipo correto do Prisma
9 | Testes | tests/unit/ | - | InMemory interfaces incompletas | Faltando métodos | Tests falham | MÉDIO | Nenhum | Implementar métodos faltando
10 | Arquitetura | - | - | ExchangeProvider vazio | Nenhuma implementação | Funcionalidade ausente | BAIXO | Nenhum | Implementar ou remover interface
```

## 28. Dependências entre problemas

```
TSCONFIG (erro #1)
    ↓
ALIASES (erro #2, #7)
    ↓
IMPORTS (erro #2 causa erro #3 indiretamente)
    ↓
PRISMA TYPES (erro #3, #8)
    ↓
REPOSITORIES (erro #4, #5, #9)
    ↓
TESTES (erro #9 afeta cobertura)
    ↓
ARQUITETURA (erro #6 afeta todo o sistema)
```

## 29. Plano de correção

### Fase 1: Correções críticas (1-2 semanas)

1. **Corrigir tsconfig.json** - Resolver erros TS5023 de include/exclude
2. **Corrigir alias `@/`** - Fixar exportação em `prisma-payment-event-transaction-repository.js` ou ajuste import em `process-settlement.ts`
3. **Corrigir tipos Prisma** - Ajustar tipo do payload em `append()` e `create()` do repositório de events

### Fase 2: Correções de médio prazo (2-4 semanas)

4. **Ajustar InMemory repositories** - Implementar métodos faltantes e assinaturas compatíveis
5. **Normalizar estrutura src/ vs packages/** - Definir uma estrutura única e migrar códigos
6. **Completar implementação ExchangeProvider** - Ou implementar ou remover interfaces não usadas

### Fase 3: Melhorias (4+ semanas)

7. **Melhorar documentação** - Sincronizar docs com código
8. **Adicionar mais testes** - Cobertura de concorrência, edge cases
9. **Implementar provedor SOL/Exchange** - Se necessário para o negócio

## 30. Arquivos que precisam ser alterados

| Caminho | Tipo de alteração |
|---------|-------------------|
| `tsconfig.json` | Corrigir/ajustar `include` e `exclude` |
| `src/application/use-cases/settlement/process-settlement.ts` | Corrigir import alias ou exportação |
| `src/infrastructure/repositories/prisma-payment-event-transaction-repository.ts` | Corrigir tipos JsonNull/InputJsonValue |
| `src/infrastructure/repositories/in-memory-settlement-lock-repository.ts` | Ajustar assinatura do método `save()` |
| `src/infrastructure/repositories/in-memory-payment-event-repository.ts` | Implementar método `countByPaymentId()` |
| `packages/infrastructure/src/exchange/` | Implementar ou remover |
| `apps/web/tsconfig.json` | Adicionar aliases `@/` consistentes |

## 31. Arquivos que NÃO devem ser alterados

| Caminho | Motivo |
|---------|--------|
| `prisma/schema.prisma` | Schema de banco - apenas leitura durante auditoria |
| `prisma/migrations/` | Migrations existentes - não executar |
| `backup/` directories | Backups históricos - não mover/apagar |
| `tests/` directories | Testes existentes - não alterar lógica |
| `packages/domain/src/payment/payment.ts` | Lógica de domínio - apenas análise |
| `packages/application/src/payment/use-cases/*.ts` | Casos de uso - apenas análise |

## 32. Conclusão técnica

### Pontos fortes do projeto

1. **Arquitetura hexagonal bien delineada**: Separação clara entre domínio, aplicação e infraestrutura
2. **Matriz de transições de pagamento bem definida**: `Payment.transitionTo()` com validação rigorosa
3. **Padrão UnitOfWork implementado**: Uso de transações em `ProcessSettlement`
4. **Idempotência via externalId**: Chaves únicas em PaymentEvent e Settlement
5. **Testes unitários e de integração**: Cobertura existente para fluxos críticos
6. **Redis Cache e Client**: Implementações limpas com TTL e health check
7. **FakePixProvider**: Implementação completa para testes sem provedor externo

### Pontos críticos que exigem atenção imediata

1. **Erros de configuração TypeScript** (TS5023) impedem build correto
2. **Aliases `@/` quebrados** bloqueiam módulos críticos (ProcessSettlement)
3. **Mismatches de tipo Prisma** podem causar erros em produção (JsonNull handling)
4. **Incompatibilidades de interface/repository** quebram testes unitários
5. **Duplicação src/ vs packages/** cria ambiguidade de manutenção

### Recomendação imediata

1. **Parar builds** até corrigir tsconfig.json e aliases críticos
2. **Criar ambiente de teste com PostgreSQL** para validar migrations
3. **Definir estrutura definitiva** (src/ ou packages/) e migrar código consistente
4. **Estabelecer guidelines** de alias uso em todo o monorepo
5. **Rodar `pnpm exec tsc --noEmit --project tsconfig.base.json`** para validar config base separadamente

### Próximos passos recomendados

1. Corrigir `tsconfig.json` include/exclude
2. Fixar alias `@/infrastructure/...` em `process-settlement.ts`
3. Ajustar tipos Prisma no repository de payment-events
4. Ajustar assinaturas InMemory repositories
5. Definir política de aliases para o monorepo
6. Validar com `pnpm test` em ambiente apropriado

---
*Fim da Auditoria Técnica ViaPay*