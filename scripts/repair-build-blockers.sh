#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

echo "============================================================"
echo " VIA PAY — REPAIR BUILD BLOCKERS"
echo "============================================================"
echo

cd "$ROOT"

BACKUP_DIR="$ROOT/.repair-backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo "[1/6] Backup dos arquivos que serão corrigidos"
echo "------------------------------------------------------------"

backup_file() {
    local file="$1"

    if [[ -f "$file" ]]; then
        local target="$BACKUP_DIR/${file#$ROOT/}"
        mkdir -p "$(dirname "$target")"
        cp "$file" "$target"
        echo "[BACKUP] $file"
    fi
}

backup_file "$ROOT/package.json"
backup_file "$ROOT/tsconfig.json"
backup_file "$ROOT/apps/bank-core/components/ui/StatusBadge.tsx"
backup_file "$ROOT/apps/api/src/modules/merchants/domain/value-objects/index.ts"
backup_file "$ROOT/apps/api/src/modules/payments/domain/value-objects/index.ts"
backup_file "$ROOT/apps/api/src/modules/settlements/domain/value-objects/index.ts"

echo
echo "Backup:"
echo "$BACKUP_DIR"

echo

echo "[2/6] Corrigindo packageManager"
echo "------------------------------------------------------------"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/package.json";

const data = JSON.parse(fs.readFileSync(file, "utf8"));

data.packageManager = "pnpm@12.8.1";

fs.writeFileSync(
  file,
  JSON.stringify(data, null, 2) + "\n"
);

console.log("packageManager = pnpm@12.8.1");
NODE

echo

echo "[3/6] Corrigindo tsconfig"
echo "------------------------------------------------------------"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/tsconfig.json";

if (!fs.existsSync(file)) {
  console.log("tsconfig.json não encontrado.");
  process.exit(0);
}

const data = JSON.parse(fs.readFileSync(file, "utf8"));

if (
  data.compilerOptions &&
  typeof data.compilerOptions === "object"
) {
  if (Object.prototype.hasOwnProperty.call(
    data.compilerOptions,
    "include"
  )) {
    if (!data.include) {
      data.include = data.compilerOptions.include;
    }

    delete data.compilerOptions.include;

    console.log("Movido compilerOptions.include -> include");
  }

  if (Object.prototype.hasOwnProperty.call(
    data.compilerOptions,
    "exclude"
  )) {
    if (!data.exclude) {
      data.exclude = data.compilerOptions.exclude;
    }

    delete data.compilerOptions.exclude;

    console.log("Movido compilerOptions.exclude -> exclude");
  }
}

fs.writeFileSync(
  file,
  JSON.stringify(data, null, 2) + "\n"
);

console.log("tsconfig.json normalizado.");
NODE

echo

echo "[4/6] Corrigindo StatusBadge do bank-core"
echo "------------------------------------------------------------"

STATUS="$ROOT/apps/bank-core/components/ui/StatusBadge.tsx"

if [[ -f "$STATUS" ]]; then

cat > "$STATUS" <<'EOF'
"use client";

import React from "react";

export interface StatusBadgeProps {
  status: string;
  className?: string;
}

function normalizeStatus(status: string): string {
  return status
    .replace(/[_-]+/g, " ")
    .trim()
    .toUpperCase();
}

export function StatusBadge({
  status,
  className = "",
}: StatusBadgeProps) {
  const normalized = normalizeStatus(status);

  return (
    <span
      className={className}
      data-status={normalized}
      style={{
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "4px 10px",
        borderRadius: "999px",
        backgroundColor: "#eff6ff",
        color: "#1d4ed8",
        border: "1px solid #bfdbfe",
        fontSize: "12px",
        fontWeight: 700,
        lineHeight: 1.4,
        whiteSpace: "nowrap",
      }}
    >
      {normalized}
    </span>
  );
}

export default StatusBadge;
EOF

echo "StatusBadge corrigido."

else

echo "StatusBadge não encontrado; nada a corrigir."

fi

echo

echo "[5/6] Diagnosticando value-objects"
echo "------------------------------------------------------------"

for FILE in \
"$ROOT/apps/api/src/modules/merchants/domain/value-objects/index.ts" \
"$ROOT/apps/api/src/modules/payments/domain/value-objects/index.ts" \
"$ROOT/apps/api/src/modules/settlements/domain/value-objects/index.ts"
do

    if [[ -f "$FILE" ]]; then
        echo
        echo "============================================================"
        echo "$FILE"
        echo "============================================================"

        nl -ba "$FILE" | sed -n '1,80p'
    else
        echo "[NÃO ENCONTRADO] $FILE"
    fi

done

echo

echo "[6/6] Verificação inicial"
echo "------------------------------------------------------------"

echo
echo "packageManager atual:"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/package.json";
const data = JSON.parse(fs.readFileSync(file, "utf8"));

console.log(data.packageManager);
NODE

echo

echo "Executando TypeScript..."

if pnpm exec tsc --noEmit > /tmp/viapay-typecheck-after-repair.log 2>&1; then

    echo
    echo "============================================================"
    echo " TYPESCRIPT: OK"
    echo "============================================================"

else

    echo
    echo "============================================================"
    echo " AINDA EXISTEM ERROS"
    echo "============================================================"

    cat /tmp/viapay-typecheck-after-repair.log

fi

echo
echo "============================================================"
echo " REPARO PARCIAL CONCLUÍDO"
echo "============================================================"
echo
echo "Backup:"
echo "$BACKUP_DIR"
echo
echo "O projeto existente NÃO foi apagado."
echo
