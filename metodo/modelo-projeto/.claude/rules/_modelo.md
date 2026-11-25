---
# Regra de área: carrega sozinha quando a sessão lê ou edita um arquivo que casa com `paths`.
# Formato: https://code.claude.com/docs/en/memory (seção "Path-specific rules").
# Sem `paths`, a regra carrega em toda sessão — evite. Copie para .claude/rules/<area>.md.
paths:
  - "<pasta>/**"
  - "<outra pasta>/**/*.<ext>"
---

# <Área> — regras

<!--
Só o que não deu para virar máquina (hook, lint, tipo, teste). Cada linha curta e verificável.
Quando uma regra vira máquina, ela sai daqui e entra em "Regras que a máquina garante" do CLAUDE.md.
Exemplo ilustrativo, não obrigatório: "Toda tabela nova tem política de acesso e teste de isolamento."
-->

- <regra> (porquê: `docs/decisoes/NNNN-…`)
