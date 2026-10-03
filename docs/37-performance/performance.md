
# Performance

## Objetivo

Garantir previsibilidade de latência sem comprometer consistência financeira.

## Estratégias

* caching de dados não financeiros;
* connection pooling;
* async processing;
* queues;
* batching;
* indexes;
* read replicas;
* horizontal scaling.

## Regra

Não utilizar cache como fonte de verdade para saldo financeiro.

## Load Testing

Cenários:

* criação de pagamentos;
* consultas de saldo;
* webhooks;
* reconciliation;
* settlement batch.
  EOF

# ------------------------------------------------------------------------------

# PRIVACY

# ------------------------------------------------------------------------------

write_if_missing "$DOCS/38-privacy/privacy.md" <<'EOF'

# Privacy

## Princípios

* minimização;
* finalidade;
* necessidade;
* controle de acesso;
* retenção limitada;
* rastreabilidade.

## Dados sensíveis

Devem possuir:

* classificação;
* política de retenção;
* controle de acesso;
* criptografia;
* auditoria.

## LGPD

Para operações no Brasil, a arquitetura deve ser compatível com os princípios
da LGPD e com as responsabilidades atribuídas aos participantes da operação.

Requisitos jurídicos devem ser validados com profissionais especializados.
