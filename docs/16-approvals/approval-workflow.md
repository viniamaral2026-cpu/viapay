
# Approval Workflow

## Objetivo

Implementar alçadas financeiras e operacionais.

## Exemplo

```text
0 - 1.000
Operador

1.000 - 10.000
Gerente

10.000 - 100.000
Gerente + Diretor

100.000+
Múltiplas aprovações
```

Os valores acima são exemplos arquiteturais e devem ser configurados pela
instituição.

## Approval Request

Campos:

* approval_id;
* transaction_id;
* required_role;
* required_amount;
* actor;
* status;
* expires_at;
* approved_at;
* rejected_at.

## Estados

```text
PENDING
APPROVED
REJECTED
EXPIRED
CANCELLED
```

## Código de aprovação

Quando requerido, o código deve ser:

* temporário;
* de uso único;
* protegido contra brute force;
* auditado;
* vinculado ao contexto da operação.

Nunca armazenar o código em texto puro.
