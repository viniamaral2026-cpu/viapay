
# Security Architecture

## Princípios

* Zero Trust;
* least privilege;
* defense in depth;
* secure by default;
* separation of duties.

## Controles

* MFA;
* RBAC;
* ABAC;
* rate limiting;
* encryption;
* secrets management;
* audit logs;
* session management;
* device controls;
* IP policies;
* anomaly detection.

## Dados

Dados sensíveis devem ser criptografados em trânsito e em repouso.

## Segredos

Nunca armazenar:

* API keys;
* passwords;
* private keys;
* signing secrets;

no código-fonte.
