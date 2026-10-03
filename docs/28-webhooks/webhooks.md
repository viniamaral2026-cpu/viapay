
# Webhooks

## Objetivo

Notificar sistemas externos sobre mudanças de estado.

## Eventos

```text
payment.created
payment.processing
payment.settled
payment.failed
payment.reconciled
```

## Segurança

Webhook deve possuir:

* assinatura;
* timestamp;
* replay protection;
* event ID.

## Receiver

O cliente deve responder rapidamente e processar de forma assíncrona.

## Retry

O provedor deve tentar novamente quando houver falha temporária.

Nunca assumir que um webhook será entregue apenas uma vez.
