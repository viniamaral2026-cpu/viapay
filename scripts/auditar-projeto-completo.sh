#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"

REPORT_DIR="$ROOT/audit"
REPORT="$REPORT_DIR/VIAPAY_AUDIT_$TIMESTAMP.txt"
TREE_FILE="$REPORT_DIR/VIAPAY_TREE_$TIMESTAMP.txt"
FILES_FILE="$REPORT_DIR/VIAPAY_FILES_$TIMESTAMP.txt"
EMPTY_FILE="$REPORT_DIR/VIAPAY_EMPTY_$TIMESTAMP.txt"
EXT_FILE="$REPORT_DIR/VIAPAY_EXTENSIONS_$TIMESTAMP.txt"
TODO_FILE="$REPORT_DIR/VIAPAY_TODO_$TIMESTAMP.txt"
GIT_FILE="$REPORT_DIR/VIAPAY_GIT_$TIMESTAMP.txt"

mkdir -p "$REPORT_DIR"

exec > >(tee "$REPORT") 2>&1

echo "============================================================"
echo " VIA PAY — AUDITORIA COMPLETA DO PROJETO"
echo "============================================================"
echo
echo "Data:       $(date)"
echo "Host:       $(hostname)"
echo "Usuário:    $(whoami)"
echo "Projeto:    $ROOT"
echo

if [[ ! -d "$ROOT" ]]; then
    echo "ERRO: diretório não encontrado:"
    echo "$ROOT"
    exit 1
fi

cd "$ROOT"

echo "============================================================"
echo "1. LOCALIZAÇÃO"
echo "============================================================"

pwd

echo

echo "============================================================"
echo "2. TAMANHO TOTAL"
echo "============================================================"

du -sh "$ROOT"

echo

echo "============================================================"
echo "3. QUANTIDADE TOTAL"
echo "============================================================"

TOTAL_DIRS="$(find "$ROOT" -type d -print | wc -l)"
TOTAL_FILES="$(find "$ROOT" -type f -print | wc -l)"
TOTAL_LINKS="$(find "$ROOT" -type l -print | wc -l)"

echo "Diretórios : $TOTAL_DIRS"
echo "Arquivos   : $TOTAL_FILES"
echo "Links      : $TOTAL_LINKS"

echo

echo "============================================================"
echo "4. TODAS AS PASTAS"
echo "============================================================"

find "$ROOT" -type d -print | sort | tee "$TREE_FILE"

echo

echo "============================================================"
echo "5. TODOS OS ARQUIVOS"
echo "============================================================"

find "$ROOT" -type f -print | sort | tee "$FILES_FILE"

echo

echo "============================================================"
echo "6. DIRETÓRIOS VAZIOS"
echo "============================================================"

EMPTY_DIRS="$(find "$ROOT" -type d -empty -print | sort || true)"

if [[ -n "$EMPTY_DIRS" ]]; then
    echo "$EMPTY_DIRS"
else
    echo "NENHUM DIRETÓRIO VAZIO ENCONTRADO."
fi

echo "$EMPTY_DIRS" > "$EMPTY_FILE"

echo

echo "============================================================"
echo "7. ARQUIVOS VAZIOS"
echo "============================================================"

EMPTY_FILES="$(find "$ROOT" -type f -empty -print | sort || true)"

if [[ -n "$EMPTY_FILES" ]]; then
    echo "$EMPTY_FILES"
else
    echo "NENHUM ARQUIVO VAZIO ENCONTRADO."
fi

{
    echo "DIRETÓRIOS VAZIOS"
    echo "=================="
    echo "$EMPTY_DIRS"
    echo
    echo "ARQUIVOS VAZIOS"
    echo "================"
    echo "$EMPTY_FILES"
} >> "$EMPTY_FILE"

echo

echo "============================================================"
echo "8. ARQUIVOS OCULTOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -name '.*' \
    -print \
    | sort || true

echo

echo "============================================================"
echo "9. LINKS SIMBÓLICOS"
echo "============================================================"

find "$ROOT" \
    -type l \
    -printf '%p -> %l\n' \
    | sort || true

echo

echo "============================================================"
echo "10. ARQUIVOS POR EXTENSÃO"
echo "============================================================"

find "$ROOT" -type f -print \
    | awk '
    {
        n=$0
        sub(/^.*\//, "", n)

        if (n !~ /\./) {
            ext="[SEM_EXTENSAO]"
        } else {
            sub(/^.*\./, "", n)
            ext="." n
        }

        count[ext]++
    }

    END {
        for (ext in count)
            print count[ext], ext
    }' \
    | sort -nr \
    | tee "$EXT_FILE"

echo

echo "============================================================"
echo "11. TAMANHO DOS ARQUIVOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -printf '%s\t%p\n' \
    | sort -nr \
    | head -200 \
    | while IFS=$'\t' read -r size file; do
        human="$(numfmt --to=iec "$size" 2>/dev/null || echo "${size} bytes")"
        printf "%-12s %s\n" "$human" "$file"
      done

echo

echo "============================================================"
echo "12. MAIORES ARQUIVOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -printf '%s\t%p\n' \
    | sort -nr \
    | head -50 \
    | while IFS=$'\t' read -r size file; do
        human="$(numfmt --to=iec "$size" 2>/dev/null || echo "${size} bytes")"
        printf "%-12s %s\n" "$human" "$file"
      done

echo

echo "============================================================"
echo "13. ARQUIVOS IMPORTANTES DE PROJETO"
echo "============================================================"

IMPORTANT_FILES=(
    "README.md"
    "README.txt"
    "ARCHITECTURE.md"
    "AI_PROJECT_CONTEXT.md"
    "CONTRIBUTING.md"
    "SECURITY.md"
    "LICENSE"
    "package.json"
    "package-lock.json"
    "pnpm-lock.yaml"
    "yarn.lock"
    "composer.json"
    "composer.lock"
    "pyproject.toml"
    "requirements.txt"
    "Cargo.toml"
    "go.mod"
    "Dockerfile"
    "docker-compose.yml"
    "compose.yml"
    ".env"
    ".env.example"
    ".gitignore"
    "tsconfig.json"
    "next.config.js"
    "next.config.mjs"
    "vite.config.ts"
)

for file in "${IMPORTANT_FILES[@]}"; do
    if [[ -f "$ROOT/$file" ]]; then
        echo "[EXISTE] $file"
    else
        echo "[NÃO ENCONTRADO] $file"
    fi
done

echo

echo "============================================================"
echo "14. PACKAGE.JSON ENCONTRADOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -name "package.json" \
    -print \
    | sort || true

echo

echo "============================================================"
echo "15. COMPOSER.JSON ENCONTRADOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -name "composer.json" \
    -print \
    | sort || true

echo

echo "============================================================"
echo "16. DOCKERFILES"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -name "Dockerfile" \
        -o -name "Dockerfile.*" \
        -o -name "*.dockerfile" \
    \) \
    -print \
    | sort || true

echo

echo "============================================================"
echo "17. DOCKER COMPOSE"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -name "docker-compose.yml" \
        -o -name "docker-compose.yaml" \
        -o -name "compose.yml" \
        -o -name "compose.yaml" \
    \) \
    -print \
    | sort || true

echo

echo "============================================================"
echo "18. ENVIRONMENT FILES"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -name ".env" \
        -o -name ".env.*" \
    \) \
    -print \
    | sort || true

echo

echo "============================================================"
echo "19. DOCUMENTAÇÃO"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*.md" \
        -o -iname "*.mdx" \
        -o -iname "*.rst" \
        -o -iname "*.txt" \
        -o -iname "*.adoc" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "20. CÓDIGO TYPESCRIPT / JAVASCRIPT"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*.ts" \
        -o -iname "*.tsx" \
        -o -iname "*.js" \
        -o -iname "*.jsx" \
        -o -iname "*.mjs" \
        -o -iname "*.cjs" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "21. CÓDIGO PHP"
echo "============================================================"

find "$ROOT" \
    -type f \
    -iname "*.php" \
    -print \
    | sort

echo

echo "============================================================"
echo "22. CÓDIGO PYTHON"
echo "============================================================"

find "$ROOT" \
    -type f \
    -iname "*.py" \
    -print \
    | sort

echo

echo "============================================================"
echo "23. SQL / DATABASE"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*.sql" \
        -o -iname "*.prisma" \
        -iname "*migration*" \
        -o -iname "*schema*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "24. TESTES"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*test*" \
        -o -iname "*spec*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "25. TODO / FIXME / HACK / XXX"
echo "============================================================"

grep -RniE \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    --exclude-dir=audit \
    --exclude='*.lock' \
    -E 'TODO|FIXME|HACK|XXX|TBD|NOT_IMPLEMENTED|IMPLEMENT_ME' \
    "$ROOT" \
    2>/dev/null \
    | tee "$TODO_FILE" || true

echo

echo "============================================================"
echo "26. PLACEHOLDERS"
echo "============================================================"

grep -RniE \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    --exclude-dir=audit \
    --exclude='*.lock' \
    -E \
    'placeholder|coming soon|not implemented|not implemented yet|stub|mock|dummy|example only|change me|replace me' \
    "$ROOT" \
    2>/dev/null \
    | head -500 || true

echo

echo "============================================================"
echo "27. GIT"
echo "============================================================"

if [[ -d "$ROOT/.git" ]]; then

    echo "Git repository: SIM"

    echo
    echo "--- git status ---"
    git status --short || true

    echo
    echo "--- branch ---"
    git branch --show-current || true

    echo
    echo "--- remotes ---"
    git remote -v || true

    echo
    echo "--- last commits ---"
    git log --oneline -10 || true

    {
        echo "Git repository: SIM"
        echo
        git status --short || true
        echo
        git branch --show-current || true
        echo
        git remote -v || true
        echo
        git log --oneline -20 || true
    } > "$GIT_FILE"

else

    echo "Git repository: NÃO ENCONTRADO"

fi

echo

echo "============================================================"
echo "28. DIRETÓRIOS PRINCIPAIS"
echo "============================================================"

for dir in \
    apps \
    core \
    services \
    packages \
    integrations \
    infrastructure \
    database \
    contracts \
    docs \
    tests \
    scripts \
    bank-architecture \
    audit
do

    if [[ -d "$ROOT/$dir" ]]; then
        echo "[EXISTE] $dir"
        find "$ROOT/$dir" -maxdepth 2 -type d | sort
    else
        echo "[NÃO EXISTE] $dir"
    fi

done

echo

echo "============================================================"
echo "29. ARQUITETURA BANCÁRIA"
echo "============================================================"

find "$ROOT" \
    -type d \
    \( \
        -iname "*bank*" \
        -o -iname "*banking*" \
        -o -iname "*core*" \
        -o -iname "*ledger*" \
        -o -iname "*payment*" \
        -o -iname "*settlement*" \
        -o -iname "*reconciliation*" \
        -o -iname "*compliance*" \
        -o -iname "*authorization*" \
        -o -iname "*identity*" \
        -o -iname "*sandbox*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "30. INTEGRAÇÕES"
echo "============================================================"

find "$ROOT" \
    -type d \
    \( \
        -iname "*integration*" \
        -o -iname "*adapter*" \
        -o -iname "*provider*" \
        -o -iname "*connector*" \
        -o -iname "*gateway*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "31. DOCUMENTOS DE ARQUITETURA"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*architecture*" \
        -o -iname "*design*" \
        -o -iname "*adr*" \
        -iname "*context*" \
        -o -iname "*spec*" \
        -o -iname "*blueprint*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "32. APIs"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*openapi*" \
        -o -iname "*swagger*" \
        -o -iname "*api*" \
        -o -iname "*.graphql" \
        -o -iname "*.proto" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "33. SEGURANÇA"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*security*" \
        -o -iname "*auth*" \
        -o -iname "*mfa*" \
        -o -iname "*rbac*" \
        -o -iname "*abac*" \
        -o -iname "*permission*" \
        -o -iname "*audit*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "34. ARQUIVOS SUSPEITOS DE SEREM PLACEHOLDER"
echo "============================================================"

find "$ROOT" \
    -type f \
    -size 0 \
    -o \
    -type f \
    -name "*.example" \
    -o \
    -type f \
    -name "*.sample" \
    | sort || true

echo

echo "============================================================"
echo "35. PERMISSÕES EXECUTÁVEIS"
echo "============================================================"

find "$ROOT" \
    -type f \
    -perm /111 \
    -print \
    | sort || true

echo

echo "============================================================"
echo "36. ARQUIVOS COM NOMES SUSPEITOS"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*backup*" \
        -o -iname "*old*" \
        -o -iname "*copy*" \
        -o -iname "*tmp*" \
        -o -iname "*temp*" \
        -o -iname "*final*" \
        -o -iname "*new*" \
        -o -iname "*v2*" \
    \) \
    -print \
    | sort || true

echo

echo "============================================================"
echo "37. ARQUIVOS DE CONFIGURAÇÃO"
echo "============================================================"

find "$ROOT" \
    -type f \
    \( \
        -iname "*.json" \
        -o -iname "*.yaml" \
        -o -iname "*.yml" \
        -o -iname "*.toml" \
        -o -iname "*.ini" \
        -o -iname "*.conf" \
        -o -iname "*.config.*" \
    \) \
    -print \
    | sort

echo

echo "============================================================"
echo "38. ÁRVORE RESUMIDA"
echo "============================================================"

if command -v tree >/dev/null 2>&1; then

    tree -a -I \
        'node_modules|.git|audit|dist|build|coverage|.next|vendor' \
        "$ROOT" \
        | tee -a "$REPORT"

else

    echo "tree não instalado."
    echo "Utilizando find:"
    find "$ROOT" \
        -maxdepth 6 \
        -print \
        | sort

fi

echo

echo "============================================================"
echo "39. ESTATÍSTICAS POR DIRETÓRIO"
echo "============================================================"

find "$ROOT" \
    -type d \
    -not -path "$ROOT/audit*" \
    -print \
    | while read -r dir; do

        count="$(find "$dir" -maxdepth 1 -type f | wc -l)"
        size="$(du -sh "$dir" 2>/dev/null | awk '{print $1}')"

        printf "%-10s %-10s %s\n" \
            "$count arquivos" \
            "$size" \
            "$dir"

      done \
    | sort -k3

echo

echo "============================================================"
echo "40. RESUMO FINAL"
echo "============================================================"

echo "Projeto:"
echo "$ROOT"
echo

echo "Diretórios:"
echo "$TOTAL_DIRS"
echo

echo "Arquivos:"
echo "$TOTAL_FILES"
echo

echo "Links:"
echo "$TOTAL_LINKS"
echo

echo "Diretórios vazios:"
find "$ROOT" -type d -empty | wc -l

echo

echo "Arquivos vazios:"
find "$ROOT" -type f -empty | wc -l

echo

echo "Tamanho:"
du -sh "$ROOT"

echo

echo "Relatório principal:"
echo "$REPORT"

echo

echo "Árvore:"
echo "$TREE_FILE"

echo

echo "Arquivos:"
echo "$FILES_FILE"

echo

echo "Vazios:"
echo "$EMPTY_FILE"

echo

echo "Extensões:"
echo "$EXT_FILE"

echo

echo "TODO/FIXME:"
echo "$TODO_FILE"

echo

echo "Git:"
echo "$GIT_FILE"

echo
echo "============================================================"
echo " AUDITORIA CONCLUÍDA"
echo "============================================================"