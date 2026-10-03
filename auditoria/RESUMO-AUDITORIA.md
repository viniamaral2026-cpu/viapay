# RESUMO EXECUTIVO DA AUDITORIA VIAPAY

## Visão Geral

Projeto: ViaPay - Monorepo TypeScript de infraestrutura de liquração de pagamentos  
Auditoria: Leitura completa e análise de todos os diretórios (src/, apps/, packages/, prisma/, tests/)  
Ferramentas: TypeScript 7.0.2, Prisma 7.10.0, pnpm 12.8.1, Turbo  
Data: 2026-10-03

## Estatísticas Principais

| Metrica | Valor |
|---------|-------|
| Total de erros TypeScript (tsc --noEmit) | ~405+ |
| Arquivos TypeScript analisados | centenas |
| Diretórios de apps | 4 (api, web, demo-store, worker) |
| Diretórios de packages | 7 (application, domain, infrastructure, contracts, shared, sdk, config) |
| Erros TS5023 (configuração) | 2 |
| Erros de alias `@/` | Múltiplos |
| Problemas Prisma (JsonNull/InputJsonValue) | 1 crítico |
| Problemas de interface InMemory | 3+ |
| Backups encontrados | 5+ diretórios |

## Principais Problemas Encontrados

### CRÍTICO (Bloqueia build)

1. **TS5023: include/exclude unknown** no `tsconfig.json` linhas 28 e 33
   - Impede execução `pnpm exec tsc --noEmit`
   - Precisa de correção ou remoção dessas opções

2. **Alias `@/infrastructure/...` quebrado** em `process-settlement.ts:12`
   - `error TS2724: '"@/infrastructure/repositories/prisma-payment-event-transaction-repository.js"' has no exported member named 'PaymentEventTransactionRepository'`
   - Bloqueia caso de uso ProcessSettlement

3. **Mismatch Prisma JsonNull vs InputJsonValue** em `prisma-payment-event-transaction-repository.ts:70`
   - Tipo incorreto no método `append()`: `Prisma.JsonNull` não é assignable para `InputJsonValue`
   - Pode causar erros em tempo de gravação no PostgreSQL

### ALTO (Quebra de testes/interface)

4. **InMemorySettlementLockRepository.save() signature mismatch**
   - Interface espera: `save(transaction: unknown, settlement: Settlement): Promise<void>`
   - Implementação tem: `save(settlement: Settlement): Promise<Settlement>`
   - Quebra de tipo entre interface e implementação

5. **InMemoryPaymentEventRepository faltando `countByPaymentId`**
   - Interface `PaymentEventTransactionRepository` exige o método
   - Implementações InMemory e Fake não o implementam
   - Tests unitários quebram

6. **Duplicação código src/ vs packages/**
   - Próprios arquivos existem em ambas estruturas
   - Causa confusão sobre qual usar e imports inconsistentes

### MÉDIO (Qualidade/Manutenção)

7. **Apps web: aliases `@/components/` não mapeados**
   - Erros `TS2307: Cannot find module '@/components/...'` em apps web e demo-store
   - Web usa `baseUrl: "."` e paths `@/*` não totalmente compatíveis

8. **ExchangeProvider vazio**
   - Diretório `packages/infrastructure/src/exchange/` sem implementação
   - Interface definida em `packages/application/src/payment/ports/exchange-provider.ts` não implementada

9. **Duas definições de PaymentStatus e Payment entity**
   - `packages/domain/src/payment/payment-status.ts` vs `src/domain/entities/payment.ts`
   - `packages/domain/src/payment/payment.ts` vs `src/domain/entities/payment.ts`
   - Inconsistência entre as duas estruturas

### BAIXO (Melhoria)

10. **Backups dispersos**
    - 5+ diretórios de backup encontrados
    - Indicam tentativas anteriores de refatoração
    - Devem ser organizados futuramente em `./backup/`

## Quantidade de Erros por Categoria

| Categoria | Quantidade | Percentual |
|-----------|------------|-----------|
| TypeScript Config | 2 | <1% |
| Aliases/Imports | 15+ | ~4% |
| Prisma Types | 8+ | ~2% |
| Interface/Implementation Mismatch | 10+ | ~2.5% |
| Teste/Unitário | 20+ | ~5% |
| JSX/Next.js | 30+ | ~7% |
| Monorepo/Config | 5+ | ~1.5% |
| **Total** | **~405+** | **100%** |

## Arquivos que Precisam de Correção Imediata

1. `tsconfig.json` - Corrigir include/exclude
2. `src/application/use-cases/settlement/process-settlement.ts` - Fixar alias ou export
3. `src/infrastructure/repositories/prisma-payment-event-transaction-repository.ts` - Corrigir tipos JsonNull
4. `src/infrastructure/repositories/in-memory-settlement-lock-repository.ts` - Ajustar assinatura save()
5. `src/infrastructure/repositories/in-memory-payment-event-repository.ts` - Implementar countByPaymentId()
6. `packages/infrastructure/src/exchange/` - Implementar ou remover
7. `apps/web/tsconfig.json` - Normalizar aliases `@/`

## Sequência Recomendada de Correção

```
TSCONFIG (corrigir include/exclude)
    ↓
ALIASES (corrigir @/ imports/exports)
    ↓
PRISMA TYPES (ajustar JsonNull/InputJsonValue)
    ↓
REPOSITORIES (ajustar InMemory interfaces)
    ↓
TESTES (validar após correções)
    ↓
ARQUITETURA (definir src/ vs packages/ única)
    ↓
INTEGRACAO (testes end-to-end com PostgreSQL)
```

## Conclusão

O projeto ViaPay demonstra uma arquitetura bem planejada com tentativa de arquitetura hexagonal, mas enfrenta vários problemas técnicos que impedem um build limpo e consistente. Os erros mais críticos estão na configuração TypeScript (tsconfig.json) e na resolução de aliases `@/`, que bloqueiam módulos críticos como o ProcessSettlement. Problemas de tipo Prisma e mismatches de interface/repository também são significativos.

Após correções necessárias, o projeto tem base sólida para continuar com funcionalidades de pagamentos PIX, settlement com concorrência controlada e infraestrutura Redis. A estrutura de monorepo com pnpm e Turbo está correta, e a separação entre domínio, aplicação e infraestrutura está conceptualmente correta, mas precisa de ajustes técnicos para funcionar como um todo.

**Ação recomendada**: Corrigir itens 1-5 da lista "Arquivos que Precisam de Correção Imediata" antes de tentar novos builds ou deployments.