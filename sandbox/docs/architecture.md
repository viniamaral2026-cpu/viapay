# ViaPay Sandbox Architecture

## 1. Objetivo

O Sandbox deve reproduzir os contratos públicos da plataforma
sem executar operações financeiras reais.

## 2. Componentes

Developer Portal
Sandbox API
Authentication
Payment Simulator
FX Simulator
Settlement Simulator
Webhook Simulator
Test Ledger
Test Database
Event Bus
Observability

## 3. Isolamento

O Sandbox deve possuir:

- banco separado;
- Redis separado;
- RabbitMQ namespace separado;
- API credentials separadas;
- webhook signing secrets separados;
- logs separados;
- métricas separadas;
- storage separado.

## 4. Arquitetura

                   DEVELOPER
                       |
                       v
                DEVELOPER PORTAL
                       |
                       v
                  SANDBOX API
                       |
        +--------------+--------------+
        |              |              |
     Payments          FX          Webhooks
        |              |              |
        +--------------+--------------+
                       |
                 TEST LEDGER
                       |
                 RECONCILIATION

## 5. Princípio

A implementação do Sandbox deve respeitar os mesmos contratos
de API planejados para produção.

O comportamento financeiro é simulado.

A interface de integração deve ser o mais próxima possível
da produção.
