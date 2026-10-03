
# COBOL / Mainframe Integration

## Objetivo

Permitir integração com core banking tradicional.

A plataforma não precisa substituir COBOL.

Ela pode funcionar como camada moderna de APIs e orquestração.

## Arquitetura

```text
Bank Application
       │
       ▼
Modern API
       │
       ▼
Integration Adapter
       │
       ▼
MQ / CICS / API / File
       │
       ▼
COBOL Core
```

## Possíveis mecanismos

* CICS;
* IBM MQ;
* batch;
* VSAM;
* DB2;
* SOAP;
* REST gateway;
* arquivos estruturados.

## Regra

O modelo COBOL não deve ser exposto diretamente ao frontend.

Deve existir um contrato canônico.
