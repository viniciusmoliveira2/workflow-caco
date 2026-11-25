#!/bin/bash
# Método v3 — testes dos hooks de exemplo. Roda sem instalar nada: alimenta cada hook com JSON
# pelo stdin e confere se a decisão foi "deny" ou nenhuma. Repositório git temporário para as
# migrations, apagado no fim.
# Uso: ./testar-hooks.sh   (sai com 1 se algum caso falhar)

set -u
aqui=$(cd "$(dirname "$0")" && pwd)
cmdhook="$aqui/barrar-comandos.sh"
mighook="$aqui/barrar-migration-existente.sh"
falhas=0
total=0

decisao() { jq -r '.hookSpecificOutput.permissionDecision // "nenhuma"' 2>/dev/null || echo "nenhuma"; }

caso_bash() {  # $1 = esperado (deny|nenhuma)  $2 = comando
  total=$((total + 1))
  local obtido
  obtido=$(jq -n --arg c "$2" '{hook_event_name:"PreToolUse",tool_name:"Bash",tool_input:{command:$c}}' | "$cmdhook" | decisao)
  [ -z "$obtido" ] && obtido="nenhuma"
  if [ "$obtido" = "$1" ]; then echo "ok    [$1] $2"; else echo "FALHA [esperado $1, obtido $obtido] $2"; falhas=$((falhas + 1)); fi
}

echo "== barrar-comandos.sh"
caso_bash deny    'lsof -ti:3000 | xargs kill -9'
caso_bash deny    'kill -9 $(lsof -t -i :3101)'
caso_bash deny    'lsof -ti tcp:3000 -sTCP:LISTEN | xargs -r kill'
caso_bash deny    'fuser -k 3000/tcp'
caso_bash deny    'npx kill-port 3000'
caso_bash deny    'pkill -f next'
caso_bash deny    'pkill -f "next-server" ; pkill -f "next dev"'
caso_bash deny    'killall node'
caso_bash deny    'npx supabase start'
caso_bash deny    'npx -y supabase@latest db reset'
caso_bash deny    'pnpm dlx supabase status'
caso_bash deny    'bunx supabase migration new x'
caso_bash deny    'open -a "Google Chrome" --args --remote-debugging-port=9222'
caso_bash deny    'curl -s http://127.0.0.1:9222/json/version'
caso_bash deny    'node -e "require(\"chrome-remote-interface\")"'
caso_bash deny    'cd app && lsof -i :3000 && kill 123'
caso_bash nenhuma 'lsof -i :3000'
caso_bash nenhuma 'kill 48213'
caso_bash nenhuma 'npm run dev:parar'
caso_bash nenhuma 'supabase status'
caso_bash nenhuma 'npx vitest run'
caso_bash nenhuma 'pkill -f meu-script-unico.py'
caso_bash nenhuma 'git commit -m "docs: hook nega npx supabase e pkill -f next"'
caso_bash nenhuma 'grep -rn "npx supabase" docs/'
caso_bash deny    'grep -l next pids.txt | xargs pkill -f node'
caso_bash nenhuma 'echo ok'

echo "== barrar-migration-existente.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
repo="$tmp/repo"
mkdir -p "$repo/supabase/migrations" "$repo/lib"
(
  cd "$repo" || exit 1
  git init -q -b main
  git config user.email teste@exemplo.invalid
  git config user.name teste
  echo "create table a();" > supabase/migrations/0001_a.sql
  echo "export {}" > lib/x.ts
  git add -A && git commit -qm base
  git checkout -qb frente
  echo "create table b();" > supabase/migrations/0002_b.sql
  git add -A && git commit -qm frente
) || { echo "FALHA ao montar repositório de teste"; exit 1; }

caso_arq() {  # $1 esperado  $2 ferramenta  $3 caminho  [$4 cwd]
  total=$((total + 1))
  local obtido
  obtido=$(jq -n --arg t "$2" --arg f "$3" --arg c "${4:-$repo}" \
    '{hook_event_name:"PreToolUse",tool_name:$t,cwd:$c,tool_input:{file_path:$f}}' | "$mighook" | decisao)
  [ -z "$obtido" ] && obtido="nenhuma"
  if [ "$obtido" = "$1" ]; then echo "ok    [$1] $2 $3"; else echo "FALHA [esperado $1, obtido $obtido] $2 $3"; falhas=$((falhas + 1)); fi
}

caso_arq deny    Edit  "$repo/supabase/migrations/0001_a.sql"
caso_arq deny    Write "$repo/supabase/migrations/0001_a.sql"
caso_arq deny    Edit  "supabase/migrations/0001_a.sql"
caso_arq nenhuma Edit  "$repo/supabase/migrations/0002_b.sql"
caso_arq nenhuma Write "$repo/supabase/migrations/0003_c.sql"
caso_arq nenhuma Edit  "$repo/lib/x.ts"
caso_arq nenhuma Write "$repo/pasta-nova/arquivo.sql"

semgit="$tmp/semgit/migrations"
mkdir -p "$semgit" && echo "x" > "$semgit/0001.sql"
caso_arq deny    Edit  "$semgit/0001.sql" "$tmp/semgit"

echo
echo "$((total - falhas))/$total casos ok"
[ "$falhas" -eq 0 ]
