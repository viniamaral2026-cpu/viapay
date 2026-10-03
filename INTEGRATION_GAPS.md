# VIAPAY — INTEGRATION GAPS
# External Integration Gap Analysis

**Data:** 2026-10-03  
**Objective:** Identify gaps between external integrations (providers, banks, blockchain) and requirements

---

## 1. PROVIDER INTEGRATION STATUS

| Provider | Integration Status | Endpoints Impl. | Adapter Status | Priority |
|----------|-------------------|-----------------|----------------|----------|
| **Stripe** | ❌ AUSENTE | 0/15 | Adapter apenas arquitetural (definido em docs) | 🔴 CRÍTICO |
| **Efí** | ❌ AUSENTE | 0/10 | Adapter apenas arquitetural (definido em docs) | 🔴 CRÍTICO |
| **Circle/USDC** | ❌ AUSENTE | 0/8 | Adapter apenas arquitetural; Solana USDC mint não definido | 🔴 CRÍTICO |
| **PIX** | ⚠️ PARCIAL | 3/8 | Implementado no frontend (checkout), mas backend/ API incompleto | 🟠 ALTO |
| **Solana** | ❌ AUSENTE | 0/10 | Adapter conceitual apenas; RPC, wallet, token account não implementados | 🔴 CRÍTICO |
| **Banco Central** | ❌ AUSENTE | 0 | Integração com sistemas nacionais de pagamentos não iniciada | 🔴 CRÍTICO |
| **Bancos Legacy** | ❌ AUSENTE | 0 | Adapters COBOL/REST/SOAP/ISO20022/SFTP não implementados | 🔴 CRÍTICO |
| **Circle CCTP** | ❌ AUSENTE | 0 | Cross-chain transfer protocol para USDC entre blockchains | 🟡 MÉDIA |
| **Payment Orchestration** | ❌ AUSENTE | 0 | Plataformas de orchestration (adyen, etc.) não integradas | 🟡 MÉDIA |

---

## 2. BANK INTEGRATION GAPS

| GAP ID | Área | Gap Descrição | Impacto | Ação Corretiva |
|--------|------|---------------|---------|----------------|
| IN-001 | Core Banking Integration | Integração com Core Banking systems (COBOL, mainframes) não existe | 🔴 CRÍTICO | Criar bank adapters: REST, SOAP, SFTP, ISO20022, MQ; mapear entidades para transformation rules |
| IN-002 | Banco Múltiplo | Sistema preparado para múltiplas instituições financeiras simultâneas | 🟠 ALTO | Adicionar tenantId em entidades críticas; configurar RLS por institution; suportar credenciais múltiplas por tenant |
| IN-003 | ISO 20022 Mensagens | Sistema não gera/consome mensagens ISO20022 para pagamento/settlement | 🟠 ALTO | Criar adapter ISO20022 ou mapear campos internos para formato; essencial para bancos regulados |
| IN-004 | SFTP/File Transfer | Sistema não suporta transferência de arquivos para bancos tradicionais | 🟡 MÉDIA | Implementar support SFTP ou geração de arquivos em formatos esperados por bancos |
| IN-005 | Mensageria (RabbitMQ/Kafka) | Sistema não utiliza filas para processamento assíncrono | 🟡 MÉDIA | Integrar RabbitMQ ou Kafka para: webhook delivery, settlement processing, reconciliation jobs |
| IN-006 | Bank Account Validation | Validação de conta bancária não integrada | 🟡 MÉDIA | Criar adapter ou serviço que valida conta/agência dígito verificação via API ou arquivo de retorno |
| IN-006 | Payout to Bank | Processo de payout para conta bancária não implementado | 🟡 MÉDIA | Implementar flujo: settlement → payout → bank receipt; suportar diferentes formatos de destino |

---

## 3. BLOCKCHAIN / SOLANA INTEGRATION GAPS

| GAP ID | Área | Gap Descrição | Impacto | Ação Corretiva |
|--------|------|---------------|---------|----------------|
| IN-011 | Solana RPC Integration | RPC connection à rede Solana (Devnet/Mainnet) não implementado | 🔴 CRÍTICO | CriarRpcProvider abstraction; configurar endpoint por ambiente (devnet para test, endpoint seguro para prod); implementar retry e backoff |
| IN-012 | USDC Mint Configuration | Mint address USDC na Solana não configurado no sistema | 🔴 CRÍTICO | Definir CRYPTO_SOLANA_USDC_MINT via environment variable; validar em todos operações USDC; valor oficial: EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v |
| IN-013 | Wallet/ATA Management | Wallet address e Token Account (ATA) management não implementado | 🔴 CRÍTICO | Criar abstração: walletAddress, tokenAccount ( Associated Token Account ); suporte create, get balance, transfer |
| IN-014 | Transaction Signature Verification | Verificação de assinatura de transação Solana não implementada | 🔴 CRÍTICO | Implementar verificação usando programa de programa associated token; confirmar signature via RPC |
| IN-015 | Blockchain Monitoring | Monitoramento de confirmações de blockchain não existe | 🟠 ALTO | Criar serviço que polling RPC para confirmacao de transações; definir policy de confirmações mínimas (ex: 1-confirmation para pagamentos de baixo valor, 5+ para alto valor) |
| IN-016 | Blockchain Settlement | Mecanismo de settlement via blockchain não implementado | 🟠 ALTO | Criar serviço que: monitora transactions confirmadas; atualiza status settlement; calcula net amounts após fees |
| IN-016 | Cross-chain (CCTP) | Circle Cross-Chain Transfer Protocol não implementado | 🟡 MÉDIA | Avaliar necessidade; se houver, criar adapter CCTP para movimentar USDC entre Solana, Ethereum, Base, etc. |
| IN-017 | Fee Abstraction | Gas/fees abstraction para transações Solana não existe | 🟡 MÉDIA | Criar mecanismo que paga fees em SOL ou USDC; abstraction para payer payer payer diferentes |
| IN-018 | Transaction Timeout | Timeouts de transação blockchain não definidos | 🟡 MÉDIA | Definir policy: timeout após N segundos sem confirmação; trigger retry ou marque como failed |

---

## 4. FX / CURRENCY INTEGRATION GAPS

| GAP ID | Área | Gap Descrição | Impacto | Ação Corretiva |
|--------|------|---------------|---------|----------------|
| IN-021 | FX Provider Integration | Integração com provedores de cotação FX externos não existe | 🔴 CRÍTICO | Criar FxProviderPort interface; implementar adapters para provedores reais ou sandbox; definir fallback policy |
| IN-022 | Cotação em Tempo Real | Sistema não consulta cotação em tempo real de múltiplos providers | 🟠 ALTO | Implementar service que consulta 1+ providers FX; cache com TTL; seleção baseada em spread/confiabilidade |
| IN-023 | FX Spread/Markup | Cálculo de spread e markup sobre cotação base não implementado | 🟠 ALTO | Implementar engine que adiciona spread configurável por institution/corridor; tornar configurável por painel admin |
| IN-024 | FX Rate Expiration | Cotações FX não têm expiração/validade controlada | 🟡 MÉDIA | Implementar field expiryAt em FXQuote entity; validar cotação expirada não é usada; UI mostrar tempo restante |
| IN-025 | Moeda Não Suportada | Sistema não suporta conversão para todas moedas necessárias | 🟡 MÉDIA | Estender lista de moedas suportadas (BRL, USD, EUR, CNY, JPY, GBP, AUD, CHF, etc.); API aberta para adicionar novas |
| IN-026 | Taxas Regulatórias | Impostos/tributos sobre câmbio não calculados automaticamente | 🟡 MÉDIA | Implementar tax/retention rules engine; configurável por institution/corridor; aparecer no checkout breakdown |

---

## 4. SDK INTEGRATION GAPS

| GAP ID | Área | Gap Descrição | Impacto | Ação Corretiva |
|--------|------|---------------|---------|----------------|
| IN-031 | SDK Typescript/JS | SDK oficial Javascript/Typescript não criado | 🟠 ALTO | Criar packages/sdk com types definitions; exports: createPayment, getPayment, createCheckout, getStatus, createRefund, getFXQuote, createWebhook, verifyPayment |
| IN-032 | SDK Node.js | SDK Node.js específico não existe | 🟠 ALTO | Implementar usando OpenAPI generator ou hand-roll com axios config |
| IN-033 | SDK PHP | SDK PHP não existe | 🟡 MÉDIA | Implementar caso houver demanda PHP; contrário, documentar que SDKs prioritários são JS/Node |
| IN-034 | SDK Java | SDK Java não existe | 🟡 MÉDIA | Implementar caso houver demanda Java; contrário, documentar |
| IN-035 | SDK Python | SDK Python não existe | 🟡 MÉDIA | Implementar caso houver demanda Python; contrário, documentar |
| IN-036 | SDK Exemplos | Exemplos de uso do SDK não existem | 🟡 MÉDIA | Criar exemplos: checkout rápido, payment intent creation, QR generation, status check, refund processing |
| IN-037 | SDK Auth | Flow de autenticação no SDK não documentado | 🟡 MÉDIA | Documentar: API Key usage, OAuth2 flow, MFA integration, session management |
| IN-038 | SDK Sandbox | SDK preparado para modo sandbox/testnet | 🟡 MÉDIA | Implementar flag environment (development/production/sandbox); mock responses no SDK level |

---

## 5. DEVELOPER PORTAL INTEGRATION GAPS

| GAP ID | Área | Gap Descrição | Impacto | Ação Corretiva |
|--------|------|---------------|---------|----------------|
| IN-041 | API Keys Management | Developer portal não possui sistema de API key generation/management | 🔴 CRÍTICO | Criar portal onde developers podem: signup, generate API keys, view usage, rotate keys, revoke keys, see rate limits |
| IN-042 | OAuth2/Client Credentials | Flow OAuth2 com client-credentials não documentado/implementado | 🟠 ALTO | Implementar endpoints de auth; documented no developer portal; suportar tokens de acesso para integrações server-to-server |
| IN-042 | Sandbox Access | Sandbox não acessível via portal ou credentials | 🟠 ALTO | Criar credentials de sandbox no portal; permitir testes sem dinheiro real; documentar diferenças produção/sandbox |
| IN-043 | OpenAPI/Swagger Download | Especificação OpenAPI não disponível para download no portal | 🟡 MÉDIA | Gerar e servir openapi.yaml/json via portal; permitir import em Postman/Insomnia |
| IN-044 | API Versões | Versionamento de API não explicado no portal | 🟡 MÉDIA | Documentar: /api/v1 atual, /api/v2 planejado, estratégia de deprecation, migration guide |
| IN-045 | Rate Limits | Limites de rate limit por aplicação não definidos no portal | 🟡 MÉDIA | Documentar limites por endpoint/plano; exibir headers de rate limit nas respostas; dashboard de uso |
| IN-046 | Webhook Registration | Registro de webhooks no portal não existe | 🟡 MÉDIA | Permitir desenvolvedores registrarem webhooks no portal; definir URLs de callback; testar conexão |
| IN-047 | SDK Downloads | Links de download de SDKs (JS, Node, etc.) no portal não funcionam ou não existem | 🟡 MÉDIA | Criar/seção de downloads no portal; verificar que links funcionam para todas linguagens suportadas |
| IN-048 | Examples & Guides | Exemplos code e guias no portal são genéricos ou inexistentes | 🟡 MÉDIA | Criar guias passo-a-passo: "Primeiro pagamento", "Criando webhook", "Configurando sandbox", "Processando refund" |

---

## 6. EXTERNAL SERVICES GAPS

| GAP ID | Serviço | Status | Impacto | Ação |
|--------|---------|--------|---------|--------|
| IN-050 | Email Service (SendGrid, SES) | Não integrada | 🟡 MÉDIA | Implementar service de email para: confirmações, notificações, OTP delivery; template de email por evento |
| IN-052 | SMS Service (Twilio, etc.) | Não integrada | 🟡 MÉDIA | Implementar serviço SMS para: OTP delivery, notifications, alerts; template SMS por evento |
| IN-053 | Notification Service | Sistema próprio de notifications não implementado | 🟡 MÉDIA | Criar sistema que dispatches notifications após eventos críticos: payment.created, payment.settled, webhook.delivered, etc. via email, SMS, push |
| IN-054 | Logging Service | Integração com external logging (Datadog, New Relic, etc.) não existe | 🟡 MÉDIA | Implementar envio de logs estruturados para external service; OpenTelemetry setup |
| IN-055 | Monitoring Service | Integração com external monitoring (Prometheus, Grafana, Datadog) não existe | 🟡 MÉDIA | Implementar métricas exportáveis; health checks; alerting configuration |
| IN-056 | Secret Management External | Gerenciamento de secrets externo (Vault, AWS SSM) não integrado | 🟡 MÉDIA | Integrar application com secret manager do provedor de nuvem; nunca commitar secrets |

---

## 7. INTEGRATION ROADMAP

| Fase | Integrações | Prioridade | Prazo |
|------|-------------|------------|-------|
| **Fase 1 - Imediata (1-2 meses)** | PIX (backend API); Solana Devnet adapter (RPC, wallet, USDC); FX Engine com provider sandbox; API Keys no developer portal | 🔴 CRÍTICO | 1-2 meses |
| **Fase 2 - Alta (3-4 meses)** | Stripe adapter; Efí adapter; Circle/USDC production; CCTP cross-chain (opcional); Bank adapters REST/SFTP (mínimo) | 🟠 ALTO | 3-4 meses |
| **Fase 3 - Média (5-6 meses)** | Multiple bank integrations (3-5 banks); ISO20022 support; Cross-chain CCTP se houver demanda; SDK JS/Typescript completo; Developer portal completo | 🟡 MÉDIA | 5-6 meses |
| **Fase 4 - Baixa (7-12 meses)** | Bank legacy COBOL integration (se houver demanda); Altas quantidades de processors; Multiple crypto networks (Ethereum, Base, etc.); White-label customization do portal; Advanced analytics integrations | 🟢 BAIXA | 7-12 meses |

---
**FIM DO INTEGRATION_GAPS.md**