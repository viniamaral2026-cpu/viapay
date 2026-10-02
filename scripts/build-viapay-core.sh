#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

cd "$ROOT"

echo "============================================================"
echo " VIAPAY — IMPLEMENTAÇÃO DO CORE DE ENGENHARIA"
echo "============================================================"

BACKUP="$ROOT/.sanitation-backups/core-implementation-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

echo
echo "Backup: $BACKUP"

cp -R packages/domain "$BACKUP/domain" 2>/dev/null || true
cp -R packages/application "$BACKUP/application" 2>/dev/null || true
cp -R packages/contracts "$BACKUP/contracts" 2>/dev/null || true
cp -R packages/infrastructure "$BACKUP/infrastructure" 2>/dev/null || true
cp -R packages/shared "$BACKUP/shared" 2>/dev/null || true

echo
echo "===== DIRETÓRIOS ====="

mkdir -p \
  packages/domain/src/payment \
  packages/domain/src/shared \
  packages/application/src/payment/use-cases \
  packages/application/src/payment/ports \
  packages/application/src/shared \
  packages/contracts/src/api \
  packages/contracts/src/events \
  packages/infrastructure/src/payment \
  packages/infrastructure/src/pix \
  packages/infrastructure/src/exchange \
  packages/infrastructure/src/solana \
  packages/infrastructure/src/database \
  packages/infrastructure/src/webhooks \
  packages/shared/src \
  apps/api/src/routes \
  apps/api/src/plugins \
  apps/worker/src/jobs

echo "✓ Diretórios criados."

# ============================================================
# DOMAIN
# ============================================================

echo
echo "===== DOMAIN ====="

cat > packages/domain/src/payment/payment-status.ts <<'EOF'
export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";
EOF

cat > packages/domain/src/payment/payment.ts <<'EOF'
import type { PaymentStatus } from "./payment-status.js";

export interface PaymentProps {
  id: string;
  amountBRLMinor: bigint;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: Date;
  updatedAt: Date;
}

export class Payment {
  private constructor(
    private readonly props: PaymentProps
  ) {}

  static create(input: {
    id: string;
    amountBRLMinor: bigint;
    merchantWallet: string;
    now?: Date;
  }): Payment {
    if (input.amountBRLMinor <= 0n) {
      throw new Error("Payment amount must be greater than zero");
    }

    if (!input.merchantWallet.trim()) {
      throw new Error("Merchant wallet is required");
    }

    const now = input.now ?? new Date();

    return new Payment({
      id: input.id,
      amountBRLMinor: input.amountBRLMinor,
      merchantWallet: input.merchantWallet,
      status: "CREATED",
      createdAt: now,
      updatedAt: now
    });
  }

  get id(): string {
    return this.props.id;
  }

  get amountBRLMinor(): bigint {
    return this.props.amountBRLMinor;
  }

  get merchantWallet(): string {
    return this.props.merchantWallet;
  }

  get status(): PaymentStatus {
    return this.props.status;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  transitionTo(status: PaymentStatus, now = new Date()): void {
    if (!this.canTransitionTo(status)) {
      throw new Error(
        `Invalid payment transition: ${this.props.status} -> ${status}`
      );
    }

    this.props.status = status;
    this.props.updatedAt = now;
  }

  private canTransitionTo(next: PaymentStatus): boolean {
    const transitions: Record<PaymentStatus, PaymentStatus[]> = {
      CREATED: ["PIX_PENDING", "FAILED", "EXPIRED"],
      PIX_PENDING: ["PIX_PAID", "FAILED", "EXPIRED"],
      PIX_PAID: ["SETTLEMENT_PENDING", "FAILED"],
      SETTLEMENT_PENDING: ["SETTLING", "FAILED"],
      SETTLING: ["SETTLED", "FAILED"],
      SETTLED: [],
      FAILED: [],
      EXPIRED: []
    };

    return transitions[this.props.status].includes(next);
  }
}
EOF

cat > packages/domain/src/payment/index.ts <<'EOF'
export * from "./payment.js";
export * from "./payment-status.js";
EOF

cat > packages/domain/src/index.ts <<'EOF'
export * from "./payment/index.js";
EOF

# ============================================================
# APPLICATION PORTS
# ============================================================

echo
echo "===== APPLICATION ====="

cat > packages/application/src/payment/ports/payment-repository.ts <<'EOF'
import type { Payment } from "@viapay/domain";

export interface PaymentRepository {
  save(payment: Payment): Promise<void>;
  findById(id: string): Promise<Payment | null>;
}
EOF

cat > packages/application/src/payment/ports/pix-provider.ts <<'EOF'
export interface CreatePixChargeInput {
  paymentId: string;
  amountBRLMinor: bigint;
}

export interface PixCharge {
  id: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: Date;
}

export interface PixProvider {
  createCharge(input: CreatePixChargeInput): Promise<PixCharge>;
}
EOF

cat > packages/application/src/payment/ports/exchange-provider.ts <<'EOF'
export interface ExchangeQuote {
  amountBRLMinor: bigint;
  amountUSDCAtomic: bigint;
  rate: string;
}

export interface ExchangeProvider {
  quoteBRLToUSDC(amountBRLMinor: bigint): Promise<ExchangeQuote>;
}
EOF

cat > packages/application/src/payment/ports/solana-provider.ts <<'EOF'
export interface SettlementInput {
  paymentId: string;
  amountUSDCAtomic: bigint;
  merchantWallet: string;
}

export interface SettlementResult {
  transactionSignature: string;
}

export interface SolanaProvider {
  settle(input: SettlementInput): Promise<SettlementResult>;
}
EOF

cat > packages/application/src/payment/use-cases/create-payment.ts <<'EOF'
import { Payment } from "@viapay/domain";
import type { PaymentRepository } from "../ports/payment-repository.js";
import type { PixProvider } from "../ports/pix-provider.js";

export interface CreatePaymentInput {
  paymentId: string;
  amountBRLMinor: bigint;
  merchantWallet: string;
}

export interface CreatePaymentOutput {
  paymentId: string;
  status: "PIX_PENDING";
  pixChargeId: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: Date;
}

export class CreatePayment {
  constructor(
    private readonly repository: PaymentRepository,
    private readonly pixProvider: PixProvider
  ) {}

  async execute(
    input: CreatePaymentInput
  ): Promise<CreatePaymentOutput> {
    const payment = Payment.create(input);

    payment.transitionTo("PIX_PENDING");

    await this.repository.save(payment);

    const charge = await this.pixProvider.createCharge({
      paymentId: payment.id,
      amountBRLMinor: payment.amountBRLMinor
    });

    return {
      paymentId: payment.id,
      status: "PIX_PENDING",
      pixChargeId: charge.id,
      qrCode: charge.qrCode,
      ...(charge.qrCodeImage
        ? { qrCodeImage: charge.qrCodeImage }
        : {}),
      expiresAt: charge.expiresAt
    };
  }
}
EOF

cat > packages/application/src/payment/use-cases/get-payment.ts <<'EOF'
import type { PaymentRepository } from "../ports/payment-repository.js";

export class GetPayment {
  constructor(
    private readonly repository: PaymentRepository
  ) {}

  async execute(paymentId: string) {
    return this.repository.findById(paymentId);
  }
}
EOF

cat > packages/application/src/payment/use-cases/handle-pix-payment.ts <<'EOF'
import type { PaymentRepository } from "../ports/payment-repository.js";

export interface HandlePixPaymentInput {
  paymentId: string;
}

export class HandlePixPayment {
  constructor(
    private readonly repository: PaymentRepository
  ) {}

  async execute(input: HandlePixPaymentInput): Promise<void> {
    const payment = await this.repository.findById(input.paymentId);

    if (!payment) {
      throw new Error("Payment not found");
    }

    if (payment.status !== "PIX_PENDING") {
      return;
    }

    payment.transitionTo("PIX_PAID");
    payment.transitionTo("SETTLEMENT_PENDING");

    await this.repository.save(payment);
  }
}
EOF

cat > packages/application/src/index.ts <<'EOF'
export * from "./payment/ports/payment-repository.js";
export * from "./payment/ports/pix-provider.js";
export * from "./payment/ports/exchange-provider.js";
export * from "./payment/ports/solana-provider.js";

export * from "./payment/use-cases/create-payment.js";
export * from "./payment/use-cases/get-payment.js";
export * from "./payment/use-cases/handle-pix-payment.js";
EOF

# ============================================================
# CONTRACTS
# ============================================================

echo
echo "===== CONTRACTS ====="

cat > packages/contracts/src/api/payment.ts <<'EOF'
export interface CreatePaymentRequest {
  amountBRL: number;
  merchantWallet: string;
}

export interface CreatePaymentResponse {
  paymentId: string;
  status: PaymentStatus;
  pixChargeId: string;
  qrCode: string;
  qrCodeImage?: string;
  expiresAt: string;
}

export interface PaymentResponse {
  id: string;
  amountBRL: number;
  merchantWallet: string;
  status: PaymentStatus;
  createdAt: string;
  updatedAt: string;
}

export type PaymentStatus =
  | "CREATED"
  | "PIX_PENDING"
  | "PIX_PAID"
  | "SETTLEMENT_PENDING"
  | "SETTLING"
  | "SETTLED"
  | "FAILED"
  | "EXPIRED";
EOF

cat > packages/contracts/src/events/payment.ts <<'EOF'
export interface PixPaymentConfirmedEvent {
  type: "pix.payment.confirmed";
  paymentId: string;
  occurredAt: string;
}
EOF

cat > packages/contracts/src/index.ts <<'EOF'
export * from "./api/payment.js";
export * from "./events/payment.js";
EOF

# ============================================================
# SHARED
# ============================================================

echo
echo "===== SHARED ====="

cat > packages/shared/src/result.ts <<'EOF'
export type Result<T, E> =
  | {
      ok: true;
      value: T;
    }
  | {
      ok: false;
      error: E;
    };

export const Result = {
  ok<T>(value: T): Result<T, never> {
    return {
      ok: true,
      value
    };
  },

  fail<E>(error: E): Result<never, E> {
    return {
      ok: false,
      error
    };
  }
};
EOF

cat > packages/shared/src/index.ts <<'EOF'
export * from "./result.js";
EOF

# ============================================================
# INFRASTRUCTURE
# ============================================================

echo
echo "===== INFRASTRUCTURE ====="

cat > packages/infrastructure/src/payment/in-memory-payment-repository.ts <<'EOF'
import type { Payment } from "@viapay/domain";
import type { PaymentRepository } from "@viapay/application";

export class InMemoryPaymentRepository implements PaymentRepository {
  private readonly payments = new Map<string, Payment>();

  async save(payment: Payment): Promise<void> {
    this.payments.set(payment.id, payment);
  }

  async findById(id: string): Promise<Payment | null> {
    return this.payments.get(id) ?? null;
  }
}
EOF

cat > packages/infrastructure/src/pix/fake-pix-provider.ts <<'EOF'
import type {
  CreatePixChargeInput,
  PixCharge,
  PixProvider
} from "@viapay/application";

export class FakePixProvider implements PixProvider {
  async createCharge(
    input: CreatePixChargeInput
  ): Promise<PixCharge> {
    return {
      id: `pix_${input.paymentId}`,
      qrCode: `VIAPAY-PIX-${input.paymentId}`,
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }
}
EOF

cat > packages/infrastructure/src/index.ts <<'EOF'
export * from "./payment/in-memory-payment-repository.js";
export * from "./pix/fake-pix-provider.js";
EOF

# ============================================================
# PACKAGE CONFIG
# ============================================================

echo
echo "===== PACKAGE CONFIGURATION ====="

node <<'NODE'
const fs = require("fs");

const packages = [
  ["packages/domain/package.json", "@viapay/domain"],
  ["packages/application/package.json", "@viapay/application"],
  ["packages/infrastructure/package.json", "@viapay/infrastructure"],
  ["packages/shared/package.json", "@viapay/shared"]
];

for (const [file, name] of packages) {
  const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

  pkg.name = name;
  pkg.version = pkg.version || "1.0.0";
  pkg.private = true;
  pkg.main = "dist/index.js";
  pkg.types = "dist/index.d.ts";

  pkg.scripts = {
    build: "tsc -p tsconfig.json",
    typecheck: "tsc -p tsconfig.json --noEmit",
    test: "vitest run --passWithNoTests"
  };

  fs.writeFileSync(
    file,
    JSON.stringify(pkg, null, 2) + "\n"
  );
}
NODE

# ============================================================
# TSCONFIGS
# ============================================================

echo
echo "===== TSCONFIG ====="

for package in domain application infrastructure shared; do

cat > "packages/$package/tsconfig.json" <<EOF
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist"
  },
  "include": [
    "src/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist"
  ]
}
EOF

done

# ============================================================
# DEPENDENCIES
# ============================================================

echo
echo "===== DEPENDENCIES ====="

pnpm --filter @viapay/application add @viapay/domain
pnpm --filter @viapay/infrastructure add @viapay/application @viapay/domain
pnpm --filter @viapay/contracts add -D typescript@^7.0.2 vitest@^5.0.3
pnpm --filter @viapay/domain add -D typescript@^7.0.2 vitest@^5.0.3
pnpm --filter @viapay/application add -D typescript@^7.0.2 vitest@^5.0.3
pnpm --filter @viapay/infrastructure add -D typescript@^7.0.2 vitest@^5.0.3
pnpm --filter @viapay/shared add -D typescript@^7.0.2 vitest@^5.0.3

pnpm install

# ============================================================
# VALIDATION
# ============================================================

echo
echo "============================================================"
echo " TYPECHECK"
echo "============================================================"

pnpm --filter @viapay/domain typecheck
pnpm --filter @viapay/application typecheck
pnpm --filter @viapay/contracts typecheck
pnpm --filter @viapay/infrastructure typecheck
pnpm --filter @viapay/shared typecheck

echo
echo "============================================================"
echo " BUILD"
echo "============================================================"

pnpm --filter @viapay/domain build
pnpm --filter @viapay/application build
pnpm --filter @viapay/contracts build
pnpm --filter @viapay/infrastructure build
pnpm --filter @viapay/shared build

echo
echo "============================================================"
echo " TEST"
echo "============================================================"

pnpm --filter @viapay/domain test
pnpm --filter @viapay/application test
pnpm --filter @viapay/contracts test
pnpm --filter @viapay/infrastructure test
pnpm --filter @viapay/shared test

echo
echo "============================================================"
echo " VIAPAY CORE IMPLEMENTADO"
echo "============================================================"

echo
echo "Implementado:"
echo "  ✓ Domain"
echo "  ✓ Payment aggregate"
echo "  ✓ Payment state machine"
echo "  ✓ Application use cases"
echo "  ✓ Repository port"
echo "  ✓ PIX port"
echo "  ✓ Exchange port"
echo "  ✓ Solana port"
echo "  ✓ Contracts"
echo "  ✓ Shared Result"
echo "  ✓ Infrastructure adapters iniciais"
echo "  ✓ TypeScript"
echo "  ✓ Build"
echo "  ✓ Test runner"

echo
echo "Backup:"
echo "$BACKUP"

echo
echo "PRÓXIMA FASE:"
echo "  Database + Prisma + migrations"
echo "  API HTTP"
echo "  Webhooks PIX"
echo "  Worker"
echo "  Settlement"
echo "  SDK"
echo "  Testes de integração"
echo
