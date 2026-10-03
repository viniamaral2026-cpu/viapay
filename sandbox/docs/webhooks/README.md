# Webhooks

O Sandbox possui simulador de webhooks.

Eventos:

payment.created
payment.detected
payment.confirmed
payment.failed
payment.expired

transfer.created
transfer.completed
transfer.failed

fx.quote.created
fx.quote.locked
fx.quote.executed

settlement.created
settlement.completed
settlement.failed

reconciliation.created
reconciliation.resolved

## Assinatura

Os webhooks devem possuir assinatura.

Header:

X-ViaPay-Signature

Também utilizar:

X-ViaPay-Event-Id
X-ViaPay-Timestamp

O consumidor deve validar:

timestamp
signature
event_id

e implementar proteção contra replay.
