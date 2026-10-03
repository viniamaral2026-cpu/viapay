# Idempotency

Todas as operações que criam efeitos financeiros ou equivalentes
devem aceitar:

Idempotency-Key

Exemplo:

Idempotency-Key: 8e1c7c1d-6e1a-4e8e-9b9d-000000000001

A mesma chave com o mesmo payload deve produzir o mesmo resultado.

A mesma chave com payload diferente deve gerar erro:

IDEMPOTENCY_KEY_REUSE_WITH_DIFFERENT_PAYLOAD

Nenhum cenário de teste deve permitir processamento duplicado.
