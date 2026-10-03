# VIAPAY — FRONTEND MODULE MAP

Este arquivo registra o mapa inicial de módulos criado pelo scaffold.

## Objetivo

Expandir o frontend para uma plataforma completa de infraestrutura de pagamentos.

## Módulos

- Dashboard
- Pagamentos
- Cobranças
- Payment Links
- Clientes
- Produtos
- Assinaturas
- Invoices
- Reembolsos
- Disputas
- Chargebacks
- PIX
- Liquidações
- Reconciliação
- Carteiras
- Saldos
- Ledger
- Extratos
- Relatórios
- Analytics
- Webhooks
- Developer Portal
- API Keys
- Applications
- Sandbox
- API Explorer
- Integrações
- Segurança
- Configurações
- Administração
- Suporte

## Checkout

O checkout possui fluxo planejado em três fases:

1. Dados
2. Pagamento
3. Confirmação

## Payment Links

O frontend deverá permitir:

- criação;
- edição;
- ativação;
- desativação;
- expiração;
- visualização;
- compartilhamento;
- acompanhamento de conversão;
- associação com produtos;
- associação com clientes;
- métodos de pagamento;
- configurações de checkout.

## Arquitetura

O frontend não deverá colocar regras financeiras críticas diretamente nos componentes React.

Componentes:

UI
↓
Hooks
↓
Services
↓
API
↓
Application Layer
↓
Domain
↓
Infrastructure

## Providers

Integrações financeiras devem ser encapsuladas atrás de adapters.

Exemplo:

PaymentProvider
├── EfiAdapter
├── StripeAdapter
├── PixProviderAdapter
└── FutureProviderAdapter

Blockchain:

BlockchainProvider
├── SolanaAdapter
├── TempoAdapter
├── HyperliquidAdapter
└── ZcashAdapter

Nenhum componente de UI deve depender diretamente de SDK específico de provedor.

## Próxima fase

Este scaffold não é considerado implementação final.

Cada módulo deverá posteriormente receber:

- estados reais;
- loading;
- empty state;
- error state;
- autorização;
- paginação;
- filtros;
- busca;
- mutations;
- validação;
- integração API;
- testes;
- acessibilidade;
- observabilidade;
- controle de permissões.
