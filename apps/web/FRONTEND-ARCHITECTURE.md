# VIAPAY — FRONTEND ARCHITECTURE

## Objetivo

Este frontend representa a camada de apresentação da plataforma VIAPAY.

A implementação deve permanecer desacoplada da lógica financeira e dos provedores externos.

## Princípios

- Componentização
- Reutilização
- Separação de responsabilidades
- Design System
- Responsividade
- Acessibilidade
- Estados de loading
- Estados vazios
- Estados de erro
- Estados de sucesso
- Preparação para integração via API

## Áreas

- Dashboard
- Pagamentos
- Checkout
- Clientes
- Carteiras
- Financeiro
- Liquidações
- Recebíveis
- Relatórios
- Webhooks
- Eventos
- Developer Portal
- Segurança
- Configurações

## Checkout

O Checkout possui estados independentes:

- revisão
- método de pagamento
- processamento
- pendente
- sucesso
- falha
- expiração

## Integrações

O frontend não deve conhecer diretamente:

- Stripe SDK
- EFI SDK
- Solana RPC
- Tempo
- Hyperliquid
- Zcash
- PSP específico

Essas integrações pertencem à camada de backend.

O frontend conversa com contratos da API VIAPAY.

## API

A camada `lib/api` funciona como ponto de entrada para futuras integrações.

## Segurança

Nunca colocar no frontend:

- secret keys
- private keys
- tokens administrativos
- credenciais de PSP
- credenciais bancárias
- chaves blockchain privadas

## Próxima fase

Conectar os componentes às APIs reais, mantendo os contratos existentes.
