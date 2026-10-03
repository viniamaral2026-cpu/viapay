# GAP MATRIX VIAPAY - ESTADO ATUAL vs PROJETADO

## Legend
| Estado | Significado |
|--------|-------------|
| IMPLEMENTADO | Já existe no código |
| IMPLEMENTADO E VALIDADO | Funciona e foi testado |
| PARCIAL | Existe mas com limitações ou bugs |
| QUEBRADO | Não compila ou falha em execução |
| AUSENTE | Não foi desenvolvido ainda |
| NÃO CONFIRMADO | Precisa de validação |

## GAP 1: TS5023 no tsconfig.json

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| tsconfig.json | QUEBRADO (2 erros) | IMPLEMENTADO E VALIDADO | Erros TS5023 impedem build completo | CRÍTICO |
| Ação | Corrigir/remover `include` e `exclude` lines 28 e 33 | Deixar build TypeScript limpo | | |

## GAP 2: Aliases `@/` quebrados

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| process-settlement.ts | QUEBRADO (TS2724) | IMPLEMENTADO E VALIDADO | `PaymentEventTransactionRepository` não exportado do módulo | CRÍTICO |
| apps/web/tsconfig.json | PARCIAL (aliases próprios) | IMPLEMENTADO E VALIDADO | `@/components/...` não mapeados totalmente | ALTO |
| packages/* | VARIADO | PADRONIZADO | Cada pacote tem configuração própria | ALTO |
| Ação | Corrigir exportação ou ajuste import | Aliases consistentes em todo monorepo | | |

## GAP 3: Mismatch Prisma JsonNull vs InputJsonValue

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| prisma-payment-event-transaction-repository.ts:70 | QUEBRADO | IMPLEMENTADO E VALIDADO | Type mismatch no método `append()` | CRÍTICO |
| Ação | Ajustar tipo do payload para InputJsonValue | Método create/append compatível com Prisma 7.10.0 | | |

## GAP 4: InMemorySettlementLockRepository.save() signature mismatch

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| in-memory-settlement-lock-repository.ts | QUEBRADO | IMPLEMENTADO E VALIDADO | Interface espera `save(tx, settlement)`, implementação tem `save(settlement)` | ALTO |
| Ação | Ajustar assinatura para incluir `transaction: unknown` parâmetro | Implementação compatível com SettlementLockRepository | | |

## GAP 5: InMemoryPaymentEventRepository faltando countByPaymentId

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| in-memory-payment-event-repository.ts | QUEBRADO | IMPLEMENTADO E VALIDADO | Interface exige `countByPaymentId`, método não implementado | ALTO |
| Ação | Implementar método `countByPaymentId(transaction, paymentId)` | Interface PaymentEventTransactionRepository completa | | |

## GAP 6: Duplicação src/ vs packages/

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| src/ e packages/ | PARCIAL (código em ambos) | DEFINIDO UMA ESTRUTURA | Código existe em ambas estruturas causando confusão | MÉDIO |
| Ação | Definir estrutura única (src/ OU packages/) e migrar | Consistência em todo monorepo | | |

## GAP 7: Web aliases `@/components/` não mapeados

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| apps/web/tsconfig.json | QUEBRADO (TS2307) | IMPLEMENTADO E VALIDADO | Múltiplos erros Cannot find module '@/components/...' | ALTO |
| Ação | Adicionar paths `@/components/*` → `./components/*` ou usar aliases consistentes | Build Next.js web sem erros de módulo | | |

## GAP 8: Two PaymentStatus definitions

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| packages/domain/src/payment/payment-status.ts vs src/domain/entities/payment.ts | PARCIAL | CONSOLIDADO | Duas definições de PaymentStatus e Payment entity | MÉDIO |
| Ação | Consolidar em uma única definição | Tipagem consistente em todo projeto | | |

## GAP 9: InMemory repositórios incompletos

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| tests/unit/ | QUEBRADO | IMPLEMENTADO E VALIDADO | Múltiplos tests falham por interface/implementação mismatch | ALTO |
| Ação | Implementar métodos faltantes e assinaturas compatíveis | Todos os tests unitários passando | | |

## GAP 10: ExchangeProvider vazio

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| packages/infrastructure/src/exchange/ | AUSENTE | IMPLEMENTADO (ou removido) | Diretório vazio, interface definida mas não implementada | BAIXO |
| Ação | Implementar cotação BRL→USDC ou remover interface/imports não usados | Código limpo, sem dead code | | |

## GAP 11: PaymentEvents countByPaymentId

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| PrismaPaymentEventTransactionRepository | PARCIAL | IMPLEMENTADO E VALIDO | Método exists em interface mas inconsistente em implementação | ALTO |
| Ação | Consistência entre interface Prisma e métodos implementados | countByPaymentId funcional e tipado | | |

## GAP 12: Settlement concorrência FOR UPDATE

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| ProcessSettlement use case | PARCIAL | IMPLEMENTADO E VALIDADO | Lógica FOR UPDATE existe mas type errors quebram execução | ALTO |
| Ação | Corrigir type errors (PrismaTransactionClient casting) | Settlement concorrência funcionando sem erros de tipo | | |

## GAP 12: Webhooks implementation

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| packages/infrastructure/src/webhooks/ | AUSENTE | IMPLEMENTADO | Endpoints e lógica de webhooks não implementados | ALTO |
| Ação | Implementar endpoints Fastify + validação de assinatura | Webhooks recebendo e processando eventos | | |

## GAP 13: SDK público

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| packages/sdk/ | PARCIAL | IMPLEMENTADO E PUBLICADO | Classe ViaPay existe mas métodos são stubs que lançam "Not implemented" | ALTO |
| Ação | Implementar métodos payments.create() e payments.get() funcionals | SDK pronto para consumo | | |

## GAP 14: Dashboard com dados reais

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| apps/web/dashboard/ | PARCIAL | IMPLEMENTADO E VALIDADO | Páginas existem mas KPIs vêm de dados mockados | MÉDIO |
| Ação | Conectar componentes a API real / Mock service | Dashboards com dados reais do backend | | |

## GAP 15: Observabilidade completa

| Módulo | Estado Atual | Estado Projetado | Gap | Prioridade |
|--------|-------------|------------------|-----|------------|
| Logs, Métricas, Tracing | AUSENTE | IMPLEMENTADO | Estrutura de observabilidade não implementada | MÉDIO |
| Ação | Implementar OpenTelemetry, logs estruturados, métricas | Plataforma observável desde o início | | |

## RESUMO EXECUTIVO DOS GAPS

| Prioridade | Quantidade | Módulos Afetados |
|------------|------------|------------------|
| CRÍTICO | 4 | TS config, aliases @/, Prisma types, InMemory repos |
| ALTO | 6 | Web aliases, InMemory repos, Settlement concorrência, Exchange, Webhooks, SDK |
| MÉDIO | 4 | Duplicação src/ vs packages/, PaymentStatus consolidated, Dashboard dados reais, Observabilidade |
| BAIXO | 2 | ExchangeProvider vazio, some testes |

### Sequência de Correção Recomendada

```
FASE 1 (1 semana): TS5023 + Aliases @/ críticos
  → tsconfig.json include/exclude
  → process-settlement.ts export fix
  → prisma-payment-event-repository.ts tipos

FASE 2 (2 semanas): InMemory repositórios + Web aliases
  → in-memory-settlement-lock-repository.ts save()
  → in-memory-payment-event-repository.ts countByPaymentId()
  → apps/web/tsconfig.json paths

FASE 3 (3 semanas): Completeness + Integração
  → ExchangeProvider implement/remove
  → Webhooks Fastify endpoints
  → SDK methods reais
  → Dashboard conectado a API
  → Observabilidade básica

FASE 4 (em andamento): Prod ready
  → Todos os gaps fechados
  → Build limpo tsc --noEmit
  → Tests passando
  → Deploy preparation
```

---

*GAP Matrix gerado em 2026-10-03 a partir da auditoria técnica completa*