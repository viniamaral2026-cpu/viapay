# Database

Área de persistência do ViaPay.

## Regras

Alterações de banco devem utilizar migrations versionadas.

Não executar alterações destrutivas sem migration explícita.

Operações financeiras devem preservar:

- integridade;
- consistência;
- auditabilidade;
- idempotência;
- histórico;
- reconciliação.

Nunca utilizar floating point para valores monetários.
