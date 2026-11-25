# Spec — <domínio>

<!--
Spec viva: descreve como o domínio funciona HOJE, não como chegou aqui (isso é git e ADR).
Atualizada no merge da frente que alterou o domínio. Copie para docs/specs/<dominio>.md.
Prefixo dos critérios: C-<dom>-NN, com <dom> curto e fixo (ex. ilustrativo: C-AGE-03).
Critério removido não reaproveita número: marque "retirado em <data> (ADR NNNN)".
-->

## Para que serve
<2–3 linhas>

## Regras
<!-- O comportamento que importa, em frases curtas. Cada regra testável vira critério abaixo. -->
- <regra>

## Critérios

| ID | Critério (comportamento observável) | Provado por |
|---|---|---|
| C-<dom>-01 | <dado X, quando Y, então Z> | `<arquivo de teste>` › `<nome do teste>` |
| C-<dom>-02 | <…> | <…> |

<!-- Critério sem teste fica com "sem prova — <motivo>" e vira dívida visível. -->

## Onde mora
- Código: `<pastas e arquivos principais>`
- Dados: `<tabelas, migrations>`
- Regras de área: `.claude/rules/<area>.md`

## Riscos aceitos e decisões
- <resumo em uma linha> → `docs/decisoes/NNNN-…`
