# workflow-caco

Método de Produto v3 para construir produtos com o Claude Code: frentes em worktree, trilhas P/M/G, ciclo spec → plano → execução → verificação e portões de qualidade. O método em si está descrito em [`metodo/README.md`](metodo/README.md).

Este repositório é a pasta `~/.claude` com uma lista fechada no `.gitignore`: só os arquivos do método são versionados.

## O que tem aqui

- `commands/workflow.md` — o orquestrador `/workflow` (`iniciar`, `migrar`, `retomar`, `ideia`, `status`).
- `agents/{swe,security,ui-ux}.md` — os papéis.
- `skills/po-discovery/` e as 8 skills dos portões.
- `metodo/modelo-projeto/` — o esqueleto que o `/workflow iniciar` copia para um projeto novo.
- `metodo/fontes/` — textos-fonte das skills externas, cada um com a sua licença.
- `CLAUDE.md` — regras curtas que valem em todo projeto.

Os dois arquivos de contrato citados no `metodo/README.md` (`decisoes-…` e `proposta-…`) ficam fora do repositório.

## Instalar em outra máquina

Copie `commands/`, `agents/`, `skills/` e `metodo/` para dentro de `~/.claude/`, sem sobrescrever o que já existe, e junte o `CLAUDE.md` ao seu. Num projeto novo, rode `/workflow iniciar`.
