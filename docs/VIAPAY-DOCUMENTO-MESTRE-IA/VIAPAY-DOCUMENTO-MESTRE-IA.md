# VIAPAY — DOCUMENTO MESTRE DE VISÃO, ARQUITETURA E CONSTRUÇÃO

**Empresa desenvolvedora:** © 2026 DEEVO Soluções Financeiras LTDA  
**CNPJ:** 63.187.175/0001-70  
**Produto / nome de trabalho:** VIAPAY  
**Natureza:** infraestrutura tecnológica de pagamentos e interoperabilidade financeira

## 1. PROPÓSITO

Este documento consolida a visão definida para o VIAPAY e deve servir como fonte de verdade para uma IA de produto, arquitetura, UX/UI, engenharia, documentação e construção.

O VIAPAY não deve ser tratado apenas como carteira ou checkout. A proposta é uma infraestrutura de pagamentos interoperáveis:

> O comprador paga na sua própria moeda. O comerciante define e recebe na sua moeda. O VIAPAY coordena conversão, roteamento, compliance, liquidação, reconciliação e integração com instituições financeiras.

A solução deve poder ser licenciada, integrada, incorporada ou white-labeled por bancos, instituições financeiras, fintechs e, quando juridicamente aplicável, operadores públicos.

## 2. POSICIONAMENTO DA DEEVO

A DEEVO é a empresa de tecnologia desenvolvedora. O objetivo não é substituir bancos, mas fornecer infraestrutura para que instituições possam oferecer pagamentos globais.

Frase-base:

> “A DEEVO não pretende ser o banco. Pretende construir a infraestrutura tecnológica que permite aos bancos serem mais globais.”

A instituição participante mantém, conforme o arranjo e a legislação, responsabilidades como relacionamento com cliente, contas, custódia, serviços regulados, compliance, câmbio e liquidação financeira. A DEEVO fornece tecnologia.

## 3. VIAPAY COMO WORKING NAME

VIAPAY é o nome de trabalho atual. Deve ser arquitetado para white-label/private-label.

Exemplo:

```text
BANCO XYZ
Global Pay
Powered by DEEVO Technology
```

A instituição pode alterar marca, nome e identidade sem alterar o núcleo tecnológico.

## 4. VISÃO DO PRODUTO

A experiência deve esconder a complexidade de:

- câmbio;
- blockchain;
- stablecoins;
- rails;
- PSPs;
- settlement;
- off-ramp;
- APIs bancárias;
- reconciliação.

Fluxo:

```text
CLIENTE
paga na sua moeda
       ↓
VIAPAY
       ↓
conversão + routing + compliance
       ↓
settlement
       ↓
BANCO DO VENDEDOR
       ↓
vendedor recebe na sua moeda
```

## 5. EXEMPLO PRINCIPAL

Comerciante brasileiro:

```text
Produto: R$ 109,00
```

Cliente na China acessa o checkout e vê o equivalente em CNY.

```text
Produto: R$ 109,00
Você pagará aproximadamente: ¥ XXX,XX
[ PAGAR ]
```

O comerciante não precisa alterar o preço para CNY.

O VIAPAY:

1. identifica moeda de origem;
2. identifica moeda de destino;
3. identifica comerciante;
4. obtém/recebe cotação aplicável;
5. calcula o valor;
6. aplica regras institucionais;
7. autentica;
8. executa risco/compliance;
9. escolhe o rail;
10. executa conversão/settlement;
11. coordena liquidação;
12. registra eventos;
13. concilia;
14. confirma o crédito no destino.

## 6. EXPERIÊNCIA DO LOJISTA

O lojista deve informar apenas o preço na moeda local.

```text
Preço: R$ 109,00
[ PUBLICAR ]
```

Não deve precisar operar manualmente:

- câmbio;
- blockchain;
- carteira;
- PSP;
- settlement;
- reconciliação.

Mas deve possuir transparência:

```text
Venda                         R$ 109,00
Taxas                         R$ X,XX
Tributos/retenções aplicáveis R$ X,XX
Outros custos                 R$ X,XX
---------------------------------------
Líquido recebido              R$ XX,XX
```

“Não se preocupar” significa não executar a complexidade manualmente, não ocultar informações.

## 7. FLUXO FINANCEIRO

```text
CLIENTE
CNY
  ↓
VIAPAY
  ├─ Identity
  ├─ FX Engine
  ├─ Payment Router
  ├─ Risk
  ├─ Compliance
  ├─ Fee Engine
  ├─ Tax/Retention Rules
  ├─ Ledger
  ├─ Settlement
  └─ Reconciliation
  ↓
BLOCKCHAIN / BANKING RAIL
  ↓
OFF-RAMP / INSTITUIÇÃO FINANCEIRA
  ↓
BANCO DO VENDEDOR
  ↓
BRL
```

## 8. BLOCKCHAIN

Blockchain pode ser um rail intermediário de liquidação.

O VIAPAY não deve ser definido como uma blockchain nem ficar preso a uma única rede.

```text
BlockchainProvider
├── SolanaAdapter
└── FutureAdapter
```

Solana é uma candidata para uma implementação inicial por sua infraestrutura de pagamentos, stablecoins, transações rápidas, QR/payment links e APIs/SDKs.

A inovação da DEEVO não é recriar Solana. É criar a camada de orquestração bancária/global acima dos rails.

## 9. EXEMPLO COM SOLANA

Conceito:

```text
CLIENTE
US$ 100
   ↓
VIAPAY
   ├─ identificação
   ├─ cotação
   ├─ compliance
   └─ routing
   ↓
ATIVO DE LIQUIDAÇÃO
ex.: stablecoin
   ↓
SOLANA
   ↓
OFF-RAMP / SETTLEMENT PROVIDER
   ↓
BANCO DO VENDEDOR
   ↓
MOEDA LOCAL
```

O usuário não precisa possuir SOL, conhecer blockchain, usar RPC ou pagar gas diretamente. A infraestrutura deve abstrair esses elementos quando tecnicamente e juridicamente possível.

## 10. IMPORTANTE SOBRE SOLANA

Não dizer que “o dólar vira a moeda da Solana”.

Solana é a rede. Um ativo de liquidação, como uma stablecoin, pode ser utilizado conforme o desenho jurídico, regulatório e operacional.

## 11. OFF-RAMP

Blockchain não transforma automaticamente ativo digital em saldo bancário.

Deve existir:

```text
Blockchain
↓
Off-ramp / Settlement Provider
↓
Sistema financeiro
↓
Conta bancária
```

O VIAPAY orquestra a integração; a DEEVO não deve ser presumida como instituição financeira.

## 12. PAYMENT ROUTER

O Payment Router é componente central.

Deve:

- identificar origem/destino;
- avaliar rails;
- verificar custos;
- verificar disponibilidade;
- verificar regras;
- selecionar caminho;
- aplicar fallback;
- registrar decisão;
- executar/delegar settlement.

```text
Payment Router
├── Banking Rail
├── PSP
├── PIX
├── SEPA/etc.
├── Blockchain
├── Solana
├── Stablecoin Rail
└── Future Rail
```

## 13. PAYMENT PROVIDER ABSTRACTION

Nunca acoplar domínio a provider.

```text
PaymentProvider
├── StripeAdapter
├── EfiAdapter
├── BankingAdapter
├── PixAdapter
├── SolanaAdapter
└── FutureAdapter
```

Stripe e Efí são integrações, não o domínio.

## 14. STRIPE E EFÍ

Stripe:

```text
VIAPAY DOMAIN
↓
PaymentProvider
↓
StripeAdapter
↓
Stripe
```

Efí:

```text
VIAPAY
↓
EfiAdapter
↓
Efí
↓
Pix / serviços disponíveis
```

As integrações devem ficar isoladas e substituíveis.

## 15. RELAÇÃO COM PIX

Não declarar que o VIAPAY reproduz a tecnologia proprietária do Pix.

A analogia é de experiência:

```text
PIX:
usuário paga → infraestrutura nacional → destinatário recebe

VIAPAY:
usuário paga na sua moeda → conversão/routing/settlement → destinatário recebe na moeda local
```

O VIAPAY pode integrar Pix quando permitido.

## 16. EXPERIÊNCIA “PIX GLOBAL”

A documentação técnica deve preferir “infraestrutura global de pagamentos interoperáveis”.

Corredores possíveis:

```text
China → Brasil
Brasil → Europa
Europa → EUA
EUA → Japão
Japão → Brasil
```

O comprador paga na sua moeda. O vendedor recebe na sua moeda. A complexidade fica na infraestrutura.

## 17. CONFIGURAÇÃO DO BANCO

O banco/instituição deve ter painel para configurar:

- moedas;
- corredores;
- regras cambiais;
- spread;
- tarifas;
- limites;
- contas;
- settlement;
- PSPs;
- rails;
- compliance;
- risco;
- retenções;
- regras tributárias;
- aprovação manual;
- fallback;
- disponibilidade;
- webhooks;
- reconciliação;
- relatórios;
- auditoria.

Exemplo:

```text
CNY → BRL
Ativo: SIM
Limite: R$ 50.000
FX Provider: Banco X
Settlement: Rail A
Fallback: Rail B
```

O banco configura; a plataforma executa.

## 18. RESPONSABILIDADE REGULATÓRIA

Separar software de atividades reguladas.

A DEEVO pode fornecer:

- software;
- APIs;
- SDK;
- orchestration;
- routing;
- ledger tecnológico;
- webhooks;
- observabilidade;
- reconciliation tooling;
- adapters.

Instituições autorizadas podem responder por:

- custódia;
- câmbio;
- liquidação;
- contas;
- serviços de pagamento;
- compliance;
- obrigações regulatórias e tributárias.

Não afirmar que a DEEVO poderá executar atividade regulada sem validação jurídica/jurisdicional.

## 19. MODELO ECONÔMICO

Uma operação pode envolver cliente, bancos/PSPs, VIAPAY, rails, instituições de settlement e comerciante.

Cada participante pode ter custos, tarifas ou receitas conforme contratos e regulamentação.

Não inventar percentuais.

## 20. CHECKOUT

Suportar, conforme integrações:

- moeda local;
- preço original;
- conversão;
- QR;
- payment link;
- cartão;
- conta bancária;
- wallet;
- confirmação;
- sucesso;
- falha;
- expiração;
- retry;
- refund.

Fluxo:

```text
Checkout
↓
Payment Intent
↓
Quote
↓
Authorization
↓
Payment
↓
Settlement
↓
Success
```

## 21. PAYMENT INTENT

Campos conceituais:

- id;
- merchantId;
- customerId;
- amount;
- currency;
- destinationCurrency;
- quoteId;
- status;
- paymentMethod;
- provider;
- rail;
- idempotencyKey;
- expiresAt;
- metadata;
- createdAt;
- updatedAt.

## 22. ESTADOS DE PAGAMENTO

Exemplo:

```text
CREATED
PENDING
AUTHORIZED
PROCESSING
SETTLEMENT_PENDING
SETTLED
FAILED
CANCELLED
REFUNDED
PARTIALLY_REFUNDED
EXPIRED
```

Validar estados definitivos conforme domínio real.

## 23. LEDGER

Operações financeiras devem ter ledger robusto.

Evitar apagar transações. Correções devem usar lançamentos compensatórios/eventos quando aplicável.

Tipos conceituais:

```text
Debit
Credit
Fee
Tax
Refund
Adjustment
Settlement
Reversal
```

## 24. IDEMPOTÊNCIA

Obrigatória em operações críticas:

- criação de pagamento;
- confirmação;
- refund;
- payout;
- settlement;
- webhook processing.

Uma requisição repetida não pode criar uma segunda operação financeira.

## 25. WEBHOOKS

```text
Event
↓
Signature validation
↓
Idempotency
↓
Persistence
↓
Queue
↓
Consumer
↓
Domain action
```

Suportar:

- retry;
- DLQ;
- reprocessamento;
- assinatura;
- logs;
- tentativas;
- status.

## 26. EVENT-DRIVEN

Eventos conceituais:

```text
PaymentCreated
PaymentAuthorized
PaymentProcessing
PaymentSettled
PaymentFailed
PaymentRefunded
QuoteCreated
SettlementCreated
SettlementCompleted
SettlementFailed
WebhookReceived
WebhookProcessed
ReconciliationCompleted
```

## 27. RECONCILIATION

Comparar:

```text
VIAPAY Ledger
+
Provider
+
Banco
+
Blockchain
+
Settlement
```

Detectar divergências, duplicidades, transações ausentes, valores diferentes, status divergentes e atrasos.

## 28. SEGURANÇA

Prever:

- OAuth/OIDC;
- MFA;
- RBAC;
- API keys;
- secrets management;
- encryption;
- rate limiting;
- audit logs;
- session management;
- webhook signatures;
- idempotency;
- anti-fraud;
- monitoring.

## 29. COMPLIANCE

Prever:

- KYC;
- KYB;
- AML/CFT;
- sanctions screening;
- transaction monitoring;
- risk scoring;
- velocity limits;
- suspicious activity workflows;
- audit trail;
- data retention;
- privacy.

## 30. LGPD E PRIVACIDADE

Implementar:

- minimização;
- finalidade;
- controle de acesso;
- criptografia;
- retenção;
- exclusão quando legalmente possível;
- auditoria;
- segregação;
- proteção de PII.

## 31. API-FIRST

Exemplos conceituais:

```text
POST /v1/payment-intents
GET  /v1/payment-intents/{id}
POST /v1/payment-intents/{id}/confirm
POST /v1/payments/{id}/refund
GET  /v1/payments/{id}
GET  /v1/quotes
POST /v1/settlements
GET  /v1/transactions
GET  /v1/reconciliation
POST /v1/webhooks
```

Não considerar os endpoints acima contrato definitivo sem auditoria.

## 32. SDK

Possíveis SDKs:

```text
viapay-js
viapay-php
viapay-node
viapay-java
viapay-python
viapay-android
viapay-ios
```

Facilitar checkout, payment intent, QR, payment links, status e webhooks.

## 33. DEVELOPER PORTAL

Incluir:

- API Keys;
- aplicações;
- OAuth;
- documentação;
- OpenAPI;
- API Explorer;
- sandbox;
- webhooks;
- logs;
- eventos;
- exemplos;
- SDK;
- status.

## 34. SANDBOX

Permitir:

- pagamentos simulados;
- falhas;
- refunds;
- settlement;
- webhooks;
- moedas;
- providers;
- estados.

## 35. OBSERVABILIDADE

Implementar:

- logs estruturados;
- métricas;
- traces;
- correlation IDs;
- OpenTelemetry;
- health checks;
- provider health;
- blockchain health;
- queue health;
- settlement health;
- alerting.

## 36. STACK

Auditar primeiro a stack real do repositório.

Diretrizes:

```text
Frontend: Next.js / React / TypeScript
Backend: Node.js/TypeScript quando compatível com o projeto existente
Database: PostgreSQL
Cache: Redis
Messaging: RabbitMQ ou infraestrutura existente
Observability: OpenTelemetry
Containers: Docker
Architecture: Clean Architecture, DDD, SOLID, API First, Event Driven
```

Não substituir tecnologia sem justificar.

## 37. FRONTEND

Expandir o frontend para produto enterprise completo:

- landing;
- cadastro;
- login;
- onboarding;
- checkout;
- sucesso;
- dashboard;
- pagamentos;
- detalhes;
- clientes;
- comerciantes;
- carteiras;
- liquidações;
- reconciliação;
- relatórios;
- documentação;
- webhooks;
- API;
- segurança;
- administração;
- developer portal;
- configurações.

Cada módulo deve possuir páginas, subpáginas, componentes, estados, loading, erro, vazio, sucesso, permissões, API, validações e testes.

## 38. DESIGN SYSTEM

Diretrizes:

- enterprise;
- branco predominante;
- azul institucional;
- azul claro;
- ciano;
- espaço em branco;
- alta legibilidade;
- acessibilidade;
- responsividade.

Componentes:

- Button;
- Input;
- Card;
- Table;
- Badge;
- Modal;
- Drawer;
- Dropdown;
- Tabs;
- Charts;
- Alert;
- Toast;
- Empty State;
- Loading;
- Skeleton;
- Error State;
- Confirmation.

## 39. REPOSITÓRIO EXISTENTE

Estrutura atual conhecida:

```text
/mnt/ai-knowledge/viapay

apps/
├── api
├── demo-store
├── web
└── worker
```

Frontend:

```text
apps/web
```

Backend:

```text
apps/api
```

Worker:

```text
apps/worker
```

Demo:

```text
apps/demo-store
```

A IA deve auditar antes de modificar.

## 40. ROTAS FRONTEND ATUAIS

```text
/cadastro
/checkout/[paymentId]
/checkout/[paymentId]/success
/como-funciona
/contato
/dashboard
/dashboard/carteiras
/dashboard/configuracoes
/dashboard/documentacao
/dashboard/liquidacoes
/dashboard/pagamentos
/dashboard/pagamentos/[id]
/dashboard/webhooks
/empresa
/login
/
/precos
```

Componentes existentes incluem:

```text
Badge
BrandMark
Button
Card
PaymentSummary
QRCode
DashboardShell
Sidebar
StatCard
Footer
LoginForm
RegisterForm
Input
Logo
Navbar
```

A IA deve auditar e expandir.

## 41. DOCUMENTAÇÃO DE ENGENHARIA

Produzir documentação abrangente:

```text
00 MASTER
01 PRODUTO
02 UX/UI
03 FRONTEND
04 BACKEND
05 API
06 PAGAMENTOS
07 PIX
08 SETTLEMENT
09 FINANCEIRO
10 CLIENTES
11 MERCHANTS
12 ADMIN
13 DEVELOPER PORTAL
14 WEBHOOKS
15 EVENT-DRIVEN
16 DATABASE
17 SEGURANÇA
18 OBSERVABILIDADE
19 TESTES
20 DEVOPS
21 AUDITORIA
22 INTEGRAÇÕES
23 OPERAÇÕES
```

Não produzir somente README.

## 42. ROADMAP

### Fase 1 — Fundação
Auditoria, arquitetura, domínio, banco, API, autenticação, frontend, design system.

### Fase 2 — Payments
Payment Intent, checkout, payment, refund, webhook, idempotência.

### Fase 3 — Banking
Providers, Efí, Stripe, Pix, settlement, reconciliation.

### Fase 4 — Global Payments
FX, multi-currency, corridors, routing, compliance internacional.

### Fase 5 — Blockchain
Blockchain adapter, Solana, stablecoin rail, wallet abstraction, settlement, off-ramp.

### Fase 6 — Enterprise
Banco dashboard, developer portal, SDK, white-label, multi-tenant, enterprise security.

### Fase 7 — Institutional
Bancos, instituições, operadores e parceiros públicos quando aplicável.

## 43. REGRAS ARQUITETURAIS

Nunca:

```text
Domain → Stripe diretamente
Domain → Efí diretamente
Domain → Solana diretamente
```

Sempre:

```text
Domain
↓
Interface
↓
Adapter
↓
Provider/Rail
```

## 44. O QUE A IA NÃO DEVE FAZER

- inventar integrações;
- declarar suporte sem verificar;
- afirmar aprovação regulatória inexistente;
- tratar blockchain como banco;
- assumir regras tributárias universais;
- prender o sistema a uma única blockchain;
- remover controles de compliance;
- colocar secrets no frontend;
- acoplar domínio a provider;
- apagar dados financeiros;
- criar saldo sem ledger;
- declarar settlement sem confirmação;
- confiar cegamente em webhook;
- declarar produção pronta com mocks.

## 45. PROCESSO OBRIGATÓRIO DA IA

Antes de alterar código:

1. auditar repositório;
2. mapear pastas;
3. identificar stack;
4. identificar páginas;
5. identificar componentes;
6. identificar APIs;
7. identificar banco;
8. identificar integrações;
9. identificar testes;
10. identificar gaps;
11. gerar plano;
12. implementar incrementalmente;
13. testar;
14. validar build;
15. atualizar documentação.

## 46. DEFINITION OF DONE

Quando aplicável:

```text
[ ] UX
[ ] UI
[ ] Página
[ ] Estados
[ ] Componentes
[ ] API
[ ] Validação
[ ] Autorização
[ ] Persistência
[ ] Eventos
[ ] Webhooks
[ ] Idempotência
[ ] Logs
[ ] Auditoria
[ ] Testes
[ ] Documentação
[ ] Error handling
[ ] Observabilidade
[ ] Segurança
[ ] Build
[ ] Integração
```

## 47. VISÃO DE LONGO PRAZO

```text
                 DEEVO
                   |
        GLOBAL PAYMENT LAYER
                   |
      +------------+------------+
      |            |            |
   Banking      Blockchain    PSP
    Rails         Rails       Rails
      |            |            |
      +------------+------------+
                   |
               Settlement
                   |
             Local Currency
```

O VIAPAY deve ser uma camada de interoperabilidade.

## 48. RESUMO EXECUTIVO

> O VIAPAY é uma infraestrutura tecnológica de pagamentos globais interoperáveis desenvolvida pela DEEVO, capaz de conectar bancos, instituições financeiras, PSPs, sistemas de pagamento e rails blockchain para permitir que compradores paguem na sua moeda e comerciantes recebam na sua moeda, com conversão, roteamento, compliance, settlement e reconciliação orquestrados pela plataforma.

O cliente não precisa entender a infraestrutura.

O comerciante não precisa operar manualmente câmbio ou blockchain.

O banco controla as regras pelo painel.

A DEEVO fornece tecnologia.

Blockchain pode ser um rail invisível de liquidação.

Solana pode ser uma implementação inicial, sem dependência arquitetural exclusiva.

Stripe, Efí, bancos, Pix, Solana e outros sistemas são adapters/integrations.

O produto deve ser enterprise, API-first, modular, seguro, observável, auditável, multi-tenant, white-label e preparado para expansão internacional.

## 49. FRASES-CHAVE

> O cliente paga na moeda dele. O comerciante recebe na moeda dele. O VIAPAY cuida da complexidade.

> A DEEVO não quer substituir os bancos. Quer fornecer a tecnologia para conectá-los.

> Blockchain é um rail invisível de liquidação, não o produto inteiro.

> VIAPAY é o nome de trabalho; a tecnologia pode ser white-labeled.

> A experiência é local. A infraestrutura é global.

## 50. INSTRUÇÃO FINAL PARA A IA

Use este documento como visão arquitetural e de produto.

Não trate nenhuma parte conceitual como implementação existente sem verificar o repositório.

Quando houver diferença entre visão e código:

1. registrar estado atual;
2. registrar gap;
3. propor alteração;
4. preservar o que estiver correto;
5. implementar incrementalmente;
6. testar;
7. atualizar documentação.

O objetivo não é criar uma demonstração superficial. É evoluir o VIAPAY para uma infraestrutura tecnológica de pagamentos interoperáveis com qualidade enterprise, preparada para integração por bancos, instituições financeiras e parceiros estratégicos, respeitando limitações técnicas, regulatórias e operacionais de cada jurisdição.

**Fim do Documento Mestre.**
