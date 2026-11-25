#!/bin/bash
# Método v3 — hook PreToolUse (matcher "Edit|Write|MultiEdit"). EXEMPLO: não instalado.
#
# Formato conferido em 2026-11-05 em https://code.claude.com/docs/en/hooks :
#   - entrada: JSON no stdin com "tool_name", "cwd" e "tool_input.file_path";
#   - negar: {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny",
#            "permissionDecisionReason":"..."}} no stdout e saída 0;
#   - saída 0 sem imprimir nada = sem decisão.
#
# Nega editar ou sobrescrever uma migration que JÁ ESTÁ no branch base (já foi aplicada em algum
# ambiente). Criar migration nova é livre, e a migration criada na própria frente (ainda fora da
# base) pode ser editada até o merge.
#
# Configuração por variável de ambiente (bloco "env" do settings):
#   METODO_MIGRATIONS_DIRS  pastas relativas à raiz do repositório, separadas por ":"
#                           (padrão: supabase/migrations:migrations:db/migrate:prisma/migrations:drizzle)
#   METODO_BRANCH_BASE      branch base (padrão: main)
#
# Falha fechada: arquivo existente numa pasta de migration, quando não dá para consultar o git, é negado.
# Teste: ./testar-hooks.sh

set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "barrar-migration-existente: jq não encontrado; edição não avaliada" >&2
  exit 1
fi

entrada=$(cat)
arquivo=$(printf '%s' "$entrada" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
cwd=$(printf '%s' "$entrada" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$arquivo" ] && exit 0

negar() {
  jq -n --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# Caminho absoluto
case "$arquivo" in
  /*) ;;
  *) arquivo="${cwd:-$PWD}/$arquivo" ;;
esac

# Arquivo que ainda não existe = migration nova: livre.
[ -f "$arquivo" ] || exit 0

pasta_fisica=$(cd "$(dirname "$arquivo")" 2>/dev/null && pwd -P) || exit 0
caminho="$pasta_fisica/$(basename "$arquivo")"

raiz=$(git -C "$pasta_fisica" rev-parse --show-toplevel 2>/dev/null || true)
dirs="${METODO_MIGRATIONS_DIRS:-supabase/migrations:migrations:db/migrate:prisma/migrations:drizzle}"
base="${METODO_BRANCH_BASE:-main}"

e_migration() {
  # $1 = caminho relativo à raiz (ou absoluto, sem git)
  local rel="$1" d
  local IFS=':'
  for d in $dirs; do
    d="${d%/}"
    case "$rel" in
      "$d"/*|*/"$d"/*) return 0 ;;
    esac
  done
  return 1
}

if [ -z "$raiz" ]; then
  # Sem git: não dá para saber se já foi aplicada. Falha fechada.
  if e_migration "$caminho"; then
    negar "Bloqueado pelo método: esta migration já existe e não há git para conferir se já foi aplicada. Crie uma migration nova em vez de editar a antiga."
  fi
  exit 0
fi

rel="${caminho#"$raiz"/}"
e_migration "$rel" || exit 0

if git -C "$raiz" rev-parse --verify --quiet "$base^{commit}" >/dev/null; then
  if git -C "$raiz" cat-file -e "$base:$rel" 2>/dev/null; then
    negar "Bloqueado pelo método: $rel já está no branch $base (migration aplicada nunca é editada). Crie uma migration nova que corrija ou complete esta."
  fi
  exit 0  # existe só nesta frente: pode editar até o merge
fi

# Branch base não encontrado: falha fechada para arquivo já versionado.
if git -C "$raiz" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
  negar "Bloqueado pelo método: $rel já está versionado e o branch base '$base' não foi encontrado para conferir. Crie uma migration nova ou ajuste METODO_BRANCH_BASE."
fi
exit 0
