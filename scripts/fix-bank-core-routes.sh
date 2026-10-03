#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
APP="$ROOT/apps/bank-core"

echo "============================================================"
echo " VIA PAY — BANK CORE ROUTE REPAIR"
echo "============================================================"
echo

if [[ ! -d "$APP" ]]; then
    echo "ERRO: Bank Core não encontrado:"
    echo "$APP"
    exit 1
fi

cd "$APP"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

BACKUP="$ROOT/.route-repair-backups/$TIMESTAMP"

mkdir -p "$BACKUP"

echo "[1/5] Verificando rotas"
echo "------------------------------------------------------------"

ROUTE_A="$APP/app/dashboard/page.tsx"
ROUTE_B="$APP/app/(dashboard)/dashboard/page.tsx"

echo
echo "Rota A:"
echo "$ROUTE_A"

echo
echo "Rota B:"
echo "$ROUTE_B"

echo

if [[ ! -f "$ROUTE_A" ]]; then
    echo "Rota A não encontrada."
fi

if [[ ! -f "$ROUTE_B" ]]; then
    echo "Rota B não encontrada."
fi

echo
echo "[2/5] Criando backup"
echo "------------------------------------------------------------"

if [[ -f "$ROUTE_A" ]]; then
    mkdir -p "$BACKUP/app/dashboard"
    cp "$ROUTE_A" "$BACKUP/app/dashboard/page.tsx"
    echo "[BACKUP] app/dashboard/page.tsx"
fi

if [[ -f "$ROUTE_B" ]]; then
    mkdir -p "$BACKUP/app/(dashboard)/dashboard"
    cp "$ROUTE_B" "$BACKUP/app/(dashboard)/dashboard/page.tsx"
    echo "[BACKUP] app/(dashboard)/dashboard/page.tsx"
fi

echo
echo "Backup:"
echo "$BACKUP"

echo
echo "[3/5] Preservando a página duplicada"
echo "------------------------------------------------------------"

# NÃO APAGAMOS O CONTEÚDO.
# A página app/dashboard/page.tsx será movida para uma pasta
# privada do Next.js. Pastas iniciadas por "_" não participam
# do sistema de rotas do App Router.

if [[ -f "$ROUTE_A" ]]; then

    LEGACY_DIR="$APP/app/_legacy/dashboard"

    mkdir -p "$LEGACY_DIR"

    mv "$ROUTE_A" "$LEGACY_DIR/page.tsx"

    echo "[MOVIDO]"
    echo "app/dashboard/page.tsx"
    echo "->"
    echo "app/_legacy/dashboard/page.tsx"

else

    echo "Página duplicada A não encontrada."

fi

echo
echo "[4/5] Limpando cache de desenvolvimento"
echo "------------------------------------------------------------"

rm -rf "$APP/.next"

echo "Cache .next removido."

echo
echo "[5/5] Estrutura final das rotas"
echo "------------------------------------------------------------"

find "$APP/app" \
    -maxdepth 5 \
    -type f \
    \( -name "page.tsx" -o -name "page.ts" \) \
    | sort

echo
echo "============================================================"
echo " ROUTE REPAIR CONCLUÍDO"
echo "============================================================"
echo
echo "A rota oficial /dashboard permanece em:"
echo
echo "app/(dashboard)/dashboard/page.tsx"
echo
echo "A implementação anterior foi preservada em:"
echo
echo "app/_legacy/dashboard/page.tsx"
echo
echo "Nenhum conteúdo foi descartado."
echo
echo "Backup:"
echo "$BACKUP"
echo

