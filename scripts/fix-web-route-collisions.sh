#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
WEB="$ROOT/apps/web"
APP="$WEB/app"
BACKUP="$ROOT/.web-route-repair-backups/$(date +%Y%m%d-%H%M%S)"
LEGACY="$APP/_legacy"

echo "============================================================"
echo " VIA PAY — WEB ROUTE COLLISION REPAIR"
echo "============================================================"
echo
echo "Projeto: $ROOT"
echo "Frontend: $WEB"
echo

if [[ ! -d "$ROOT" ]]; then
  echo "[ERRO] Projeto não encontrado:"
  echo "$ROOT"
  exit 1
fi

if [[ ! -d "$WEB" ]]; then
  echo "[ERRO] Frontend não encontrado:"
  echo "$WEB"
  exit 1
fi

cd "$ROOT"

echo "[1/7] Validando Next.js"
echo "------------------------------------------------------------"

if [[ -f "$WEB/package.json" ]]; then
  node -e '
    const p=require("./apps/web/package.json");
    console.log("Frontend:", p.name);
    console.log("Next.js:", p.dependencies?.next || "não encontrado");
    console.log("React:", p.dependencies?.react || "não encontrado");
  '
else
  echo "[ERRO] apps/web/package.json não encontrado."
  exit 1
fi

echo
echo "[2/7] Criando backup"
echo "------------------------------------------------------------"

mkdir -p "$BACKUP"

cp -a "$APP" "$BACKUP/app-before-repair"

echo "[BACKUP] $BACKUP/app-before-repair"

echo
echo "[3/7] Criando área legacy"
echo "------------------------------------------------------------"

mkdir -p "$LEGACY/auth"
mkdir -p "$LEGACY/marketing"

echo "[OK] $LEGACY"

echo
echo "[4/7] Preservando Route Groups oficiais"
echo "------------------------------------------------------------"

echo "[OFICIAL] /(auth)/login"
echo "[OFICIAL] /(auth)/cadastro"

echo "[OFICIAL] /(marketing)/como-funciona"
echo "[OFICIAL] /(marketing)/contato"
echo "[OFICIAL] /(marketing)/empresa"
echo "[OFICIAL] /(marketing)/precos"

echo
echo "[5/7] Movendo duplicidades sem apagar conteúdo"
echo "------------------------------------------------------------"

move_if_exists() {
  local SOURCE="$1"
  local DEST="$2"

  if [[ -e "$SOURCE" ]]; then
    mkdir -p "$(dirname "$DEST")"

    if [[ -e "$DEST" ]]; then
      local NAME
      NAME="$(basename "$SOURCE")"

      local DEST2="${DEST%/}/legacy-$NAME"

      echo "[DESTINO JÁ EXISTE]"
      echo "$DEST"
      echo
      echo "[MOVIDO PARA]"
      echo "$DEST2"

      mv "$SOURCE" "$DEST2"
    else
      echo "[MOVIDO]"
      echo "$SOURCE"
      echo " -> "
      echo "$DEST"

      mv "$SOURCE" "$DEST"
    fi
  else
    echo "[NÃO EXISTE] $SOURCE"
  fi
}

# AUTH
move_if_exists \
  "$APP/login" \
  "$LEGACY/auth/login"

move_if_exists \
  "$APP/cadastro" \
  "$LEGACY/auth/cadastro"

# MARKETING
move_if_exists \
  "$APP/como-funciona" \
  "$LEGACY/marketing/como-funciona"

move_if_exists \
  "$APP/contato" \
  "$LEGACY/marketing/contato"

move_if_exists \
  "$APP/empresa" \
  "$LEGACY/marketing/empresa"

move_if_exists \
  "$APP/precos" \
  "$LEGACY/marketing/precos"

echo
echo "[6/7] Limpando cache do Next.js"
echo "------------------------------------------------------------"

rm -rf "$WEB/.next"

echo "[OK] Cache removido."

echo
echo "[7/7] Verificando estrutura"
echo "------------------------------------------------------------"

echo
echo "=== ROTAS OFICIAIS ==="

for route in \
  "$APP/(auth)/login/page.tsx" \
  "$APP/(auth)/cadastro/page.tsx" \
  "$APP/(marketing)/como-funciona/page.tsx" \
  "$APP/(marketing)/contato/page.tsx" \
  "$APP/(marketing)/empresa/page.tsx" \
  "$APP/(marketing)/precos/page.tsx"
do
  if [[ -f "$route" ]]; then
    echo "[OK] $route"
  else
    echo "[ATENÇÃO] Ausente: $route"
  fi
done

echo
echo "=== ROTAS LEGACY ==="

find "$LEGACY" -type f 2>/dev/null | sort || true

echo
echo "=== VERIFICAÇÃO DE DUPLICIDADES ==="

for route in \
  login \
  cadastro \
  como-funciona \
  contato \
  empresa \
  precos
do
  if [[ -d "$APP/$route" ]]; then
    echo "[ERRO] Ainda existe rota duplicada: /$route"
  else
    echo "[OK] /$route sem duplicidade"
  fi
done

echo
echo "============================================================"
echo " REPARO CONCLUÍDO"
echo "============================================================"
echo
echo "Route Groups oficiais foram preservados."
echo "Nenhum conteúdo foi apagado."
echo
echo "Backup:"
echo "$BACKUP"
echo
echo "Legacy:"
echo "$LEGACY"
echo
echo "Próximo passo:"
echo "cd $ROOT"
echo "pnpm --filter web dev"
echo
echo "Frontend:"
echo "http://localhost:3000"
echo
