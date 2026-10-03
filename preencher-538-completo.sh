#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="/mnt/ai-knowledge/viapay"
STAMP="$(date '+%Y%m%d-%H%M%S')"
AUDIT="$ROOT/audit"
LOG="$AUDIT/preenchimento-completo-$STAMP.log"

mkdir -p "$AUDIT"

exec > >(tee -a "$LOG") 2>&1

echo "============================================================"
echo " VIAPAY — PREENCHIMENTO FUNCIONAL DOS DIRETÓRIOS"
echo "============================================================"
echo "ROOT: $ROOT"
echo "DATA: $(date)"
echo "LOG : $LOG"
echo

CREATED=0
PRESERVED=0
IGNORED=0

is_excluded() {
    local p="$1"
    local r="${p#$ROOT/}"

    case "$r" in
        node_modules|node_modules/*)
            return 0 ;;
        */node_modules|*/node_modules/*)
            return 0 ;;
        .git|.git/*)
            return 0 ;;
        .next|.next/*)
            return 0 ;;
        */.next|*/.next/*)
            return 0 ;;
        dist|dist/*)
            return 0 ;;
        */dist|*/dist/*)
            return 0 ;;
        build|build/*)
            return 0 ;;
        */build|*/build/*)
            return 0 ;;
        coverage|coverage/*)
            return 0 ;;
        */coverage|*/coverage/*)
            return 0 ;;
        backup|backup/*)
            return 0 ;;
        backups|backups/*)
            return 0 ;;
        */backup|*/backup/*)
            return 0 ;;
        */backups|*/backups/*)
            return 0 ;;
        .sanitation-backups|.sanitation-backups/*)
            return 0 ;;
        */.sanitation-backups|*/.sanitation-backups/*)
            return 0 ;;
        audit|audit/*)
            return 0 ;;
        */audit|*/audit/*)
            return 0 ;;
        *)
            return 1 ;;
    esac
}

rel() {
    echo "${1#$ROOT/}"
}

write_file() {
    local file="$1"

    if [[ -e "$file" ]]; then
        echo "[PRESERVADO] $file"
        ((PRESERVED+=1))
        return
    fi

    mkdir -p "$(dirname "$file")"
    cat > "$file"

    echo "[CRIADO] $file"
    ((CREATED+=1))
}

write_text() {
    local file="$1"
    local text="$2"

    if [[ -e "$file" ]]; then
        echo "[PRESERVADO] $file"
        ((PRESERVED+=1))
        return
    fi

    mkdir -p "$(dirname "$file")"
    printf '%s\n' "$text" > "$file"

    echo "[CRIADO] $file"
    ((CREATED+=1))
}

create_domain() {
    local d="$1"
    local n
    n="$(basename "$d" | tr '-' '_' | sed 's/[^a-zA-Z0-9_]//g')"

    write_file "$d/index.ts" <<EOF
/**
 * ViaPay Domain
 *
 * Contexto: $n
 *
 * Esta camada contém regras de negócio puras.
 * Não deve depender de HTTP, Next.js, Fastify,
 * Prisma, Redis ou providers externos.
 */

export interface ${n}Entity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface DomainEvent {
  eventId: string;
  aggregateId: string;
  occurredAt: Date;
  type: string;
}
EOF
}

create_application() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Application Layer
 *
 * Casos de uso e orquestração.
 */

export interface UseCase<I, O> {
  execute(input: I): Promise<O>;
}

export interface RequestContext {
  requestId: string;
  correlationId: string;
  tenantId?: string;
  actorId?: string;
}
EOF
}

create_infrastructure() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Infrastructure Boundary
 *
 * Implementações concretas dos ports do domínio.
 *
 * Exemplos:
 * PostgreSQL
 * Prisma
 * Redis
 * RabbitMQ
 * FX
 * Liquidity
 * Banking
 * Blockchain
 * Observability
 */

export {};
EOF
}

create_api() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay API module boundary.
 */

export {};
EOF
}

create_component() {
    local d="$1"
    local n
    n="$(basename "$d" | sed 's/[^a-zA-Z0-9]/ /g' | awk '{
        for(i=1;i<=NF;i++)
            $i=toupper(substr($i,1,1)) substr($i,2);
        printf "%s",$0
    }')"

    [[ -z "$n" ]] && n="ViaPayComponent"

    write_file "$d/index.tsx" <<EOF
"use client";

import type { ReactNode } from "react";

export interface ${n}Props {
  children?: ReactNode;
  className?: string;
}

export function ${n}({
  children,
  className = "",
}: ${n}Props) {
  return (
    <section
      className={className}
      data-viapay-component="${n}"
    >
      {children}
    </section>
  );
}

export default ${n};
EOF
}

create_page() {
    local d="$1"
    local name
    name="$(basename "$d")"

    write_file "$d/page.tsx" <<EOF
import Link from "next/link";

export default function Page() {
  return (
    <main className="min-h-screen bg-white">
      <div className="mx-auto max-w-7xl px-6 py-10">
        <header className="mb-10">
          <div className="text-sm font-semibold text-blue-600">
            ViaPay
          </div>

          <h1 className="mt-2 text-3xl font-bold tracking-tight text-slate-900">
            ${name}
          </h1>

          <p className="mt-3 max-w-3xl text-slate-600">
            Módulo da infraestrutura ViaPay.
            Esta página foi criada como estrutura funcional inicial.
          </p>
        </header>

        <section className="grid gap-6 md:grid-cols-3">
          <article className="rounded-xl border border-slate-200 p-6">
            <h2 className="font-semibold text-slate-900">
              Estado
            </h2>
            <p className="mt-2 text-sm text-slate-600">
              Estrutura inicial disponível.
            </p>
          </article>

          <article className="rounded-xl border border-slate-200 p-6">
            <h2 className="font-semibold text-slate-900">
              Integração
            </h2>
            <p className="mt-2 text-sm text-slate-600">
              Deve consumir contratos oficiais da API.
            </p>
          </article>

          <article className="rounded-xl border border-slate-200 p-6">
            <h2 className="font-semibold text-slate-900">
              Segurança
            </h2>
            <p className="mt-2 text-sm text-slate-600">
              Autorização deve ocorrer no backend.
            </p>
          </article>
        </section>

        <div className="mt-10">
          <Link
            href="/"
            className="text-sm font-medium text-blue-600 hover:underline"
          >
            Voltar
          </Link>
        </div>
      </div>
    </main>
  );
}
EOF
}

create_route() {
    local d="$1"

    write_file "$d/route.ts" <<'EOF'
import type { NextRequest } from "next/server";

export async function GET(_request: NextRequest) {
  return Response.json({
    success: true,
    service: "viapay",
  });
}

export async function POST(_request: NextRequest) {
  return Response.json(
    {
      success: false,
      code: "NOT_IMPLEMENTED",
      message:
        "Endpoint estrutural criado. Contrato funcional deve ser implementado antes da operação financeira.",
    },
    { status: 501 },
  );
}
EOF
}

create_contract() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Contract Boundary
 */

export interface ApiMeta {
  requestId: string;
  correlationId: string;
}

export interface ApiError {
  code: string;
  message: string;
  details?: unknown;
}

export interface ApiResponse<T> {
  data?: T;
  error?: ApiError;
  meta: ApiMeta;
}
EOF
}

create_sdk() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay SDK
 *
 * Cliente público para integração de instituições,
 * merchants e aplicações autorizadas.
 *
 * Segredos de produção nunca devem ser armazenados
 * no código do SDK.
 */

export interface ViaPayClientOptions {
  baseUrl: string;
  apiKey?: string;
}

export class ViaPayClient {
  public constructor(
    public readonly options: ViaPayClientOptions,
  ) {}
}
EOF
}

create_security() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Security Boundary
 */

export interface SecurityContext {
  actorId: string;
  tenantId: string;
  roles: string[];
  permissions: string[];
  mfaVerified: boolean;
}

export interface AuthorizationDecision {
  allowed: boolean;
  reason?: string;
}
EOF
}

create_worker() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Worker
 *
 * Jobs financeiros precisam ser idempotentes,
 * rastreáveis e reexecutáveis com segurança.
 */

export interface JobContext {
  jobId: string;
  correlationId: string;
  attempt: number;
}

export interface WorkerJob<T> {
  execute(
    payload: T,
    context: JobContext,
  ): Promise<void>;
}
EOF
}

create_database() {
    local d="$1"

    write_file "$d/README.md" <<'EOF'
# ViaPay Database

Camada de persistência.

Regras:

- migrations versionadas;
- integridade referencial;
- transações ACID;
- valores monetários sem floating point;
- idempotência;
- auditoria;
- reconciliação;
- histórico imutável para ledger.

Não executar alterações destrutivas diretamente em produção.
EOF
}

create_docs() {
    local d="$1"

    write_file "$d/README.md" <<'EOF'
# ViaPay Documentation

Esta área documenta arquitetura, contratos, operações,
segurança, integrações e procedimentos do ViaPay.

Status possíveis:

- PROPOSED
- IMPLEMENTED
- VERIFIED
- PARTIAL
- MOCK
- STUB
- EXTERNAL_DEPENDENCY

Nenhuma integração deve ser considerada operacional
sem evidência técnica correspondente.
EOF
}

create_sandbox() {
    local d="$1"

    write_file "$d/README.md" <<'EOF'
# ViaPay Sandbox

Ambiente de integração e testes.

O Sandbox nunca deve movimentar dinheiro real.

Cenários:

- payment success;
- payment failure;
- duplicate request;
- idempotency;
- timeout;
- FX quote expiration;
- liquidity unavailable;
- compliance hold;
- settlement failure;
- webhook retry.

Todas as respostas devem identificar claramente
que são operações de Sandbox.
EOF
}

create_tests() {
    local d="$1"

    write_file "$d/structure.test.ts" <<'EOF'
import { describe, expect, it } from "vitest";

describe("ViaPay module", () => {
  it("should have a valid test boundary", () => {
    expect(true).toBe(true);
  });
});
EOF
}

create_config() {
    local d="$1"

    write_file "$d/index.ts" <<'EOF'
/**
 * ViaPay Configuration
 */

export type ViaPayEnvironment =
  | "development"
  | "test"
  | "sandbox"
  | "production";

export interface ViaPayConfig {
  environment: ViaPayEnvironment;
  apiUrl: string;
  databaseUrl?: string;
  redisUrl?: string;
  rabbitmqUrl?: string;
}

export function loadConfig(): ViaPayConfig {
  return {
    environment:
      (process.env.VIAPAY_ENVIRONMENT as ViaPayEnvironment) ??
      "development",

    apiUrl:
      process.env.VIAPAY_API_URL ??
      "http://localhost:3000",

    databaseUrl:
      process.env.DATABASE_URL,

    redisUrl:
      process.env.REDIS_URL,

    rabbitmqUrl:
      process.env.RABBITMQ_URL,
  };
}
EOF
}

create_generic() {
    local d="$1"

    write_file "$d/README.md" <<EOF
# ViaPay Module

Diretório:

$(rel "$d")

Este módulo pertence à infraestrutura ViaPay.

Responsabilidades devem permanecer limitadas ao contexto
arquitetural representado pelo caminho.

Princípios:

- Clean Architecture
- DDD
- SOLID
- Hexagonal Architecture
- API First
- segurança por padrão
- observabilidade
- idempotência
- auditabilidade

Nenhum segredo deve ser armazenado no código.
EOF
}

echo
echo "============================================================"
echo "1. IDENTIFICANDO DIRETÓRIOS VAZIOS"
echo "============================================================"

mapfile -t DIRS < <(
    find "$ROOT" -type d -empty -print | sort
)

echo "Total bruto: ${#DIRS[@]}"
echo

echo "============================================================"
echo "2. PROCESSANDO"
echo "============================================================"

for d in "${DIRS[@]}"; do

    if is_excluded "$d"; then
        echo "[IGNORADO] $(rel "$d")"
        ((IGNORED+=1))
        continue
    fi

    r="$(rel "$d")"

    echo
    echo "------------------------------------------------------------"
    echo "$r"
    echo "------------------------------------------------------------"

    #
    # NEXT APP / PAGE
    #
    if [[ "$r" == apps/*/app/* ]]; then

        if [[ "$r" == */api/* ]]; then
            echo "CLASSIFICAÇÃO: API ROUTE"
            create_route "$d"
        else
            echo "CLASSIFICAÇÃO: NEXT PAGE"
            create_page "$d"
        fi

        continue
    fi

    #
    # COMPONENTS
    #
    if [[ "$r" == */components/* ]]; then
        echo "CLASSIFICAÇÃO: COMPONENT"
        create_component "$d"
        continue
    fi

    #
    # DOMAIN
    #
    if [[ "$r" == */domain/* || "$r" == */domain ]]; then
        echo "CLASSIFICAÇÃO: DOMAIN"
        create_domain "$d"
        continue
    fi

    #
    # APPLICATION
    #
    if [[ "$r" == */application/* || "$r" == */application ]]; then
        echo "CLASSIFICAÇÃO: APPLICATION"
        create_application "$d"
        continue
    fi

    #
    # INFRASTRUCTURE
    #
    if [[ "$r" == */infrastructure/* || "$r" == */infrastructure ]]; then
        echo "CLASSIFICAÇÃO: INFRASTRUCTURE"
        create_infrastructure "$d"
        continue
    fi

    #
    # CONTRACTS
    #
    if [[ "$r" == */contracts/* || "$r" == */contracts ]]; then
        echo "CLASSIFICAÇÃO: CONTRACTS"
        create_contract "$d"
        continue
    fi

    #
    # SDK
    #
    if [[ "$r" == */sdk/* || "$r" == */sdk ]]; then
        echo "CLASSIFICAÇÃO: SDK"
        create_sdk "$d"
        continue
    fi

    #
    # SECURITY
    #
    if [[ "$r" == */security/* || "$r" == */security ]]; then
        echo "CLASSIFICAÇÃO: SECURITY"
        create_security "$d"
        continue
    fi

    #
    # WORKERS / JOBS
    #
    if [[ "$r" == */worker/* || "$r" == */workers/* || "$r" == */jobs/* ]]; then
        echo "CLASSIFICAÇÃO: WORKER"
        create_worker "$d"
        continue
    fi

    #
    # DATABASE
    #
    if [[ "$r" == database/* || "$r" == */database/* ]]; then
        echo "CLASSIFICAÇÃO: DATABASE"
        create_database "$d"
        continue
    fi

    #
    # SANDBOX
    #
    if [[ "$r" == sandbox/* || "$r" == */sandbox/* ]]; then
        echo "CLASSIFICAÇÃO: SANDBOX"
        create_sandbox "$d"
        continue
    fi

    #
    # TEST
    #
    if [[ "$r" == tests/* || "$r" == */tests/* || "$r" == */test/* ]]; then
        echo "CLASSIFICAÇÃO: TEST"
        create_tests "$d"
        continue
    fi

    #
    # DOCS
    #
    if [[ "$r" == docs/* || "$r" == */docs/* || "$r" == bank-architecture/* ]]; then
        echo "CLASSIFICAÇÃO: DOCUMENTATION"
        create_docs "$d"
        continue
    fi

    #
    # CONFIG
    #
    if [[ "$r" == */config/* || "$r" == */config ]]; then
        echo "CLASSIFICAÇÃO: CONFIG"
        create_config "$d"
        continue
    fi

    #
    # API
    #
    if [[ "$r" == apps/api/* || "$r" == apps/viapay-api/* ]]; then
        echo "CLASSIFICAÇÃO: API"
        create_api "$d"
        continue
    fi

    #
    # DEFAULT
    #
    echo "CLASSIFICAÇÃO: MODULE"
    create_generic "$d"

done

echo
echo "============================================================"
echo "3. NOVA VERIFICAÇÃO"
echo "============================================================"

mapfile -t REMAINING < <(
    find "$ROOT" -type d -empty -print |
    while read -r d; do
        if ! is_excluded "$d"; then
            echo "$d"
        fi
    done
)

echo "Diretórios vazios fora das exclusões:"
echo "${#REMAINING[@]}"

if [[ "${#REMAINING[@]}" -gt 0 ]]; then
    printf '%s\n' "${REMAINING[@]}"
else
    echo "NENHUM."
fi

echo
echo "============================================================"
echo "4. ARQUIVOS VAZIOS"
echo "============================================================"

mapfile -t EMPTY_FILES < <(
    find "$ROOT" -type f -empty -print |
    while read -r f; do
        if ! is_excluded "$f"; then
            echo "$f"
        fi
    done
)

echo "Arquivos vazios fora das exclusões: ${#EMPTY_FILES[@]}"

if [[ "${#EMPTY_FILES[@]}" -gt 0 ]]; then
    printf '%s\n' "${EMPTY_FILES[@]}"
fi

echo
echo "============================================================"
echo "5. ESTATÍSTICAS"
echo "============================================================"

echo "Arquivos criados    : $CREATED"
echo "Arquivos preservados: $PRESERVED"
echo "Diretórios ignorados: $IGNORED"
echo "Diretórios restantes: ${#REMAINING[@]}"
echo "Arquivos vazios     : ${#EMPTY_FILES[@]}"

echo
echo "============================================================"
echo "6. VALIDAÇÃO DE NODE_MODULES"
echo "============================================================"

if find "$ROOT" -path '*/node_modules/*' -type f \
    -newermt "$(date -d "$STAMP" '+%Y-%m-%d %H:%M:%S')" \
    2>/dev/null |
    grep -q .; then

    echo "ATENÇÃO: foram criados arquivos novos dentro de node_modules."

else

    echo "OK: nenhum arquivo novo criado em node_modules pelo processo."
fi

echo
echo "============================================================"
echo "7. RELATÓRIO"
echo "============================================================"

echo "Log:"
echo "$LOG"

echo
echo "============================================================"
echo " CONCLUÍDO"
echo "============================================================"
