#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

cd "$ROOT"

echo "=============================================="
echo " VIAPAY — CONFIGURAÇÃO DOS CORE WORKSPACES"
echo "=============================================="

# ------------------------------------------------
# 1. BACKUP
# ------------------------------------------------

BACKUP="$ROOT/.sanitation-backups/core-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP"

echo
echo "📦 Backup: $BACKUP"

cp apps/worker/package.json \
   "$BACKUP/worker-package.json"

cp packages/contracts/package.json \
   "$BACKUP/contracts-package.json"

cp packages/sdk/package.json \
   "$BACKUP/sdk-package.json"

echo "✓ Backup realizado."

# ------------------------------------------------
# 2. TSCONFIG BASE
# ------------------------------------------------

echo
echo "🔧 Criando tsconfig.base.json..."

cat > tsconfig.base.json <<'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",

    "strict": true,
    "noImplicitAny": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,

    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,

    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,

    "noEmitOnError": true
  }
}
EOF

echo "✓ tsconfig.base.json criado."

# ------------------------------------------------
# 3. WORKER
# ------------------------------------------------

echo
echo "🔧 Configurando Worker..."

cat > apps/worker/tsconfig.json <<'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist",
    "types": ["node"]
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

node <<'NODE'
const fs = require("fs");

const file = "apps/worker/package.json";
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.name = "worker";
pkg.version = pkg.version || "1.0.0";
pkg.private = true;

pkg.main = "dist/worker.js";
pkg.types = "dist/worker.d.ts";

pkg.scripts = {
  dev: "tsx watch src/worker.ts",
  build: "tsc -p tsconfig.json",
  start: "node dist/worker.js",
  typecheck: "tsc -p tsconfig.json --noEmit",
  test: "vitest run --passWithNoTests"
};

fs.writeFileSync(
  file,
  JSON.stringify(pkg, null, 2) + "\n"
);
NODE

echo "✓ Worker configurado."

# ------------------------------------------------
# 4. CONTRACTS
# ------------------------------------------------

echo
echo "🔧 Configurando Contracts..."

cat > packages/contracts/tsconfig.json <<'EOF'
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

node <<'NODE'
const fs = require("fs");

const file = "packages/contracts/package.json";
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.name = "@viapay/contracts";
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
NODE

# Criar entrypoint somente para exportar código que realmente existe.
cat > packages/contracts/src/index.ts <<'EOF'
export * from "./api/payment.js";
EOF

echo "✓ Contracts configurado."

# ------------------------------------------------
# 5. SDK
# ------------------------------------------------

echo
echo "🔧 Configurando SDK..."

cat > packages/sdk/tsconfig.json <<'EOF'
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

node <<'NODE'
const fs = require("fs");

const file = "packages/sdk/package.json";
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.name = "@viapay/sdk";
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
NODE

echo "✓ SDK configurada."

# ------------------------------------------------
# 6. NÃO FABRICAR DOMAIN/APPLICATION/INFRASTRUCTURE
# ------------------------------------------------

echo
echo "ℹ️ Packages ainda sem implementação:"
echo

for package in \
  packages/domain \
  packages/application \
  packages/infrastructure \
  packages/shared
do
  echo "  - $package"
done

echo
echo "Esses packages NÃO serão preenchidos automaticamente."
echo "Eles serão implementados quando houver código de domínio real."

# ------------------------------------------------
# 7. TYPECHECK
# ------------------------------------------------

echo
echo "=============================================="
echo " TYPECHECK"
echo "=============================================="

pnpm --filter worker typecheck
pnpm --filter @viapay/contracts typecheck
pnpm --filter @viapay/sdk typecheck

echo
echo "✓ Typecheck dos core workspaces passou."

# ------------------------------------------------
# 8. BUILD
# ------------------------------------------------

echo
echo "=============================================="
echo " BUILD"
echo "=============================================="

pnpm --filter worker build
pnpm --filter @viapay/contracts build
pnpm --filter @viapay/sdk build

echo
echo "✓ Build dos core workspaces passou."

# ------------------------------------------------
# 9. TEST
# ------------------------------------------------

echo
echo "=============================================="
echo " TEST"
echo "=============================================="

pnpm --filter worker test
pnpm --filter @viapay/contracts test
pnpm --filter @viapay/sdk test

echo
echo "✓ Infraestrutura de testes executada."
echo "⚠️ Packages sem testes reais usam --passWithNoTests."

# ------------------------------------------------
# FINAL
# ------------------------------------------------

echo
echo "=============================================="
echo " CORE WORKSPACES CONFIGURADOS"
echo "=============================================="

echo
echo "Worker:"
echo "  dev        → tsx watch src/worker.ts"
echo "  build      → tsc"
echo "  start      → node dist/worker.js"
echo "  typecheck  → tsc --noEmit"
echo "  test       → vitest"

echo
echo "Contracts:"
echo "  build      → tsc"
echo "  typecheck  → tsc --noEmit"
echo "  test       → vitest"

echo
echo "SDK:"
echo "  build      → tsc"
echo "  typecheck  → tsc --noEmit"
echo "  test       → vitest"

echo
echo "Backup:"
echo "$BACKUP"

echo
echo "✓ SANEAMENTO CONCLUÍDO."
