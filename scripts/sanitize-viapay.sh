#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB="$ROOT/apps/web"
COMPONENTS="$WEB/components"
BACKUP="$ROOT/.sanitation-backups/$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ok() {
  echo -e "${GREEN}✓${NC} $1"
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

error() {
  echo -e "${RED}✗${NC} $1"
}

info() {
  echo -e "${BLUE}→${NC} $1"
}

echo
echo "============================================================"
echo "                 VIAPAY SANITIZER"
echo "============================================================"
echo
echo "Root: $ROOT"
echo

if [[ ! -d "$ROOT" ]]; then
  error "Raiz do projeto não encontrada."
  exit 1
fi

if [[ ! -d "$WEB" ]]; then
  error "apps/web não encontrado."
  exit 1
fi

cd "$ROOT"

mkdir -p "$BACKUP"

info "Backup de segurança: $BACKUP"

echo
echo "============================================================"
echo "1. VERIFICAÇÃO DO MONOREPO"
echo "============================================================"

for DIR in apps packages database infrastructure docs scripts tests; do
  if [[ -d "$ROOT/$DIR" ]]; then
    ok "$DIR/"
  else
    warn "$DIR/ não encontrado"
  fi
done

echo
echo "============================================================"
echo "2. DETECÇÃO DO PACKAGE MANAGER"
echo "============================================================"

if [[ -f "$ROOT/pnpm-lock.yaml" ]]; then
  PM="pnpm"
elif [[ -f "$ROOT/yarn.lock" ]]; then
  PM="yarn"
elif [[ -f "$ROOT/package-lock.json" ]]; then
  PM="npm"
else
  PM="pnpm"
  warn "Lockfile não encontrado. Assumindo pnpm."
fi

ok "Package manager: $PM"

echo
echo "============================================================"
echo "3. BACKUP DOS ARQUIVOS QUE SERÃO MODIFICADOS"
echo "============================================================"

mkdir -p "$BACKUP/apps/web/components"

if [[ -d "$COMPONENTS" ]]; then
  cp -a "$COMPONENTS" "$BACKUP/apps/web/" 2>/dev/null || true
  ok "Backup de components realizado."
fi

if [[ -f "$WEB/tsconfig.json" ]]; then
  cp "$WEB/tsconfig.json" "$BACKUP/apps/web/tsconfig.json"
  ok "Backup do tsconfig.json realizado."
fi

echo
echo "============================================================"
echo "4. CORREÇÃO DO TSCONFIG DO WEB"
echo "============================================================"

python3 <<'PY'
import json
from pathlib import Path

root = Path("apps/web")
file = root / "tsconfig.json"

if not file.exists():
    print("⚠ tsconfig.json não encontrado.")
    raise SystemExit(0)

try:
    data = json.loads(file.read_text())
except Exception:
    print("⚠ tsconfig.json inválido. Não será sobrescrito automaticamente.")
    raise SystemExit(0)

compiler = data.setdefault("compilerOptions", {})

compiler["baseUrl"] = "."
compiler.setdefault("strict", True)
compiler.setdefault("noEmit", True)
compiler.setdefault("esModuleInterop", True)
compiler.setdefault("skipLibCheck", True)

paths = compiler.setdefault("paths", {})

paths["@/*"] = ["./*"]

file.write_text(
    json.dumps(data, indent=2, ensure_ascii=False) + "\n"
)

print("✓ @/* configurado.")
PY

echo
echo "============================================================"
echo "5. REMOÇÃO DOS BARRELS PROIBIDOS DOS COMPONENTES"
echo "============================================================"

if [[ -d "$COMPONENTS" ]]; then

  find "$COMPONENTS" -type f -name "index.ts" -print0 |
  while IFS= read -r -d '' FILE; do

    REL="${FILE#$WEB/}"

    CONTENT="$(cat "$FILE" 2>/dev/null || true)"

    if echo "$CONTENT" | grep -Eq \
      'export[[:space:]]+\{[^}]+\}[[:space:]]+from[[:space:]]+["'\'']\./[^"'\'']+["'\''];?'; then

      mkdir -p "$BACKUP/$(dirname "$REL")"
      cp "$FILE" "$BACKUP/$REL"

      rm "$FILE"

      ok "Removido barrel proibido: $REL"
    else
      warn "index.ts preservado: $REL"
    fi

  done

else
  warn "components/ não existe."
fi

echo
echo "============================================================"
echo "6. CORREÇÃO DE IMPORTS DE COMPONENTES"
echo "============================================================"

python3 <<'PY'
from pathlib import Path
import re

web = Path("apps/web")
components = web / "components"

if not components.exists():
    print("⚠ components/ não existe.")
    raise SystemExit(0)

# Mapeia componentes existentes:
#
# components/Footer/Footer.tsx
# -> @/components/Footer/Footer
#
# components/dashboard/Sidebar/Sidebar.tsx
# -> @/components/dashboard/Sidebar/Sidebar

component_files = {}

for file in components.rglob("*"):
    if file.suffix not in {".ts", ".tsx"}:
        continue

    if file.name == "index.ts":
        continue

    rel = file.relative_to(web).with_suffix("")

    alias = "@/" + str(rel).replace("\\", "/")

    component_files[file.stem] = alias

# Regras para imports diretos conhecidos.
#
# Exemplo:
# import { Footer } from "@/components/Footer"
#
# vira:
# import { Footer } from "@/components/Footer/Footer"

def replace_component_import(match):
    prefix = match.group(1)
    path = match.group(2)

    if not path.startswith("@/components/"):
        return match.group(0)

    raw = path[len("@/components/"):]

    # Já aponta para arquivo:
    parts = raw.split("/")

    if len(parts) >= 2 and parts[-1] == parts[-2]:
        return match.group(0)

    candidate = components / raw

    # Se o diretório possui Component.tsx, adiciona o arquivo.
    if candidate.is_dir():
        name = candidate.name

        tsx = candidate / f"{name}.tsx"
        ts = candidate / f"{name}.ts"

        if tsx.exists() or ts.exists():
            return f'{prefix}@/components/{raw}/{name}'

    return match.group(0)

pattern = re.compile(
    r'(["\'])(@/components/[^"\']+)\1'
)

changed = 0

for file in web.rglob("*"):
    if file.suffix not in {".ts", ".tsx"}:
        continue

    if "node_modules" in file.parts:
        continue

    original = file.read_text(encoding="utf-8")
    updated = pattern.sub(
        lambda m: replace_component_import(
            type("M", (), {
                "group": lambda self, n: (
                    m.group(1) if n == 1 else m.group(2)
                )
            })()
        ),
        original,
    )

    if updated != original:
        file.write_text(updated, encoding="utf-8")
        changed += 1
        print(f"✓ import corrigido: {file}")

print(f"✓ Arquivos alterados: {changed}")
PY

echo
echo "============================================================"
echo "7. VERIFICAÇÃO DE IMPORTS RELATIVOS EM COMPONENTS"
echo "============================================================"

RELATIVE_COMPONENT_IMPORTS="$(
  grep -RInE \
    --include='*.ts' \
    --include='*.tsx' \
    'from[[:space:]]+["'\''](\./|\.\./)' \
    "$COMPONENTS" \
    2>/dev/null || true
)"

if [[ -n "$RELATIVE_COMPONENT_IMPORTS" ]]; then
  error "Ainda existem imports relativos dentro de components:"
  echo
  echo "$RELATIVE_COMPONENT_IMPORTS"
  echo
  warn "Esses imports precisam ser corrigidos manualmente."
else
  ok "Nenhum import relativo encontrado em components/."
fi

echo
echo "============================================================"
echo "8. VERIFICAÇÃO DE IMPORTS @/components"
echo "============================================================"

BAD_COMPONENT_IMPORTS=""

while IFS= read -r FILE; do

  [[ -z "$FILE" ]] && continue

  CONTENT="$(cat "$FILE")"

  while IFS= read -r IMPORT; do

    [[ -z "$IMPORT" ]] && continue

    PATH_VALUE="$(echo "$IMPORT" | sed -E 's/.*["'\''](@\/components\/[^"'\'']+)["'\''].*/\1/')"

    if [[ "$PATH_VALUE" == "$IMPORT" ]]; then
      continue
    fi

    REL="${PATH_VALUE#@/}"

    if [[ -f "$WEB/$REL.tsx" ]] || \
       [[ -f "$WEB/$REL.ts" ]] || \
       [[ -f "$WEB/$REL/index.ts" ]]; then
      continue
    fi

    BAD_COMPONENT_IMPORTS+="$FILE -> $PATH_VALUE"$'\n'

  done < <(
    grep -oE '["'\'']@/components/[^"'\'']+["'\'']' "$FILE" 2>/dev/null || true
  )

done < <(
  find "$WEB" \
    -type f \
    \( -name "*.ts" -o -name "*.tsx" \) \
    ! -path "*/node_modules/*"
)

if [[ -n "$BAD_COMPONENT_IMPORTS" ]]; then
  error "Imports @/components potencialmente inválidos:"
  echo "$BAD_COMPONENT_IMPORTS"
else
  ok "Imports @/components verificados."
fi

echo
echo "============================================================"
echo "9. VERIFICAÇÃO DE ARQUIVOS DE COMPONENTES"
echo "============================================================"

if [[ -d "$COMPONENTS" ]]; then

  while IFS= read -r -d '' DIR; do

    NAME="$(basename "$DIR")"

    if [[ -f "$DIR/$NAME.tsx" ]] || [[ -f "$DIR/$NAME.ts" ]]; then
      ok "$DIR -> componente principal encontrado."
    fi

  done < <(
    find "$COMPONENTS" -mindepth 1 -type d -print0
  )

fi

echo
echo "============================================================"
echo "10. VERIFICAÇÃO DAS ROTAS DO APP"
echo "============================================================"

while IFS= read -r -d '' FILE; do
  REL="${FILE#$WEB/}"
  ok "$REL"
done < <(
  find "$WEB/app" \
    -type f \
    \( -name "page.tsx" -o -name "layout.tsx" -o -name "route.ts" \) \
    -print0 2>/dev/null
)

echo
echo "============================================================"
echo "11. VERIFICAÇÃO DO PACKAGE JSON"
echo "============================================================"

if [[ -f "$ROOT/package.json" ]]; then
  ok "package.json raiz encontrado."
else
  warn "package.json raiz não encontrado."
fi

if [[ -f "$WEB/package.json" ]]; then
  ok "apps/web/package.json encontrado."
else
  error "apps/web/package.json não encontrado."
fi

if [[ -f "$ROOT/apps/api/package.json" ]]; then
  ok "apps/api/package.json encontrado."
fi

if [[ -f "$ROOT/apps/worker/package.json" ]]; then
  ok "apps/worker/package.json encontrado."
fi

echo
echo "============================================================"
echo "12. INSTALAÇÃO / CONSISTÊNCIA DAS DEPENDÊNCIAS"
echo "============================================================"

case "$PM" in
  pnpm)
    pnpm install
    ;;
  yarn)
    yarn install
    ;;
  npm)
    npm install
    ;;
esac

ok "Dependências sincronizadas."

echo
echo "============================================================"
echo "13. TYPECHECK DO WEB"
echo "============================================================"

cd "$WEB"

TYPECHECK_OK=0

if [[ "$PM" == "pnpm" ]]; then
  if pnpm exec tsc --noEmit; then
    TYPECHECK_OK=1
  fi
elif [[ "$PM" == "yarn" ]]; then
  if yarn tsc --noEmit; then
    TYPECHECK_OK=1
  fi
else
  if npx tsc --noEmit; then
    TYPECHECK_OK=1
  fi
fi

if [[ "$TYPECHECK_OK" == "1" ]]; then
  ok "TypeScript: OK."
else
  error "TypeScript apresentou erros."
fi

echo
echo "============================================================"
echo "14. BUILD DO WEB"
echo "============================================================"

BUILD_OK=0

if [[ "$PM" == "pnpm" ]]; then
  if pnpm run build; then
    BUILD_OK=1
  fi
elif [[ "$PM" == "yarn" ]]; then
  if yarn build; then
    BUILD_OK=1
  fi
else
  if npm run build; then
    BUILD_OK=1
  fi
fi

if [[ "$BUILD_OK" == "1" ]]; then
  ok "Build do Web: OK."
else
  error "Build do Web apresentou erros."
fi

cd "$ROOT"

echo
echo "============================================================"
echo "15. DIAGNÓSTICO DO WORKER"
echo "============================================================"

WORKER="$ROOT/apps/worker"

if [[ -f "$WORKER/package.json" ]]; then

  python3 <<'PY'
import json
from pathlib import Path

file = Path("apps/worker/package.json")

try:
    data = json.loads(file.read_text())
    scripts = data.get("scripts", {})

    print("Scripts encontrados no Worker:")

    for key, value in scripts.items():
        print(f"  {key}: {value}")

    if "dev" not in scripts:
        print("⚠ Worker não possui script 'dev'.")
    else:
        print("✓ Worker possui script 'dev'.")

except Exception as exc:
    print(f"⚠ Não foi possível analisar package.json do Worker: {exc}")
PY

else
  warn "apps/worker/package.json não encontrado."
fi

echo
echo "============================================================"
echo "16. VERIFICAÇÃO FINAL DE BARRELS"
echo "============================================================"

BARRELS="$(
  find "$COMPONENTS" \
    -type f \
    -name "index.ts" \
    2>/dev/null || true
)"

if [[ -n "$BARRELS" ]]; then
  warn "index.ts ainda existentes em components/:"
  echo "$BARRELS"
else
  ok "Nenhum index.ts de barrel em components/."
fi

echo
echo "============================================================"
echo "17. VERIFICAÇÃO FINAL DE IMPORTS RELATIVOS"
echo "============================================================"

RELATIVE_FINAL="$(
  grep -RInE \
    --include='*.ts' \
    --include='*.tsx' \
    'from[[:space:]]+["'\''](\./|\.\./)' \
    "$COMPONENTS" \
    2>/dev/null || true
)"

if [[ -n "$RELATIVE_FINAL" ]]; then
  error "IMPORTS RELATIVOS RESTANTES:"
  echo "$RELATIVE_FINAL"
else
  ok "Nenhum import relativo em components/."
fi

echo
echo "============================================================"
echo "18. RELATÓRIO"
echo "============================================================"

echo
echo "Backup:"
echo "$BACKUP"

echo

if [[ "$TYPECHECK_OK" == "1" ]]; then
  ok "TypeScript"
else
  error "TypeScript"
fi

if [[ "$BUILD_OK" == "1" ]]; then
  ok "Build"
else
  error "Build"
fi

if [[ -z "$RELATIVE_FINAL" ]]; then
  ok "Arquitetura de imports dos components"
else
  error "Arquitetura de imports dos components"
fi

echo
echo "============================================================"
echo "                 SANEAMENTO FINALIZADO"
echo "============================================================"
echo

if [[ "$TYPECHECK_OK" != "1" || "$BUILD_OK" != "1" ]]; then
  warn "O projeto ainda possui erros de compilação."
  echo
  echo "O código existente NÃO foi apagado."
  echo "O backup está em:"
  echo "$BACKUP"
  echo
  exit 2
fi

ok "ViaPay Web passou pelo saneamento."
echo
echo "Próximo passo: corrigir somente os erros restantes"
echo "do Worker/API, sem reconstruir o monorepo."
echo
