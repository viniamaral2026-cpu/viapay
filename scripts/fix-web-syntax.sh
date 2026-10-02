#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
WEB="$ROOT/apps/web"
BACKUP="$ROOT/.sanitation-backups/syntax-$(date +%Y%m%d-%H%M%S)"

cd "$ROOT"

echo "=============================================="
echo " VIAPAY — CORREÇÃO SINTÁTICA DO FRONTEND"
echo "=============================================="

mkdir -p "$BACKUP"

echo
echo "📦 Criando backup..."

cp -a "$WEB/app" "$BACKUP/app"
cp -a "$WEB/components" "$BACKUP/components"

echo "✓ Backup: $BACKUP"

echo
echo "🔧 Corrigindo imports..."

python3 <<'PY'
from pathlib import Path
import re

web = Path("apps/web")

extensions = {".ts", ".tsx"}

changed = 0

for file in web.rglob("*"):
    if file.suffix not in extensions:
        continue

    if "node_modules" in file.parts:
        continue

    if ".next" in file.parts:
        continue

    text = file.read_text(encoding="utf-8")

    original = text

    # Corrige imports @/... que ficaram sem aspas finais.
    #
    # Exemplo:
    # from "@/components/Logo/Logo;
    #
    # vira:
    # from "@/components/Logo/Logo";

    text = re.sub(
        r'from\s+(")(@/[^"\n;]+);',
        r'from \1\2";',
        text
    )

    text = re.sub(
        r'from\s+(\')(@/[^\'\n;]+);',
        r"from '\2';",
        text
    )

    # Corrige imports de componentes que ficaram:
    #
    # from "@/components/X/X;
    #
    # para:
    #
    # from "@/components/X/X";

    if text != original:
        file.write_text(text, encoding="utf-8")
        changed += 1
        print(f"✓ {file}")

print()
print(f"Arquivos corrigidos: {changed}")
PY

echo
echo "🧹 Removendo barrels index.ts proibidos..."

find "$WEB/components" \
  -type f \
  -name "index.ts" \
  -delete

echo "✓ Barrels removidos."

echo
echo "🔎 Procurando imports relativos..."

RELATIVE_IMPORTS="$(
  grep -RInE \
    --include='*.ts' \
    --include='*.tsx' \
    'from[[:space:]]+["'\''](\./|\.\./)' \
    "$WEB/components" \
    2>/dev/null || true
)"

if [[ -n "$RELATIVE_IMPORTS" ]]; then
    echo
    echo "❌ IMPORTS RELATIVOS AINDA EXISTEM:"
    echo
    echo "$RELATIVE_IMPORTS"
    exit 1
fi

echo "✓ Nenhum import relativo nos componentes."

echo
echo "🔎 Verificando sintaxe TypeScript..."

cd "$WEB"

pnpm exec tsc --noEmit

echo
echo "✓ TypeScript OK."

echo
echo "🏗️ Executando build..."

pnpm run build

echo
echo "=============================================="
echo " ✅ VIAPAY FRONTEND CORRIGIDO"
echo "=============================================="

echo
echo "Backup:"
echo "$BACKUP"

echo
echo "TypeScript: OK"
echo "Build: OK"
echo
