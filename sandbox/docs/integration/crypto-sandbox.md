# Crypto Sandbox

O Crypto Sandbox simula pagamentos blockchain sem movimentar
ativos reais.

Primeiro rail de referência:

Solana

Primeiro asset de referência:

USDC

## Fluxo

Developer
  |
  v
Crypto Payment Intent
  |
  v
Generate Test QR
  |
  v
Simulated Wallet
  |
  v
Simulated Blockchain Transaction
  |
  v
Verification
  |
  v
Payment Confirmed

## Importante

Nenhuma private key real deve ser utilizada.

Nenhuma carteira de produção deve ser utilizada.

Nenhum USDC real deve ser movimentado.

As signatures geradas são fictícias.

## Produção

Na produção o adapter deverá utilizar:

BlockchainProviderPort
SolanaAdapter
Wallet/Signing infrastructure
Transaction verification
RPC provider

O Sandbox apenas simula essas interfaces.
