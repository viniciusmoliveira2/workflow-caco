# Spec da frente — <nome>

<!-- 1 página. Trilha P: só Trilha, Problema e Critérios (3 linhas bastam). Some no merge; o que vale sobe para docs/specs/<dom>.md. -->

- **Trilha:** P | M | G — <motivo em uma linha>
- **Domínio:** `docs/specs/<dom>.md`
- **Evidência (G):** <fonte> · ou · aposta aprovada em <data>, orçamento <N> linhas

## Problema
<o que muda para quem, e por quê>

## Critérios
| ID | Critério | Novo · alterado · retirado |
|---|---|---|
| C-<dom>-NN | <dado X, quando Y, então Z> | novo |

## Fora desta frente
- <…>

## Gatilhos de portão
- [ ] cria arquivo (precisa-existir) · [ ] escreve teste (testar-comportamento) · [ ] lógica de banco/schema/regra (TDD)
- [ ] diff > 400 linhas, arquivo > 1.000, módulo compartilhado ou IA (revisao-estrutural)
- [ ] banco, políticas de acesso, funções, IA, chave de serviço, e-mail, auth (segurança + raio-de-impacto)
- [ ] tela tocada (teste de layout; ✋ 2 se tela nova)

## Tela
<!-- Preenchida pelo UI/UX depois do ✋ 2, só se houver tela. -->
