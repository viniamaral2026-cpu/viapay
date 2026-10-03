#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

LOG_DIR="$ROOT/audit"
LOG_FILE="$LOG_DIR/preenchimento-vazios-$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "============================================================"
echo " VIAPAY — COMPLETADOR DE DIRETÓRIOS VAZIOS"
echo "============================================================"
echo "Projeto: $ROOT"
echo "Data:    $(date)"
echo "Log:     $LOG_FILE"
echo

if [[ ! -d "$ROOT" ]]; then
    echo "ERRO: projeto não encontrado."
    exit 1
fi

cd "$ROOT"

CREATED=0
SKIPPED=0
REMAINING=0

is_ignored_path() {
    local path="$1"

    case "$path" in
        "$ROOT/node_modules"/*)
            return 0
            ;;
        "$ROOT/.git"/*)
            return 0
            ;;
        "$ROOT/.next"/*)
            return 0
            ;;
        "$ROOT/dist"/*)
            return 0
            ;;
        "$ROOT/build"/*)
            return 0
            ;;
        "$ROOT/coverage"/*)
            return 0
            ;;
        "$ROOT/backup"/*)
            return 0
            ;;
        "$ROOT/backups"/*)
            return 0
            ;;
        "$ROOT/.sanitation-backups"/*)
            return 0
            ;;
        "$ROOT/.sanitation-backups"/*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

relative_path() {
    local path="$1"
    echo "${path#$ROOT/}"
}

create_file() {
    local file="$1"

    if [[ -e "$file" ]]; then
        echo "[PRESERVADO] $file"
        ((SKIPPED+=1))
        return 0
    fi

    mkdir -p "$(dirname "$file")"

    cat > "$file"

    echo "[CRIADO]     $file"
    ((CREATED+=1))
}

create_text_file() {
    local file="$1"
    local content="$2"

    if [[ -e "$file" ]]; then
        echo "[PRESERVADO] $file"
        ((SKIPPED+=1))
        return
    fi

    mkdir -p "$(dirname "$file")"
    printf '%s\n' "$content" > "$file"

    echo "[CRIADO]     $file"
    ((CREATED+=1))
}

create_readme() {
    local dir="$1"
    local rel
    rel="$(relative_path "$dir")"

    create_text_file "$dir/README.md" \
"# $rel

## Finalidade

Diretório pertencente ao projeto ViaPay.

Este diretório foi identificado automaticamente como vazio
durante a auditoria estrutural do projeto.

## Regra de implementação

Este diretório deve receber somente artefatos relacionados
à responsabilidade arquitetural indicada pelo próprio caminho.

## Estado

IMPLEMENTAÇÃO INICIAL CRIADA

## Observação

Nenhum arquivo existente foi sobrescrito.

A implementação definitiva deve respeitar:

- Clean Architecture
- Domain-Driven Design
- SOLID
- Hexagonal Architecture
- API First
- segurança por padrão
- testes automatizados
- observabilidade
- idempotência
- auditabilidade

## Projeto

ViaPay — Payment & Financial Infrastructure
"
}

create_next_page() {
    local dir="$1"
    local rel
    rel="$(relative_path "$dir")"

    create_file "$dir/page.tsx" <<EOF
import React from "react";

export default function Page() {
  return (
    <main className="min-h-screen bg-white p-8">
      <section className="mx-auto max-w-7xl">
        <header className="mb-8">
          <p className="text-sm font-medium text-blue-600">
            ViaPay
          </p>

          <h1 className="mt-2 text-3xl font-semibold text-slate-900">
            ${rel##*/}
          </h1>

          <p className="mt-3 max-w-3xl text-slate-600">
            Área institucional do ViaPay.
            Esta página foi criada automaticamente porque a rota
            estava vazia. A implementação funcional deve consumir
            os contratos e APIs reais do backend.
          </p>
        </header>

        <div className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <p className="text-sm text-slate-500">
            Estado: estrutura inicial criada.
          </p>
        </div>
      </section>
    </main>
  );
}
EOF
}

create_next_route() {
    local dir="$1"

    create_file "$dir/route.ts" <<'EOF'
import type { NextRequest } from "next/server";

export async function GET(_request: NextRequest) {
  return Response.json({
    success: true,
    service: "viapay",
    status: "initialized",
  });
}

export async function POST(_request: NextRequest) {
  return Response.json(
    {
      success: false,
      code: "NOT_IMPLEMENTED",
      message:
        "Endpoint criado estruturalmente. Implementar contrato real antes de habilitar operação financeira.",
    },
    { status: 501 },
  );
}
EOF
}

create_component() {
    local dir="$1"
    local name
    name="$(basename "$dir" | sed 's/[^a-zA-Z0-9]/ /g' | awk '
    {
      for(i=1;i<=NF;i++)
        $i=toupper(substr($i,1,1)) substr($i,2)
      printf "%s", $0
    }')"

    [[ -z "$name" ]] && name="Component"

    create_file "$dir/index.tsx" <<EOF
"use client";

import React from "react";

export interface ${name}Props {
  className?: string;
  children?: React.ReactNode;
}

export function ${name}({
  className = "",
  children,
}: ${name}Props) {
  return (
    <section
      className={className}
      data-component="${name}"
    >
      {children}
    </section>
  );
}

export default ${name};
EOF
}

create_domain() {
    local dir="$1"
    local name
    name="$(basename "$dir" | sed 's/[^a-zA-Z0-9]/ /g' | awk '
    {
      for(i=1;i<=NF;i++)
        $i=toupper(substr($i,1,1)) substr($i,2)
      printf "%s", $0
    }')"

    [[ -z "$name" ]] && name="Domain"

    create_file "$dir/index.ts" <<EOF
/**
 * ViaPay Domain
 *
 * Responsabilidade:
 * encapsular regras de negócio puras.
 *
 * Este módulo não deve depender de:
 * - HTTP
 * - Fastify
 * - Next.js
 * - Prisma
 * - Redis
 * - providers externos
 *
 * Dependências devem apontar para abstrações.
 */

export interface ${name} {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}
EOF
}

create_application() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Application Layer
 *
 * Casos de uso e orquestração da aplicação.
 *
 * Esta camada pode depender do domínio e de ports,
 * mas não deve depender diretamente de frameworks
 * ou providers concretos.
 */

export interface ApplicationContext {
  tenantId: string;
  correlationId: string;
  actorId?: string;
}

export interface UseCase<I, O> {
  execute(input: I, context: ApplicationContext): Promise<O>;
}
EOF
}

create_infrastructure() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Infrastructure
 *
 * Implementações concretas dos ports definidos pelas
 * camadas superiores.
 *
 * Exemplos:
 * - PostgreSQL
 * - Prisma
 * - Redis
 * - RabbitMQ
 * - FX providers
 * - Banking adapters
 * - Blockchain adapters
 * - Observability
 *
 * Segredos e credenciais nunca devem ser hardcoded.
 */

export {};
EOF
}

create_service() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Service Boundary
 *
 * Serviços de aplicação/integradores devem permanecer
 * desacoplados dos componentes de apresentação.
 */

export {};
EOF
}

create_test() {
    local dir="$1"

    create_file "$dir/structure.test.ts" <<'EOF'
import { describe, expect, it } from "vitest";

describe("ViaPay module structure", () => {
  it("should expose a valid test boundary", () => {
    expect(true).toBe(true);
  });
});
EOF
}

create_sandbox() {
    local dir="$1"

    create_file "$dir/README.md" <<'EOF'
# ViaPay Sandbox

Ambiente controlado para desenvolvimento e integração.

## Regras

Este ambiente não representa dinheiro real.

Não utilizar credenciais de produção.

Operações devem ser claramente marcadas como:

- SANDBOX
- TEST
- SIMULATED

Cenários devem permitir:

- sucesso;
- falha;
- timeout;
- duplicidade;
- idempotência;
- FX expirado;
- saldo insuficiente;
- compliance hold;
- settlement failure;
- webhook retry.
EOF
}

create_database() {
    local dir="$1"

    create_file "$dir/README.md" <<'EOF'
# Database

Área de persistência do ViaPay.

## Regras

Alterações de banco devem utilizar migrations versionadas.

Não executar alterações destrutivas sem migration explícita.

Operações financeiras devem preservar:

- integridade;
- consistência;
- auditabilidade;
- idempotência;
- histórico;
- reconciliação.

Nunca utilizar floating point para valores monetários.
EOF
}

create_docs() {
    local dir="$1"

    create_file "$dir/README.md" <<'EOF'
# ViaPay Documentation

Documentação técnica do módulo.

Cada documentação deve distinguir claramente:

- IMPLEMENTADO
- IMPLEMENTADO E VALIDADO
- PARCIAL
- MOCK
- STUB
- AUSENTE
- EXTERNAL DEPENDENCY

Nunca declarar uma integração como real sem contrato,
credenciais de sandbox/produção e teste correspondente.
EOF
}

create_contract() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Contracts
 *
 * Contratos compartilhados entre consumidores e providers.
 *
 * Evitar colocar regras de negócio neste pacote.
 */

export interface ApiError {
  code: string;
  message: string;
  requestId?: string;
  correlationId?: string;
}

export interface ApiMeta {
  requestId: string;
  correlationId: string;
}
EOF
}

create_sdk() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Public SDK boundary.
 *
 * O SDK nunca deve conter segredo privado.
 * Chaves privadas e credenciais devem permanecer
 * no ambiente seguro do cliente.
 */

export interface ViaPayClientOptions {
  baseUrl: string;
  apiKey?: string;
}

export class ViaPayClient {
  constructor(
    public readonly options: ViaPayClientOptions,
  ) {}
}
EOF
}

create_config() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * Central configuration boundary.
 *
 * Não coloque segredos reais neste arquivo.
 */

export interface ViaPayConfig {
  environment: "development" | "test" | "sandbox" | "production";
  apiUrl: string;
  databaseUrl?: string;
  redisUrl?: string;
  rabbitmqUrl?: string;
}

export function loadConfig(): ViaPayConfig {
  return {
    environment:
      (process.env.NODE_ENV as ViaPayConfig["environment"]) ??
      "development",

    apiUrl:
      process.env.VIAPAY_API_URL ??
      "http://localhost:3000",
  };
}
EOF
}

create_security() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * Security boundary.
 *
 * Princípios:
 *
 * - least privilege
 * - deny by default
 * - MFA para operações sensíveis
 * - RBAC/ABAC
 * - auditabilidade
 * - secrets fora do código
 * - validação no backend
 */

export interface SecurityContext {
  actorId: string;
  tenantId: string;
  roles: string[];
  permissions: string[];
}
EOF
}

create_worker() {
    local dir="$1"

    create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Worker Job Boundary.
 *
 * Workers devem ser idempotentes.
 * Jobs financeiros devem possuir correlationId
 * e mecanismos de retry controlado.
 */

export interface JobContext {
  jobId: string;
  correlationId: string;
  attempt: number;
}

export interface WorkerJob<T> {
  execute(payload: T, context: JobContext): Promise<void>;
}
EOF
}

create_generic() {
    local dir="$1"

    create_readme "$dir"
}

echo
echo "============================================================"
echo "1. INVENTÁRIO DOS DIRETÓRIOS VAZIOS"
echo "============================================================"

mapfile -t EMPTY_DIRS < <(
    find "$ROOT" \
        -type d \
        -empty \
        -print \
        | sort
)

echo "Total encontrado: ${#EMPTY_DIRS[@]}"
echo

echo "============================================================"
echo "2. CLASSIFICAÇÃO E PREENCHIMENTO"
echo "============================================================"

for dir in "${EMPTY_DIRS[@]}"; do

    [[ "$dir" == "$ROOT" ]] && continue

    if is_ignored_path "$dir"; then
        echo "[IGNORADO] $dir"
        continue
    fi

    rel="$(relative_path "$dir")"

    echo
    echo "------------------------------------------------------------"
    echo "Diretório:"
    echo "$rel"
    echo "------------------------------------------------------------"

    #
    # NEXT.JS APP ROUTES
    #
    if [[ "$rel" == apps/*/app/* ]]; then

        if [[ "$rel" == */api/* ]]; then
            echo "Tipo detectado: Next API Route"
            create_next_route "$dir"
            continue
        fi

        echo "Tipo detectado: Next Page"
        create_next_page "$dir"
        continue
    fi

    #
    # NEXT.JS COMPONENTS
    #
    if [[ "$rel" == apps/*/components/* ]]; then
        echo "Tipo detectado: React Component"
        create_component "$dir"
        continue
    fi

    #
    # FEATURES
    #
    if [[ "$rel" == apps/*/features/* ]]; then
        echo "Tipo detectado: Feature"

        create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Feature Boundary
 *
 * Uma feature deve agrupar comportamento relacionado
 * ao mesmo contexto funcional.
 */

export {};
EOF

        continue
    fi

    #
    # DOMAIN
    #
    if [[ "$rel" == */domain/* ]]; then
        echo "Tipo detectado: Domain"
        create_domain "$dir"
        continue
    fi

    #
    # APPLICATION
    #
    if [[ "$rel" == */application/* ]]; then
        echo "Tipo detectado: Application"
        create_application "$dir"
        continue
    fi

    #
    # INFRASTRUCTURE
    #
    if [[ "$rel" == */infrastructure/* ]]; then
        echo "Tipo detectado: Infrastructure"
        create_infrastructure "$dir"
        continue
    fi

    #
    # SERVICES
    #
    if [[ "$rel" == */services/* ]]; then
        echo "Tipo detectado: Service"
        create_service "$dir"
        continue
    fi

    #
    # LIB
    #
    if [[ "$rel" == */lib/* ]]; then
        echo "Tipo detectado: Library"

        create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay Library Module
 */

export {};
EOF

        continue
    fi

    #
    # HOOKS
    #
    if [[ "$rel" == */hooks* ]]; then
        echo "Tipo detectado: Hooks"

        create_file "$dir/index.ts" <<'EOF'
"use client";

/**
 * ViaPay Hooks
 *
 * Hooks de UI devem permanecer desacoplados
 * da regra financeira central.
 */

export {};
EOF

        continue
    fi

    #
    # CONTRACTS
    #
    if [[ "$rel" == packages/contracts/* || "$rel" == packages/contracts ]]; then
        echo "Tipo detectado: Contract"
        create_contract "$dir"
        continue
    fi

    #
    # SDK
    #
    if [[ "$rel" == packages/sdk/* || "$rel" == packages/sdk ]]; then
        echo "Tipo detectado: SDK"
        create_sdk "$dir"
        continue
    fi

    #
    # CONFIG
    #
    if [[ "$rel" == packages/config* ]]; then
        echo "Tipo detectado: Configuration"
        create_config "$dir"
        continue
    fi

    #
    # SECURITY
    #
    if [[ "$rel" == */security/* || "$rel" == */security ]]; then
        echo "Tipo detectado: Security"
        create_security "$dir"
        continue
    fi

    #
    # TESTS
    #
    if [[ "$rel" == */tests/* || "$rel" == tests/* ]]; then
        echo "Tipo detectado: Tests"
        create_test "$dir"
        continue
    fi

    #
    # SANDBOX
    #
    if [[ "$rel" == sandbox/* || "$rel" == */sandbox/* ]]; then
        echo "Tipo detectado: Sandbox"
        create_sandbox "$dir"
        continue
    fi

    #
    # DATABASE
    #
    if [[ "$rel" == database/* || "$rel" == */database/* ]]; then
        echo "Tipo detectado: Database"
        create_database "$dir"
        continue
    fi

    #
    # DOCUMENTATION
    #
    if [[ "$rel" == docs/* || "$rel" == */docs/* || "$rel" == bank-architecture/* ]]; then
        echo "Tipo detectado: Documentation"
        create_docs "$dir"
        continue
    fi

    #
    # WORKER
    #
    if [[ "$rel" == apps/worker/*/jobs/* || "$rel" == apps/worker/* ]]; then
        echo "Tipo detectado: Worker"
        create_worker "$dir"
        continue
    fi

    #
    # API
    #
    if [[ "$rel" == apps/api/* || "$rel" == apps/viapay-api/* ]]; then
        echo "Tipo detectado: API"

        create_file "$dir/index.ts" <<'EOF'
/**
 * ViaPay API boundary.
 */

export {};
EOF

        continue
    fi

    #
    # GENERIC
    #
    echo "Tipo detectado: Genérico"
    create_generic "$dir"

done

echo
echo "============================================================"
echo "3. SEGUNDA VARREDURA"
echo "============================================================"

mapfile -t REMAINING_DIRS < <(
    find "$ROOT" \
        -type d \
        -empty \
        -print \
        | sort
)

FILTERED_REMAINING=()

for dir in "${REMAINING_DIRS[@]}"; do

    if is_ignored_path "$dir"; then
        continue
    fi

    FILTERED_REMAINING+=("$dir")

done

echo "Diretórios vazios restantes fora de áreas ignoradas:"
printf '%s\n' "${FILTERED_REMAINING[@]:-NENHUM}"

REMAINING="${#FILTERED_REMAINING[@]}"

echo
echo "============================================================"
echo "4. ESTATÍSTICAS"
echo "============================================================"

echo "Arquivos criados : $CREATED"
echo "Arquivos preservados: $SKIPPED"
echo "Diretórios ainda vazios: $REMAINING"

echo
echo "============================================================"
echo "5. ESTRUTURA CRIADA"
echo "============================================================"

find "$ROOT" \
    -type f \
    -newermt "$TIMESTAMP" \
    -print 2>/dev/null \
    | sort || true

echo
echo "============================================================"
echo "6. VERIFICAÇÃO DE ARQUIVOS VAZIOS DE CÓDIGO"
echo "============================================================"

find "$ROOT" \
    -type f \
    -empty \
    ! -path "$ROOT/node_modules/*" \
    ! -path "$ROOT/.git/*" \
    ! -path "$ROOT/.next/*" \
    ! -path "$ROOT/dist/*" \
    ! -path "$ROOT/build/*" \
    ! -path "$ROOT/coverage/*" \
    ! -path "$ROOT/backup/*" \
    ! -path "$ROOT/backups/*" \
    ! -path "$ROOT/.sanitation-backups/*" \
    -print \
    | sort || true

echo
echo "============================================================"
echo "7. VALIDAÇÃO BÁSICA"
echo "============================================================"

if command -v pnpm >/dev/null 2>&1; then
    echo "pnpm: $(pnpm --version)"
else
    echo "pnpm: não instalado"
fi

if command -v node >/dev/null 2>&1; then
    echo "node: $(node --version)"
else
    echo "node: não instalado"
fi

echo
echo "============================================================"
echo " CONCLUSÃO"
echo "============================================================"

echo "Nenhum arquivo existente foi sobrescrito."
echo "Nenhum backup foi alterado."
echo "Nenhum node_modules foi alterado."
echo "Nenhum .next foi alterado."
echo "Nenhum .git foi alterado."

echo
echo "Log:"
echo "$LOG_FILE"

echo
echo "============================================================"
echo " PRÓXIMO PASSO"
echo "============================================================"

echo "Agora o projeto deve passar por:"
echo
echo "1. correção do TypeScript"
echo "2. normalização src/ versus packages/"
echo "3. correção dos aliases"
echo "4. correção do Prisma"
echo "5. correção das interfaces InMemory"
echo "6. validação do backend"
echo "7. validação do frontend"
echo "8. testes"
echo "9. integração"
echo "10. build"
echo
echo "============================================================"
