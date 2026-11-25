#!/bin/bash
# Método v3 — hook PreToolUse (matcher "Bash"). EXEMPLO: não instalado; a instalação é por projeto, com teste.
#
# Formato conferido em 2026-11-05 em https://code.claude.com/docs/en/hooks :
#   - entrada: JSON no stdin, com "tool_name" e "tool_input.command";
#   - negar: imprimir {"hookSpecificOutput":{"hookEventName":"PreToolUse",
#            "permissionDecision":"deny","permissionDecisionReason":"..."}} e sair com 0;
#   - sair com 0 sem imprimir nada = sem decisão (segue o fluxo normal de permissão).
#
# Nega comandos que já causaram incidente:
#   1. matar processo pela porta (lsof … | xargs kill, kill $(lsof …), fuser -k, kill-port);
#   2. pkill/killall genérico em servidor de dev (next, node, vite…), que derruba outras frentes;
#   3. npx/bunx/pnpm dlx supabase (CLI baixada na hora, em conflito com a instalada);
#   4. Chrome por CDP (--remote-debugging-*, chrome-remote-interface, porta 9222).
#
# Teste: ./testar-hooks.sh   (ou: echo '{"tool_input":{"command":"npx supabase start"}}' | ./barrar-comandos.sh)

set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "barrar-comandos: jq não encontrado; comando não avaliado" >&2
  exit 1  # erro não bloqueante: avisa sem travar a sessão
fi

entrada=$(cat)
cmd=$(printf '%s' "$entrada" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$cmd" ] && exit 0

negar() {
  jq -n --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# casa uma expressão regular estendida (POSIX, compatível com o grep do macOS)
casa() { printf '%s' "$cmd" | grep -Eq -- "$1"; }

# Limite de palavra portátil (o grep do macOS não garante \b).
I='(^|[^[:alnum:]_.-])'
F='([^[:alnum:]_-]|$)'

# Exceções: git não executa estes comandos, e mensagens de commit costumam citá-los.
# grep/rg simples (sem encadeamento) só procuram texto.
primeira=$(printf '%s' "$cmd" | awk '{print $1; exit}')
[ "$primeira" = "git" ] && exit 0
if [ "$primeira" = "grep" ] || [ "$primeira" = "rg" ]; then
  casa '[|;&`]|\$\(' || exit 0
fi

# 1. Matar pela porta
if casa "${I}lsof${F}" && casa "${I}kill${F}"; then
  negar "Bloqueado pelo método: não mate processo pela porta (lsof + kill). A porta pode ser de outro serviço ou de outra frente. Use o comando dev_parar do .workflow/config.md, que mata só o PID gravado pela sua frente."
fi
if casa "${I}fuser[[:space:]](.*[[:space:]])?-[[:alnum:]]*k" || casa "${I}kill-?port${F}"; then
  negar "Bloqueado pelo método: não mate processo pela porta (fuser -k / kill-port). Use o comando dev_parar do .workflow/config.md."
fi

# 2. pkill/killall genérico em servidor de dev
if casa "${I}(pkill|killall)${F}" && casa "${I}(next|next-server|node|npm|npx|vite|tsx|bun|deno|turbo|webpack|nodemon)${F}"; then
  negar "Bloqueado pelo método: pkill/killall por nome derruba o servidor de outras frentes. Use dev_parar (PID gravado) ou kill <PID> de um processo que você mesmo iniciou."
fi

# 3. Supabase baixado na hora
if casa "${I}(npx|bunx|pnpx|(pnpm|yarn)[[:space:]]+dlx|npm[[:space:]]+exec)([[:space:]]+-[^[:space:]]+)*[[:space:]]+supabase([[:space:]@]|$)"; then
  negar "Bloqueado pelo método: não use npx/dlx supabase (baixa outra versão da CLI, que conflita com os containers). Use o binário instalado: supabase <comando>, ou os scripts db:* do projeto."
fi

# 4. Chrome por CDP
if casa "remote-debugging-(port|pipe|address)" || casa "chrome-remote-interface" || casa "(localhost|127\.0\.0\.1):9222([^0-9]|$)"; then
  negar "Bloqueado pelo método: não abra nem controle o Chrome por CDP. Use o navegador da app (ferramentas de browser) ou o teste de layout/verificação do projeto."
fi

exit 0
