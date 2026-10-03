# VIAPAY - MASTER BLUEPRINT CONSTRUÇÃO

## 1. PRODUTO

### 1.1 Visão Geral
**Nome**: ViaPay  
**Descrição**: Infraestrutura de liquração de pagamentos - plataforma completa para processamento de Pix, settlement e transações financeiras  
**Tipo**: Monorepo TypeScript com arquitetura hexagonal (Ports & Adapters)  
**Objetivo**: Fornecer uma plataforma completa para pagamentos PIX, settlement internacional e gestão de comerciantes  
**Público-alvo**: Comércios, desenvolvedores de fintech, instituciones financeiras  
**Posicionamento**: Infraestrutura "plumbing" para pagamentos, não um frontend de consumo final

### 1.2 Módulos Principais
1. **Payments** - Criação, consulta e gerenciamento de pagamentos
2. **Settlement** - Liquidação e conciliação de pagamentos processados
3. **PIX** - Cobrança PIX (QR Code, Copia e Cola, status, expiração)
4. **Merchants** - Onboarding, perfil e gestão de comerciantes
5. **Dashboard** - Visão administrativa com KPIs e relatórios
6. **SDK** - Cliente público para integração
7. **Webhooks** - Eventos de notificação de status de pagamentos

### 1.3 Arquitetura
- **Hexagonal (Ports & Adapters)**: Domínio central, aplicação via ports, infraestrutura como adapter
- **Monorepo**: pnpm workspaces com turbo para CI/CD
- **TypeScript**: Tipagem estrita em todo o projeto
- **Prisma ORM**: PostgreSQL como banco de dados
- **Redis**: Cache e pub/sub para eventos em tempo real

## 2. ARQUITETURA

### 2.1 Camadas

| Camada | Responsabilidade | Arquivos Principais |
|--------|------------------|---------------------|
| **Domain** | Entidades, regras de negócio, enums | `packages/domain/`, `src/domain/` |
| **Application** | Casos de uso, ports (interfaces) | `packages/application/`, `src/application/` |
| **Infrastructure** | Implementações concretas | `packages/infrastructure/`, `src/infrastructure/` |
| **Contracts** | DTOs e eventos da API | `packages/contracts/` |
| **Shared** | Utilitários compartilhados | `packages/shared/` |
| **API** | Camada de apresentação (Fastify) | `apps/api/` |
| **Web** | Frontend Next.js | `apps/web/` |
| **Worker** | Processamento background | `apps/worker/` |

### 2.2 Padrões Arquiteturais
- **Clean Code**: Funções pequenas, nomes descritivos, sem `any` injustificado
- **SOLID**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- **DDD**: Domain-Driven Design com agregados, value objects e repositórios
- **Event Sourcing**: PaymentEvent rastreia todas as mudanças de estado
- **CQRS**: Separação de queries e commands onde apropriado

### 2.3 Fluxos de Dados

```
Request (API/Web) → Validation → Use Case → UnitOfWork → Repository → PostgreSQL
                      ↑                                    ↓
                      └── Events → Redis → Workers └── Response
```

## 3. DOMÍNIOS

### 3.1 Pagamentos (Payments)

| Elemento | Descrição |
|----------|-----------|
| **Entity** | Payment: id, merchantId, amountBRLMinor, merchantWallet, status, createdAt, updatedAt |
| **Status** | CREATED → PIX_PENDING → PIX_PAID → SETTLEMENT_PENDING → SETTLING → SETTLED / FAILED / EXPIRED |
| **Transitions** | Matriz rígida de transições via `Payment.transitionTo()` |
| **Events** | PaymentEvent: criado, pix_created, pix_paid, settlement_started, settled, failed, expired |
| **Repository** | PaymentRepository: save(), findById() |
| **Value Objects** | MoneyBRL: representação de valores em centavos (bigint) |

### 1.2 Settlement (Liquidação)

| Elemento | Descrição |
|----------|-----------|
| **Entity** | Settlement: id, paymentId, amountBRLMinor, status, externalId, settledAt, createdAt, updatedAt |
| **Status** | PENDING → PROCESSING → SETTLED / FAILED / CANCELLED |
| **Concurrency** | SELECT ... FOR UPDATE via settlementLockRepository |
| **Idempotência** | Chave única externalId em Settlement e PaymentEvent |
| **Events** | Settlement events: started, settled, failed, cancelled |
| **Repository** | SettlementLockRepository: findByIdForUpdate(), save() |
| **UnitOfWork** | Coordena transações across repositories |

### 1.3 PIX (Payment Initiation)

| Elemento | Descrição |
|----------|-----------|
| **Charge** | PixCharge: id, paymentId, provider, providerId, qrCode, qrCodeImage, amountBRLMinor, status, expiresAt, paidAt |
| **Provider** | FakePixProvider para testes, provedores reais integram com bancos |
| **Status** | CREATED → ACTIVE → PAID / EXPIRED / CANCELLED / FAILED |
| **QR Code** | geração de QR Code para pagamento via aplicativo bancário |
| **Copia e Cola** | Código PIX formatado para colar |
| **Expiração** | 30 minutos por padrão (configurável) |
| **Eventos** | PIX_CREATED, PIX_PAID, PIX_EXPIRED |

### 1.4 Merchants (Comerciantes)

| Elemento | Descrição |
|----------|-----------|
| **Entity** | Merchant: id, name, document (unique), wallet, active, createdAt, updatedAt |
| **Onboarding** | Cadastro com validação de documento |
| **Roles/Permissions** | Diferenciação entre admin, operator, viewer |
| **Settlement** | Configuração de regras de liquidação |
| **API Keys** | Chaves para integração com sistema do comerciante |

### 1.5 Dashboard

| Elemento | Descrição |
|----------|-----------|
| **KPIs** | Total de pagamentos, volume, taxa de sucesso, settlement pending, etc. |
| **Charts** | Evolução temporal, distribuição por status, volume por provedor |
| **Tables** | Lista de pagamentos, settlements, merchants, eventos |
| **Filters** | Por data, status, merchant, tipo de pagamento |
| **Actions** | Reprocessar, cancelar, exportar, emitir webhook |
| **Activities** | Log de eventos recentes |

### 1.6 Webhooks

| Evento | Descrição |
|--------|-----------|
| **payment_created** | Pagamento criado com sucesso |
| **payment_paid** | Pagamento PIX recebido com sucesso |
| **payment_expired** | Pagamento expirou sem recebimento |
| **payment_failed** | Pagamento falhou |
| **settlement_started** | Processamento de settlement iniciado |
| **settlement_settled** | Settlement concluído com sucesso |
| **settlement_failed** | Settlement falhou |
| **merchant_created** | Novo comerciante cadastrado |

### 1.7 SDK (Software Development Kit)

| Método | Descrição |
|--------|-----------|
| **payments.create** | Criar novo pagamento |
| **payments.get** | Consultar pagamento por ID |
| **settlement.process** | Processar settlement |
| **merchants.get** | Consultar comerciante |
| **events.subscribe** | Subscrever eventos (via webhook URLs) |

## 4. PERSONAS

### 4.1 Desenvolvedor (Developer)

| Atributo | Descrição |
|----------|-----------|
| **Objetivo** | Integrar pagamentos em seu aplicativo rapidamente |
| **Dores** | Documentação incompleta, SDK difícil, erros de tipo, falta de exemplos |
| **Experiência esperada** | `import { ViaPay } from '@viapay/sdk'; ViaPay.payments.create({...})` |
| **Necessidades** | Tipos TypeScript completos, exemplos claros, erros significativos, observabilidade |

### 4.2 Gestor de Comércio (Merchant Manager)

| Atributo | Descrição |
|----------|-----------|
| **Objetivo** | Gerenciar recebimentos, visualizar taxas e status dos pagamentos |
| **Dores** | Falta de visibilidade, processos manuais, conciliação difícil |
| **Experiência esperada** | Dashboard com KPIs em tempo real, relatórios exportáveis, webhooks configuráveis |
| **Necessidades** | Visão clara do caixa, histórico de transações, relatórios fiscais |

### 4.3 Operador de Pagamentos (Payment Operator)

| Atributo | Descrição |
|----------|-----------|
| **Objetivo** | Processar pagamentos e settlements de forma concorrente e idempotente |
| **Dores** | Race conditions, stuck transactions, falta de timeout em locks |
| **Experiência esperada** | `UnitOfWork.execute()` com `FOR UPDATE`, idempotência via externalId |
| **Necessidades** | Tratamento de concorrência, retry policies, audit trail |

## 5. PÁGINAS (Frontend - Next.js 16)

### 5.1 Páginas Públicas

| Rota | Título | Componentes |
|------|--------|-------------|
| `/` | Home | Hero, Cards, QR Code, Navbar, Footer |
| `/como-funciona` | Como funciona | Passos do fluxo, exemplos |
| `/cadastro` | Cadastro | Formulário de onboarding, validação |
| `/login` | Login | Autenticação, links sociais |
| `/onboarding` | Onboarding | Setup inicial, configuração de banco |
| `/contato` | Contato | Formulário de contato |

### 5.2 Páginas Autenticadas

| Rota | Título | Componentes |
|------|--------|-------------|
| `/dashboard` | Dashboard | KPIs, charts, tables, filters |
| `/dashboard/carteiras` | Carteiras | Lista de carteiras, status |
| `/dashboard/configuracoes` | Configurações | Configurações da conta |
| `/dashboard/documentacao` | Documentação | SDK docs, API reference |
| `/empresa` | Empresa | Perfil da empresa, dados cadastrais |

### 5.3 Páginas de Pagamento

| Rota | Título | Componentes |
|------|--------|-------------|
| `/payments/create` | Criar Pagamento | Formulário amount + merchantWallet |
| `/payments/[paymentId]` | Detalhe Pagamento | Status, eventos, actions |
| `/checkout` | Checkout | Formulário de pagamento, QR Code display |
| `/precotar` | Precotar | Simular valores e prazos |

### 5.4 Rotas de Admin

| Rota | Título | Componentes |
|------|--------|-------------|
| `/admin` | Admin Dashboard | Visão geral do sistema |
| `/admin/merchants` | Merchants | Listar, criar, editar comerciantes |
| `/admin/payments` | Pagamentos | Listar, filtro, actions em massa |
| `/admin/settlements` | Settlements | Lista de settlements, status |
| `/admin/webhooks` | Webhooks | Gerenciar endpoints de webhook |
| `/admin/events` | Events | Log de events, filters |
| `/admin/reports` | Reports | Relatórios exportáveis |

## 6. ROTAS (API - Fastify)

### 6.1 Health Check

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check simples |
| GET | `/docs` | Swagger UI docs |

### 6.2 Pagamentos

| Método | Endpoint | Body | Response | Status |
|--------|----------|------|----------|--------|
| POST | `/payments` | `amountBRL`, `merchantWallet` | `paymentId`, `status`, `pixChargeId`, `qrCode`, `expiresAt` | 201 |
| GET | `/payments/:id` | params: `id` | `id`, `amountBRL`, `merchantWallet`, `status`, `createdAt`, `updatedAt` | 200 / 404 |
| POST | `/payments/:id/confirm` | `externalId` | Status update | 200 |

### 6.3 Settlements

| Método | Endpoint | Body | Response | Status |
|--------|----------|------|----------|--------|
| POST | `/settlements/process` | `settlementId`, `externalId` | `processed`, `settlementId`, `status` | 200 |
| GET | `/settlements/:id` | params: `id` | Settlement details | 200 |

### 6.4 Merchants

| Método | Endpoint | Body | Response | Status |
|--------|----------|------|----------|--------|
| POST | `/merchants` | `name`, `document`, `wallet` | `id`, `name`, `document`, `active` | 201 |
| GET | `/merchants/:id` | params: `id` | Merchant details | 200 |

### 6.5 Webhooks

| Método | Endpoint | Body | Response | Status |
|--------|----------|------|----------|--------|
| POST | `/webhooks` | `url`, `events` | `id`, `url`, `events` | 201 |
| GET | `/webhooks` | - | List of webhooks | 200 |

## 7. UX (Experiência do Usuário)

### 7.1 Fluxos Principais

#### Fluxo de Criação de Pagamento
1. **Loading**: Spinner ou esqueleto enquanto validações são realizadas
2. **Success**: Mensagem de pagamento criado, QR Code display, timeline de eventos
3. **Error**: Mensagens específicas por falha (amount inválido, merchantWallet inválido, rate limit)
4. **Validation**: Zod schemas na frontend e backend, mensagens alinhadas
5. **Confirmation**: Dialog para confirmar valores antes de gerar charge

#### Fluxo de Settlement
1. **Loading**: Indicador de processamento durante `UnitOfWork.execute()`
2. **Success**: Settlement marcado como SETTLED, events persistidos, redirect
3. **Error**: Domínio errors específicos (status inválido, já processado, concorrência)
4. **Validation**: Verificação de status antes de processar
5. **Retry**: Botão retry para falhas transitórias

#### Fluxo de PIX
1. **Loading**: Gerando charge, aguardando confirmação do banco
2. **Success**: Pix pago, atualização de status, event criado
3. **Error**: Tempo expirado, pagamento falhou, estornar opcional
4. **Confirmation**: Verificação de pagamento a cada X segundos (polling)
5. **Timeout**: Tratamento adequado quando QR expira

### 7.2 Estados Vazios (Empty States)

| Tela | Conteúdo | Ação |
|------|----------|------|
| **Sem pagamentos** | Mensagem incentivando primeiro pagamento, link para criar | CTA "Criar primeiro pagamento" |
| **Sem settlements** | Mensagem de boas-vindas, status inicial | CTA "Primeiro settlement" |
| **Sem eventos** | "Nenhum evento encontrado", link para refresh | Ação pull-to-refresh |
| **Sem webhooks** | "Nenhum webhook configurado", botão para adicionar | CTA "Adicionar webhook" |

### 7.3 Error States

| Estado | Mensagem | Ação |
|--------|----------|------|
| **404** | "Página não encontrada" | Voltar ao home, links úteis |
| **403** | "Acesso negado" | Login necessário, contato admin |
| **400** | "Requisição inválida" | Corrigir campos e tentar novamente |
| **500** | "Erro interno" | Tentar novamente, contactar suporte se persistir |
| **Network** | "Sem conexão" | Verificar internet, retry automático |

### 7.4 Responsividade

| Breakpoint | Layout | Componentes |
|------------|--------|-------------|
| **Mobile (320px-640px)** | Coluna única, navbar hambúrguer, cards empilhados | Botões maiores, touch targets |
| **Tablet (641px-1024px)** | Duas colunas, sidebar colapsável | Tipografia legível, espaçamento adequado |
| **Desktop (1025px+)** | Três+ colunas, sidebar fixa, tabelas completas | Atalhos de teclado, hover states |

## 8. UI (Interface do Usuário)

### 8.1 Componentes Principais

| Componente | Props | Estilo | Uso |
|------------|-------|--------|-----|
| **Navbar** | links, logo, userMenu | flex, bg-white, shadow | Header universal |
| **Footer** | links, copyright, social | text-center, text-sm | Rodapé consistente |
| **Card** | title, children, actions | rounded, shadow, p-6 | Container de conteúdo |
| **Button** | variant, size, onClick | primary/secondary, lg/sm | Ações principais |
| **Input** | type, placeholder, error | bordered, focused state | Campos de formulário |
| **Badge** | variant, size | bg-blue-100 text-blue-800 | Status tags |
| **Spinner** | size | animate-spin | Estados de loading |
| **Skeleton** | width, height, lines | shimmer effect | Placeholders |
| **Table** | columns, data, onSelect | striped, hover, scroll | Tabelas de dados |
| **Chart** | data, type, options | responsive, labeled | Gráficos KPIs |
| **Drawer** | open, onClose, children | modal slide-in | Actions laterais |
| **Dialog** | open, onConfirm, onCancel | modal confirm | Confirmações |
| **ProgressBar** | value, max, color | incremental | Progresso de settlement |
| **Badge** | type, label | colors por status | Payment/Pix Status |

### 8.2 Sistema de Design

| Tema | Cores | Tipografia |
|------|-------|-----------|
| **Light** | White, slate-50, blue-50 | Inter/system font |
| **Dark** | Slate-900, blue-900 | Same font, adjusted contrast |
| **Primary** | Blue theme (blue-500, blue-600) | |
| **Success** | Green theme | |
| **Error** | Red theme | |
| **Warning** | Orange/yellow theme | |

## 8.3 Tipografia

- **Fonte principal**: Inter ou system font
- **Tamanhos**: xs(12px) a xl(18px) para body, h1(32px) a h6(24px) para headings
- **Pesos**: 300 (Light) a 700 (Bold)
- **Linhas**: 1.5 base, 1.25 para headings

## 9. API (BACKEND)

### 9.1 Endpoints Obrigatórios

#### Pagamentos

```http
POST /payments
Body: { amountBRL: number, merchantWallet: string }
Response: { paymentId, status: "PIX_PENDING", pixChargeId, qrCode, expiresAt }
```

```http
GET /payments/:id
Response: { id, amountBRL, merchantWallet, status, createdAt, updatedAt }
```

```http
POST /payments/:id/confirm
Body: { externalId: string }
Response: { status updated }
```

#### Settlements

```http
POST /settlements/process
Body: { settlementId: string, externalId: string }
Response: { processed, settlementId, status }
```

```http
GET /settlements/:id
Response: Settlement details
```

#### Merchants

```http
POST /merchants
Body: { name: string, document: string, wallet: string }
Response: Merchant created
```

```http
GET /merchants/:id
Response: Merchant details
```

### 9.2 Modelos de Request/Response

#### CreatePaymentRequest

```typescript
{
  amountBRL: number; // em reais
  merchantWallet: string; // wallet do comerciante
}
```

#### CreatePaymentResponse

```typescript
{
  paymentId: string;
  status: "PIX_PENDING";
  pixChargeId: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: Date;
}
```

#### PaymentResponse

```typescript
{
  id: string;
  amountBRL: number;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: Date;
  updatedAt: Date;
}
```

### 9.3 Tratamento de Erros

| Código | Mensagem | Campo |
|--------|----------|-------|
| 400 | "Validation failed" | Zod errors |
| 404 | "Payment not found" | paymentId |
| 409 | "Payment already processed" | status atual |
| 429 | "Too many requests" | Rate limit |
| 500 | "Internal server error" | Stack trace em dev |

### 9.4 Segurança API

- **Auth**: API Key no header `Authorization: Bearer <key>`
- **Rate Limit**: 100 requests/min por API key
- **Validation**: Zod schemas em todos os endpoints
- **Idempotência**: Header `Idempotency-Key` para operações críticas
- **HTTPS**: Obrigatório em produção

## 10. DATABASE (PostgreSQL)

### 10.1 Tabelas

| Tabela | Colunas Chave | Índices | Constraints |
|--------|--------------|---------|-------------|
| **merchants** | id, name, document (unique), wallet, active, createdAt, updatedAt | [document] UNIQUE, [active] | NOT NULL, defaults |
| **payments** | id, merchantId, amountBRLMinor (BigInt), merchantWallet, status, createdAt, updatedAt | [merchantId], [status], [merchantWallet], [createdAt] | FK → merchants |
| **pix_charges** | id, paymentId (unique), provider, providerId, qrCode, qrCodeImage, amountBRLMinor, status, expiresAt, paidAt | [provider], [providerId], [status], [expiresAt] | FK → payments (unique) |
| **payment_events** | id, paymentId, type, externalId (unique), payload (Json?), occurredAt, createdAt | [paymentId], [type], [occurredAt] | UNIQUE externalId, FK → payments |
| **settlements** | id, paymentId (unique), amountBRLMinor, status, externalId (unique), settledAt, createdAt, updatedAt | [status], [externalId], [settledAt], [createdAt] | UNIQUE externalId, FK → payments |

### 10.2 Relations

```
Merchant 1:N Payment
Payment 1:1 PixCharge
Payment 1:1 Settlement
Payment N:1 PaymentEvent
```

### 10.3 Indexes Recomendados

```sql
-- Performance queries frequentes
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_merchantId ON payments(merchantId);
CREATE INDEX idx_pixCharges_status ON pix_charges(status);
CREATE INDEX idx_paymentEvents_paymentId ON payment_events(paymentId);
CREATE INDEX idx_settlements_status ON settlements(status);
CREATE INDEX idx_settlements_externalId ON settlements(externalId);

-- Performance joins
CREATE INDEX idx_pixCharges_paymentId ON pix_charges(paymentId);
CREATE INDEX idx_paymentEvents_paymentId ON payment_events(paymentId);
```

### 10.4 Transactions

```typescript
// Padrão de uso em UnitOfWork
await prisma.$transaction(async (tx) => {
  // Multiple operations within transaction
  await tx.payment.create({ data: ... });
  await tx.paymentEvent.create({ data: ... });
  await tx.settlement.create({ data: ... });
});
```

### 10.5 Constraints & Unique

- `externalId` UNIQUE em `payment_events` e `settlements` - previne re-processamento
- `document` UNIQUE em `merchants` - evita cadastro duplicado
- `paymentId` UNIQUE em `pix_charges` - um charge por payment
- `status` com CHECK constraint - valores válidos somente

## 11. EVENTOS (Event Sourcing)

### 11.1 Payment Events

| Event Type | Payload | Quando Gerado |
|------------|---------|---------------|
| **CREATED** | { paymentId, merchantWallet, amount } | Início do pagamento |
| **PIX_CREATED** | { paymentId, qrCode, expiresAt } | Charge PIX gerada |
| **PIX_PAID** | { paymentId, transactionId, amount } | Pagamento recebido |
| **PIX_EXPIRED** | { paymentId, expiredAt } | QRCode expirado sem pagamento |
| **SETTLEMENT_PENDING** | { settlementId, paymentId } | Início do settlement |
| **SETTLEMENT_STARTED** | { settlementId, paymentId, eventId } | Worker pegou o lock |
| **SETTLED** | { settlementId, paymentId, settledAt } | Settlement concluído |
| **FAILED** | { paymentId, settlementId, error } | Qualquer falha terminal |
| **EXPIRED** | { paymentId, settlementId, expiredAt } | Tempo expirado |

### 11.2 Settlement Events

| Event Type | Payload | Quando Gerado |
|------------|---------|---------------|
| **PENDING** | { settlementId, paymentId } | Settlement criado |
| **PROCESSING** | { settlementId, paymentId } | Início do processamento |
| **SETTLED** | { settlementId, paymentId, settledAt } | Concluído com sucesso |
| **FAILED** | { settlementId, paymentId, error } | Falha no processamento |
| **CANCELLED** | { settlementId, paymentId } | Cancelado manualmente |

### 11.3 Pub/Sub (Redis)

- Canais: `payment:*`, `settlement:*`
- Padrão: Publisher (API) → Redis → Worker (Processamento)
- Confirmação: ACK/NACK após processamento
- Idempotência: Chave `externalId` evita duplicate events

## 12. QUEUES E WORKERS

### 12.1 Worker de Processamento de Settlement

| Responsabilidade | Implementação |
|------------------|---------------|
| **Executar settlement** | `ProcessSettlement.useCase.execute()` |
| **Lock otimista** | `settlementLockRepository.findByIdForUpdate(tx, id)` |
| **FOR UPDATE** | Padrão PostgreSQL `SELECT ... FOR UPDATE` |
| **Idempotência** | Chave `externalId`, verificação `if (existingSettled)` |
| **Events** | Criar PaymentEvent STARTED/SETTLED |
| **Retry** | Politica de retry com backoff exponencial |
| **Timeout** | Validação de tempo limite no lock |

### 12.2 Worker de Webhooks

| Responsabilidade | Implementação |
|------------------|---------------|
| **Receber webhooks** | Endpoint POST `/webhooks` (Fastify) |
| **Validar assinatura** | HMAC ou segredo compartilhado |
| **Idempotência** | Verificar `externalId` já processado |
| **Dispatch event** | Publicar no Redis `payment:*` ou `settlement:*` |
| **Response** | Retornar 200 rapidamente, processar em background |

### 12.3 Fila de Retry

| Estratégia | Descrição |
|------------|-----------|
| **Backoff exponencial** | 1s, 2s, 4s, 8s, 16s entre tentativas |
| **Dead Letter Queue** | Mensagens que falharam max attempts vão para DLQ |
| **Monitoramento** | Métricas de fila tamanho, failed rate, retry rate |
| **Manual override** | Interface para reenviar DFQ manualmente |

## 13. SEGURANÇA

### 13.1 Authentication

| Método | Descrição |
|--------|-----------|
| **API Keys** | Chave única por integração, header `Authorization` |
| **JWT** | Para sessões web, curto expiry (15min) |
| **OAuth** | Social login opcional (Google, GitHub) |

### 13.2 Authorization (RBAC)

| Role | Permissions |
|------|-------------|
| **admin** | Todas as permissões, gerenciar usuários, configurações do sistema |
| **operator** | Processar pagamentos, ver relatórios, emitir webhooks |
| **viewer** | Apenas visualizar, sem alterações |
| **merchant** | Apenas seus próprios dados, criar pagamentos |

### 13.3 Input Validation

- **Zod schemas** em todos os endpoints API
- **Sanitização**: `trim()`, `escapeHtml()` onde aplicável
- **TypeScript**: Types em tempo de compile, validação em runtime
- **Limits**: `max` em campos de texto, `precision` em números

### 13.4 Secrets e Credenciais

- **Nunca** hardcode no código-fonte
- Usar `.env` + `dotenv` configuração
- **Prisma**: `DATABASE_URL` via env
- **Redis**: `REDIS_URL` via env
- **API Keys**: Rotacionar periodicamente

### 13.5 PII e LGPD

- **Não armazenar** CPF/FULL no payload de evento
- **Masking**: Mostrar apenas últimos 4 dígitos quando exibir
- **Consentimento**: Log de quem acessou dados pessoais
- **Exclusão**: `RIGHT TO FORGET` - anonimizar dados sob requisição

### 13.6 Segurança de Rede

- **HTTPS Only**: TLS 1.2+ em produção
- **CORS**: Configurado apenas para origens autorizadas
- **Helmet**: Headers de segurança HTTP (já usado no Fastify)
- **Rate Limiting**: Por IP e por API key
- **CSP**: Content Security Policy header

## 14. AUDITORIA

### 14.1 Logs Estruturados

| Campo | Descrição |
|-------|-----------|
| **timestamp** | ISO 8601 |
| **level** | error, warn, info, debug |
| **service** | "viapay-api", "viapay-worker", etc. |
| **traceId** | ID único para rastrear request completa |
| **spanId** | ID do span dentro de trace |
| **message** | Mensagem descritiva |
| **context** | Contexto adicional (paymentId, settlementId, userId) |

### 14.2 Auditoria de Mudanças

| Entidade | O que Auditar | Frequência |
|----------|---------------|------------|
| **Payments** | status changes, value changes | A cada mudança |
| **Settlements** | status, settledAt, externalId changes | A cada mudança |
| **Merchants** | document changes, active status | A cada mudança |
| **Events** | creation, externalId usage | A cada acesso |

### 14.3 Retenção

- **Logs**: 90 dias em produção, 365 dias em desenvolvimento
- **Events**: Permanente (PostgreSQL + Redis cache)
- **Settlements**: Permanente (somente alterações de status)
- **Backups**: Database daily, files every 6 hours

## 15. OBSERVABILIDADE

### 15.1 Métricas (Prometheus-style)

| Métrica | Tipo | Descrição |
|---------|------|-----------|
| `http_requests_total` | Counter | Total de requisições HTTP |
| `http_request_duration_seconds` | Histogram | Duração das requisições |
| `payments_created_total` | Counter | Total de pagamentos criados |
| `payments_failed_total` | Counter | Total de pagamentos com falha |
| `settlements_processed_total` | Counter | Total de settlements processados |
| `settlements_failed_total` | Counter | Total de settlements com falha |
| `active_workers` | Gauge | Número de workers ativos |
| `redis_memory_used_bytes` | Gauge | Memória Redis usada |

### 15.2 Tracing

- **OpenTelemetry**: Instrumentação automática
- **Trace ID**: Passado entre API → Worker → Database
- **Span**: Cada operação (create payment, process settlement, etc.)
- **Sampling**: 10% em produção, 100% em desenvolvimento

### 15.3 Alertas

| Condição | Severity | Ação |
|----------|----------|------|
| `error_rate > 5%` | high | Notificar equipe on-call |
| `worker_crash_rate > 2/h` | critical | Auto-restart, alertar |
| `redis_memory > 80%` | warning | Monitorar, aumentar capacity |
| `payment_failure_rate > 10%` | high | Investigar causa raiz |
| `settlement_timeout > 5min` | warning | Verificar concorrência |

### 15.4 Saúde (Health Checks)

- **`/health`**: Status básico (OK/Error)
- **`/health/ready`**: Verificar dependências (PostgreSQL, Redis)
- **`/health/live`**: Verificar processo vivo (kill switch)
- **Dependências**: Cada serviço reporta saúde individual

## 16. TESTES

### 16.1 Unit Tests

| Tipo | Cobertura | Exemplos |
|------|-----------|----------|
| **Domain** | 100% regras de negócio | `Payment.transitionTo()`, `Settlement.markAsSettled()` |
| **Application** | 80% use cases | `CreatePayment.execute()`, `HandlePixPayment.execute()` |
| **Infrastructure** | 70% repositórios | InMemory implementations, Prisma adapters |

### 16.2 Integration Tests

| Tipo | Setup | Exemplos |
|------|-------|----------|
| **PostgreSQL** | Banco real ou testes integration | `payment-postgres.test.ts` |
| **Redis** | Redis real ou mock | Cache tests, event pub/sub |
| **Fastify** | Server inteiro | `apps/api/src/__tests__/payments.test.ts` |
| **E2E** | Navegador real | Cypress/Playwright tests |

### 16.3 Testes de Contrato

| Ferramenta | O que Valida |
|------------|--------------|
| **OpenAPI** | Schema consistency entre docs e implementação |
| **JSON Schema** | Request/Response validation |
| **TypeScript** | Type safety em tempo de build |

### 16.4 Cobertura Mínima

- **Unit**: 80% de linhas cobertas
- **Integration**: Todos os flows críticos cobertos
- **E2E**: Fluxos principais (create payment, process settlement)

## 17. DOCUMENTAÇÃO

### 17.1 API Docs

- **OpenAPI 3.1**: `api/openapi.ts` gera docs automáticas
- **Swagger UI**: `/docs` endpoint
- **Exemplos**: Request/response examples em cada endpoint

### 17.2 SDK Docs

- **README**: `packages/sdk/README.md`
- **Exemplos de código**: `packages/sdk/examples/`
- **Tipos**: Gerados via TypeScript `tsdoc`

### 17.3 Arquitetura

- **ADRs**: `docs/architecture/ADRs/` - Decisões arquiteturais registradas
- **Diagramas**: Mermaid ou PlantUML diagrams
- **Guides**: `docs/guides/` - Guides de onboarding e operações

### 17.4 Onboarding

- **Guia rápido**: 5 minutos para primeiro `pnpm dev`
- **Scripts**: `scripts/bootstrap-frontend.sh`, `scripts/configure-core-workspaces.sh`
- **Padrões**: `packages/application/src/payment/use-cases/` patterns

## 18. DESENVOLVEDOR PORTAL

### 18.1 API Keys

| Campo | Descrição |
|-------|-----------|
| **key** | Chave única gerada pelo sistema |
| **name** | Nome identificador do aplicativo |
| **roles** | Roles assegnadas (admin, operator, viewer) |
| **expiresAt** | Data de expiração (opcional) |
| **rateLimit** | Limite de requests por minuto |

### 18.2 Aplicações

| Campo | Descrição |
|-------|-----------|
| **name** | Nome do aplicativo |
| **owner** | Udonário ou organização dono |
| **redirectUris** | URIs de callback para OAuth |
| **status** | active/inactive/pending |

### 18.3 Sandbox

| Ambiente | Descrição |
|----------|-----------|
| **Modo teste** | Usa FakePixProvider, InMemory repos |
| **Dados fictícios** | Pagamentos e settlements de teste |
| **Sem cobrança real** | Não toca dinheiro real |
| **Liberado para** | Desenvolvedores, QA |

### 18.4 API Explorer

- **Interativo**: Testar endpoints diretamente no navegador
- **Auth**: Login com API Key antes de testar
- **Examples**: Exemplos pré-carregados por endpoint
- **Response sandbox**: Respostas mockadas ou reais

## 19. COMPARAÇÃO ESTADO ATUAL × PROJETADO

### 19.1 GAP Matrix (Ver documento separado)

### 19.2 Principais Gaps Identificados

1. **TS5023 no tsconfig.json** - Bloqueia build completo
2. **Aliases `@/` quebrados** - Impede módulos críticos
3. **InMemory repositórios incompletos** - Tests quebram
4. **ExchangeProvider vazio** - Funcionalidade não implementada
5. **Duplicação src/ vs packages/** - Confusão de manutenção
6. **Web aliases `@/components/`** - Não mapeados corretamente
7. **Two PaymentStatus definitions** - Inconsistência de domínio

## 20. PLANO DE CORREÇÃO FASE A FASE

### Fase 1: Correções Críticas (1 semana)
1. ✅ Corrigir `tsconfig.json` include/exclude
2. ✅ Fixar alias `@/infrastructure/...` em `process-settlement.ts`
3. ✅ Ajustar tipos Prisma JsonNull/InputJsonValue

### Fase 2: Correções de Médio Prazo (2 semanas)
4. ✅ Ajustar InMemorySettlementLockRepository.save() signature
5. ✅ Implementar countByPaymentId em InMemoryPaymentEventRepository
6. ✅ Normalizar estrutura src/ vs packages/ (definir uma)
7. ✅ Completar implementação ExchangeProvider ou remover

### Fase 3: Melhorias (3+ semanas)
8. ✅ Adicionar mais testes (concorrência, edge cases)
9. ✅ Implementar provedor SOL/Exchange se necessário
10. ✅ Melhorar documentação sincronizada com código
11. ✅ Implementar páginas frontend faltantes
11. ✁ Implementar endpoints API faltantes

## 21. CRITÉRIO DE CONCLUSÃO

O projeto ViaPay será considerado **concluído** quando:

- [ ] Build TypeScript limpo (zero erros `tsc --noEmit`)
- [ ] Todos os endpoints API documentados e funcionando
- [ ] Frontend Next.js com todas as páginas implementadas
- [ ] Dashboard com KPIs reais (vindo de dados DB)
- [ ] Settlement com concorrência funcionando (FOR UPDATE)
- [ ] PIX flow completo (QR Code → Pagamento → Status)
- [ ] Tests unitários e de integração passando
- [ ] Segurança validada (auth, validation, rate limiting)
- [ ] Documentação sincronizada com código
- [ ] Zero imports `../../` em código fonte ativo
- [ ] Observabilidade (logs, métrics, tracing) implementada
- [ ] SDK público funcional `@viapay/sdk`

## 21. ROADMAP TEMPORAL

| Mês | Entregas |
|-----|----------|
| **Mês 1** | Correções críticas (TS config, aliases, Prisma types) |
| **Mês 2** | InMemory repositórios, ExchangeProvider, estrutura definida |
| **Mês 3** | Frontend pages Dashboard, Páginas de pagamento |
| **Mês 4** | API endpoints completos, webhooks, SDK público |
| **Mês 5** | Observabilidade, métricas, tracing, alertas |
| **Mês 6** | Preparação produção, cleanup, documentação final |

## 22. PRÓXIMOS PASSOS IMEDIATOS

1. Corrigir `tsconfig.json` - remover/fixar `include` e `exclude`
2. Fixar exportação em `prisma-payment-event-transaction-repository.ts`
3. Ajustar `in-memory-settlement-lock-repository.ts` assinatura do `save()`
4. Implementar `countByPaymentId` em `in-memory-payment-event-repository.ts`
5. Definir política única de aliases `@/` em todo monorepo
6. Validar build com `pnpm exec tsc --noEmit`

---

*Blueprint finalizado em 2026-10-03*