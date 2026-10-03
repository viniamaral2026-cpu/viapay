# VIAPAY Banking Infrastructure

## Objetivo

Criar infraestrutura tecnológica para que bancos e instituições financeiras possam integrar pagamentos nacionais e internacionais através de APIs, SDKs e adapters.

## Princípio

O banco mantém seu Core Banking.

O VIAPAY fornece uma camada de infraestrutura e orquestração.

## Fluxo

Bank Frontend
→ Bank Core API
→ Bank Gateway
→ Adapter bancário
→ Core Banking

Para pagamentos internacionais:

Bank
→ VIAPAY
→ FX
→ Payment Rail
→ Settlement
→ Banco destino
→ Beneficiário
