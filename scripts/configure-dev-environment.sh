#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"

echo "============================================================"
echo " VIA PAY — DEVELOPMENT ENVIRONMENT CONFIGURATION"
echo "============================================================"
echo

cd "$ROOT"

BACKUP_DIR="$ROOT/.dev-config-backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo "[1/8] Validando workspace"
echo "------------------------------------------------------------"

if [[ ! -f "$ROOT/package.json" ]]; then
    echo "ERRO: package.json não encontrado."
    exit 1
fi

if [[ ! -f "$ROOT/pnpm-workspace.yaml" ]]; then
    echo "AVISO: pnpm-workspace.yaml não encontrado."
fi

echo "Workspace:"
echo "$ROOT"

echo
echo "[2/8] Backup dos package.json"
echo "------------------------------------------------------------"

for file in \
    "$ROOT/apps/web/package.json" \
    "$ROOT/apps/demo-store/package.json" \
    "$ROOT/apps/bank-core/package.json"
do

    if [[ -f "$file" ]]; then

        relative="${file#$ROOT/}"

        mkdir -p "$BACKUP_DIR/$(dirname "$relative")"

        cp "$file" "$BACKUP_DIR/$relative"

        echo "[BACKUP] $relative"

    fi

done

echo
echo "[3/8] Configurando ViaPay Web"
echo "------------------------------------------------------------"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/web/package.json";

if (!fs.existsSync(file)) {
  throw new Error(`Arquivo não encontrado: ${file}`);
}

const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.scripts ??= {};

pkg.scripts.dev = "next dev --port 3000";

fs.writeFileSync(
  file,
  JSON.stringify(pkg, null, 2) + "\n"
);

console.log("web:");
console.log("  dev = next dev --port 3000");
NODE

echo
echo "[4/8] Configurando Demo Store"
echo "------------------------------------------------------------"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/demo-store/package.json";

if (!fs.existsSync(file)) {
  console.log("demo-store não encontrado.");
  process.exit(0);
}

const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.scripts ??= {};

pkg.scripts.dev = "next dev --port 3050";

fs.writeFileSync(
  file,
  JSON.stringify(pkg, null, 2) + "\n"
);

console.log("demo-store:");
console.log("  dev = next dev --port 3050");
NODE

echo
echo "[5/8] Configurando Bank Core"
echo "------------------------------------------------------------"

node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/bank-core/package.json";

if (!fs.existsSync(file)) {
  console.log("bank-core não encontrado.");
  process.exit(0);
}

const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

pkg.scripts ??= {};

pkg.scripts.dev = "next dev --port 3010";

fs.writeFileSync(
  file,
  JSON.stringify(pkg, null, 2) + "\n"
);

console.log("bank-core:");
console.log("  dev = next dev --port 3010");
NODE

echo
echo "[6/8] Criando documentação das portas"
echo "------------------------------------------------------------"

mkdir -p "$ROOT/docs/development"

cat > "$ROOT/docs/development/PORTS.md" <<'EOF'
# ViaPay — Development Ports

## Frontends

| Serviço | Porta | URL |
|---|---:|---|
| ViaPay Web | 3000 | http://localhost:3000 |
| Demo Store | 3050 | http://localhost:3050 |
| Bank Core | 3010 | http://localhost:3010 |

## APIs

| Serviço | Porta | URL |
|---|---:|---|
| API | 3001 | http://localhost:3001 |
| Bank Core API | 4010 | http://localhost:4010 |
| Bank Gateway | 4020 | http://localhost:4020 |

## Workers

Workers não expõem necessariamente uma porta HTTP.

## Regra

A porta 3000 pertence ao ViaPay Web.

O Demo Store não deve ocupar a porta 3000.

O Bank Core possui frontend independente na porta 3010.

O ambiente principal de desenvolvimento do ViaPay deve utilizar estas portas de forma determinística.
EOF

echo "Documentação criada:"
echo "$ROOT/docs/development/PORTS.md"

echo
echo "[7/8] Criando script de inicialização individual"
echo "------------------------------------------------------------"

cat > "$ROOT/scripts/start-web.sh" <<'EOF'
#!/usr/bin/env bash

set -Eeuo pipefail

cd /mnt/ai-knowledge/viapay/apps/web

echo "============================================================"
echo " VIA PAY WEB"
echo "============================================================"
echo
echo "URL: http://localhost:3000"
echo

pnpm dev
EOF

chmod +x "$ROOT/scripts/start-web.sh"

echo "Criado:"
echo "$ROOT/scripts/start-web.sh"

echo
echo "[8/8] Validação"
echo "------------------------------------------------------------"

echo
echo "Web:"
node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/web/package.json";
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

console.log(pkg.scripts.dev);
NODE

echo
echo "Demo Store:"
node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/demo-store/package.json";
const pkg = JSON.parse(fs.readFileSync(file, "utf8"));

console.log(pkg.scripts.dev);
NODE

echo
echo "Bank Core:"
node <<'NODE'
const fs = require("fs");

const file = "/mnt/ai-knowledge/viapay/apps/bank-core/package.json";

if (fs.existsSync(file)) {
  const pkg = JSON.parse(fs.readFileSync(file, "utf8"));
  console.log(pkg.scripts?.dev ?? "dev não definido");
} else {
  console.log("package.json não encontrado");
}
NODE

echo
echo "============================================================"
echo " CONFIGURAÇÃO CONCLUÍDA"
echo "============================================================"
echo
echo "ViaPay Web:"
echo "  http://localhost:3000"
echo
echo "Demo Store:"
echo "  http://localhost:3050"
echo
echo "Bank Core:"
echo "  http://localhost:3010"
echo
echo "Backup:"
echo "$BACKUP_DIR"
echo

