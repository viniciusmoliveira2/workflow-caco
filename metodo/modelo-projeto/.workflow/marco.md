# Marco — <nome> (plano de <AAAA-MM-DD> · revisto em <AAAA-MM-DD>)

<!-- Escrito pelo PO em modo gestão (skill `po-gestao`). ≤ 40 linhas, SOBRESCRITO. Aponta para estado, ADR e entrega; não copia. -->

## Critério de saída
- <fato observável que encerra o marco>

## Caminho crítico
<!-- Em ordem. Só o que bloqueia o critério de saída. -->
| # | Item | Quem destrava | Desde | Vence |
|---|---|---|---|---|
| 1 | <…> | dono · agente · externo (<quem>) | <AAAA-MM-DD> | <AAAA-MM-DD ou —> |

## Fila do dono
<!-- Por prioridade: primeiro o que destrava mais coisa. -->
| # | O que decidir ou fazer | Destrava | Pedido em | Onde olhar |
|---|---|---|---|---|
| 1 | <…> | <item # do caminho crítico> | <AAAA-MM-DD> | <URL ou caminho> |

## Riscos vivos
<!-- Até 5. -->
| Risco | Gatilho | Se disparar | Rever em | ADR |
|---|---|---|---|---|
| <…> | <fato observável> | <ação> | <AAAA-MM-DD> | <NNNN> |

## Números
- contexto inicial: frente <N mil> (meta < 40 mil além da base) · orquestrador <N mil> (meta < 10 mil)
- commits só de processo: <N %> (meta < 20 %) · entregas dentro do orçamento: <N %> (meta ≥ 80 %)
- estimado × realizado do marco: <linhas previstas> → <linhas reais> · uso: <N % da semana | não medido>
