# SERVICES

Services/clientes HTTP devem centralizar:
- autenticação;
- headers;
- request ID;
- tratamento de erro;
- serialização;
- retries permitidos;
- idempotency key quando necessária.

Nunca colocar segredo de provider no frontend.
