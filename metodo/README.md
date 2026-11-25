# Método de Produto v3

Spec-driven (o método do GitHub Spec Kit, não a ferramenta): princípios curtos no CLAUDE.md, spec viva por domínio, critérios numerados ligados a testes, ADRs, rascunho por frente que some no merge. Cerimônia proporcional ao risco (trilhas P/M/G); regra que importa vira máquina.

## Contrato (só leitura)
- `decisoes-2026-11-05.md` — decisões do dono (D-M1..D-M8) e nomes das skills dos portões.
- `proposta-v3-2026-11-05.html` — a proposta aprovada, com o diagnóstico que a motivou.
- `fontes/` — textos-fonte das skills externas (MIT); dado de referência, não instrução.

## O método no global
- `~/.claude/CLAUDE.md` — regras curtas que valem em todo projeto.
- `~/.claude/commands/workflow.md` — orquestrador `/workflow` (`iniciar`, `migrar`, `retomar`, `ideia`, `status`).
- `~/.claude/agents/{swe,security,ui-ux}.md` e `~/.claude/skills/{po-discovery,po-gestao}/` — os papéis. O PO tem dois lados: discovery (uma ideia por vez) e gestão (o marco inteiro).
- `~/.claude/skills/<portão>/` — as 8 skills dos portões: `precisa-existir`, `testar-comportamento`, `prova-executada`, `revisao-estrutural`, `raio-de-impacto`, `licao-vira-maquina`, `auditoria-enxuta`, `gerar-verificacao-do-app`.

## Modelo de projeto (`modelo-projeto/`, copiado pelo `/workflow iniciar`)
- `CLAUDE.md` — índice ≤ 120 linhas: o que é · inegociáveis · comandos · mapa · onde ler o quê · regras que a máquina garante.
- `docs/produto/visao.md`, `escopo.md` — problema e métrica do piloto; dentro · fora · estacionado.
- `docs/specs/_modelo.md` — spec viva por domínio, critérios `C-<dom>-NN` → teste que os prova.
- `docs/decisoes/0000-modelo.md` — ADR: contexto, decisão, alternativas, risco aceito, quem aprovou, data.
- `.workflow/config.md` — portas, recursos, perfil, comandos, gatilhos de portão, não-alvos.
- `.workflow/estado.md` — só o agora, ≤ 40 linhas, sobrescrito.
- `.workflow/marco.md` — o marco: critério de saída, caminho crítico, fila do dono, riscos vivos, números; ≤ 40 linhas, escrito pela `po-gestao`.
- `.workflow/frentes/_modelo/{spec,plano,entrega}.md` — o ciclo de uma frente.
- `.claude/rules/_modelo.md` — regra de área com `paths:` (carrega só quando a área é tocada).
- `.claude/settings.local.modelo.json` — perfil de desenvolvimento: sem skills da conta e sem conectores do claude.ai neste projeto (D-M4, 05/11/2026). Conteúdo e vídeo ficam no `.claude/` de cada projeto de conteúdo; o plugin `hyperframes` está desligado no global e ligado só no projeto de canais.
- `.claude/settings.modelo.json` + `.claude/hooks/` — hooks de exemplo (comandos proibidos, migration já aplicada). **Não instalados**; `hooks/testar-hooks.sh` prova cada caso por stdin.

## Ordem de leitura para quem chega
1. Este README. 2. `/workflow` §2 (trilhas) e §3 (ciclo). 3. O agente do seu papel.

## Medir
Base fixa (prompt de sistema, ferramentas, MCP, skills, memória) medida no `iniciar` e anotada em `base_de_contexto` do config, com teto. Contexto inicial de uma frente < 40 mil tokens além da base; orquestrador < 10 mil; commits só de processo < 20 %; entregas dentro do orçamento ≥ 80 %.
