# ViaPay PostgreSQL

PostgreSQL dedicado ao ambiente local/containerizado do ViaPay.

A porta do host é `5433` para evitar conflito com uma instalação PostgreSQL
existente no host.

Connection string:

postgresql://viapay:viapay@127.0.0.1:5433/viapay
