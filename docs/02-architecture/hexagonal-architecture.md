
# Hexagonal Architecture

## Objetivo

Permitir que o núcleo financeiro permaneça independente de tecnologia externa.

## Ports

Exemplos:

* AccountRepository
* LedgerRepository
* PaymentProvider
* FXProvider
* SettlementProvider
* IdentityProvider
* BlockchainProvider
* LegacyBankingProvider

## Adapters

Implementações possíveis:

* PostgreSQLAccountRepository;
* BancoXPaymentAdapter;
* PSPPaymentAdapter;
* SolanaSettlementAdapter;
* LegacyCobolAdapter.

## Benefício

Um banco pode trocar o provedor externo sem alterar as regras do domínio.

## Regra

Nenhum adapter deve implementar regra financeira de negócio que pertença ao
domínio.
