# ViaPay Developer Sandbox — Master Specification

## Purpose

Provide a safe environment where developers can integrate
ViaPay before accessing production.

## Product Positioning

ViaPay is financial payment infrastructure.

The Sandbox is a developer infrastructure product.

DEEVO develops the technology.

Banks, financial institutions and governments may license
or integrate the technology.

## Sandbox Principle

NO REAL MONEY.

NO REAL PRODUCTION TRANSACTIONS.

NO PRODUCTION CREDENTIALS.

NO PRODUCTION BANK ACCESS.

NO PRODUCTION WALLET.

NO PRODUCTION PRIVATE KEY.

## Core Modules

### Payments

Payment Intent
Payment
Transaction

### Financial Simulation

Ledger
Settlement
Reconciliation
FX

### Integration

API
SDK
Webhooks
OpenAPI

### Crypto

Solana simulation
USDC simulation
Blockchain transaction simulation

### Security

API keys
RBAC
Scopes
Idempotency
Webhook signatures
Audit

## Developer Lifecycle

REGISTER

↓

CREATE APPLICATION

↓

CREATE SANDBOX CREDENTIALS

↓

READ DOCUMENTATION

↓

BUILD INTEGRATION

↓

RUN TEST SCENARIOS

↓

CERTIFICATION

↓

REQUEST PRODUCTION

↓

APPROVAL

↓

PRODUCTION

## Non-Goals

The Sandbox is not:

- a bank;
- a wallet with real assets;
- a real exchange;
- a real FX provider;
- a real settlement account;
- a production blockchain environment.

## Production Architecture

The Sandbox contracts must be compatible with the production
architecture without exposing production infrastructure.
