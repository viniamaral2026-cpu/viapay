# 00 — PRODUCT BLUEPRINT

## Visão
O VIAPAY deve separar domínio financeiro de fornecedores externos.

## Macrofluxo
Merchant → API → Payment Core → Provider Adapter → Webhook/Event Bus → Transaction → Ledger → Settlement → Reconciliation.

## Bounded Contexts
Identity, Organization, Merchant, Customer, Payment, PIX, Transaction, Ledger, Settlement, Reconciliation, Refund, Webhook, Integration, Reporting, Audit, Notification, Developer Platform e Operations.

## Estratégia
Iniciar com modular monolith quando apropriado, mantendo fronteiras de domínio e contratos que permitam evolução para serviços independentes.
