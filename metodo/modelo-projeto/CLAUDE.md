<!--
Modelo do Método v3. Preenchido, este arquivo cabe em ≤ 120 linhas: é índice, não diário.
Não entra aqui: histórico de fases, detalhe de domínio (vai para docs/specs/), o porquê
das regras (docs/decisoes/), estado (vai para .workflow/estado.md). Apague este comentário.
-->
# <Produto>

<3 linhas: o que é, para quem, qual dor resolve. Detalhe em docs/produto/visao.md.>

## Inegociáveis

<!-- 5 a 8 itens. Princípio muda só com ADR aprovado pelo dono. -->
1. <princípio em uma linha> (porquê: docs/decisoes/0001-…)
2. <…>

## Comandos

<!-- Preenchido pelo SWE em modo skeleton. Iguais aos do .workflow/config.md. -->
- dev da frente: `<comando>` (porta da frente; grava o PID) · parar: `<comando>`
- testes: `<comando>` · tipos: `<comando>` · lint: `<comando>` · build: `<comando>`
- verificação completa antes de entregar: `<comando>`

## Mapa

<!-- Uma linha por pasta que importa. -->
- `<pasta>/` <o que mora ali>
- `docs/specs/` como cada domínio funciona hoje · `docs/decisoes/` ADRs · `docs/produto/` visão e escopo

## Onde ler o quê

- Mexer em <domínio> → `docs/specs/<dominio>.md`
- Por que uma regra existe → `docs/decisoes/`
- Tela → `DESIGN.md` · Deploy e rotinas → `docs/operacao/`
- Estado do trabalho → `.workflow/estado.md` (só o orquestrador edita)

## Regras que a máquina garante

<!-- Toda regra "nunca" que já causou incidente vira hook, lint, tipo ou teste. Texto é o último recurso. -->
- <regra> → barrada por <hook `.claude/hooks/…` | lint `<regra>` | teste `<arquivo>`>

## Convenções

- Idioma: <pt-BR> em UI, docs e comentários; commits com prefixo convencional em inglês + descrição em <pt-BR>.
- <no máximo 5 linhas; o resto vai para .claude/rules/<area>.md com paths:>
