
# Integration Architecture

## Adapters

A plataforma deve tratar integrações externas como adapters.

## Categorias

* banking;
* payment networks;
* FX;
* identity;
* compliance;
* blockchain;
* legacy;
* notification.

## Timeout

Toda chamada externa deve possuir timeout explícito.

## Retry

Retries devem ser:

* limitados;
* exponenciais;
* idempotentes.

## Circuit Breaker

Integrações críticas devem possuir circuit breaker.

## Fallback

Fallback nunca pode causar duplicidade financeira.
