
# Solana Adapter

## Objetivo

Disponibilizar uma integração desacoplada com a rede Solana quando utilizada
como rail de settlement.

## Interface conceitual

```text
BlockchainProvider

createTransfer()
getTransaction()
getBalance()
estimateFee()
waitConfirmation()
```

## Segurança

Chaves privadas nunca devem ficar:

* no frontend;
* em variáveis expostas;
* em logs;
* em bancos sem proteção adequada.

## Custódia

Para produção institucional, utilizar arquitetura apropriada de key
management/HSM/MPC conforme o modelo de custódia.

## Confirmação

Uma transação blockchain só deve ser marcada como settlement concluído após
cumprir a política de confirmação definida pelo sistema.
