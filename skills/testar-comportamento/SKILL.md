---
name: testar-comportamento
description: Portão de testes. Use sempre que escrever, mudar ou manter um teste: ele deve falhar quando o comportamento quebra e passar quando só o interior muda. Proíbe teste que lê o código-fonte.
---

# Testar comportamento, não implementação

Teste é uma afirmação sobre o que o código faz para quem o usa: quem chama, o usuário final, outro serviço. **Comportamento** é o que esse usuário observa pela interface que usa: retorno, erro, estado que lê de volta, efeito fora do código (linha gravada, requisição enviada, e-mail, mensagem). **Implementação** é o que ele não vê: helper privado, ordem interna de chamadas, dado intermediário, classe CSS, qual módulo fez o trabalho.

## Quando é obrigatória

Sempre que alguém escreve, muda ou decide manter um teste: SWE, QA, Segurança (no teste de prova). Complementa o TDD do projeto, não o substitui: o teste RED tem de falhar pelo motivo de comportamento certo, e o GREEN não pode depender de detalhe interno.

## As duas edições imaginárias

Julgue cada teste contra duas edições:

- **Quebrar o comportamento**: o código devolve valor errado, pula o efeito ou o faz duas vezes. Se o teste ainda passa, não prova nada. Causas comuns: asserção mais frouxa que o contrato; valor esperado calculado pelo próprio código testado; constante ou texto repetido no teste sem rodar o código que o lê; asserção sobre dado que o próprio teste montou.
- **Mudar o interior**: mesmo resultado observável, estrutura diferente. Se o teste falha, está preso à implementação: precisa de reescrita a cada refatoração e não pega bug.

Fica o teste que pega a primeira e sobrevive à segunda. Reescreva ou apague o resto.

## Como escrever

- Dirija pela interface do usuário do código: função pública, rota, action, função do banco chamada com a sessão real do perfil, componente renderizado e consultado por papel e nome acessível.
- Entrada concreta. Valor esperado tirado do requisito ou do critério numerado da spec, nunca de uma execução do código.
- Afirme o que o contrato promete, nem menos nem mais.
- Banco: integração real quando o projeto manda (não mocke o banco). Mock só na fronteira de serviço externo; o payload que esse serviço recebe é comportamento.
- Contrato de ausência ("carrinho vazio nunca cobra", "um usuário não vê dado de outro") é comportamento. Sempre em par com o caso em que o efeito acontece, para mostrar que o teste enxerga.
- O tipo de erro em que o chamador ramifica é contrato. A mensagem exata que ninguém lê não é, salvo texto ao usuário fixado pela spec.
- Invariante (chave que existe em duas tabelas, checagem de tipo em compilação) também é comportamento.

## Proibido

- **Teste que lê o código-fonte**: `readFileSync`/`readFile` de arquivo do próprio código, grep de import, de classe CSS ou de nome de função, regex sobre `.ts`, `.tsx`, `.sql`. Se a regra vale, ela vira lint ou checagem estática (ver `licao-vira-maquina`), não teste.
- **Asserção negativa de algo removido** ("não renderiza mais X", "o botão Y sumiu") sem motivo de produto escrito na spec. Remoção se prova pelo comportamento novo; o negativo só fica quando a ausência é o requisito.
- Snapshot grande como única asserção.
- Espiar chamada a helper interno.

## Exceções

Só as listadas nos não-alvos de `.workflow/config.md`. Exemplos típicos: hash de texto regulatório ou de prompt travado por decisão; retrato de contrato byte a byte; checagem de que um arquivo gerado está em dia. Exceção que não está na lista é violação. Para criar uma, registre a decisão e peça ao orquestrador para incluí-la nos não-alvos.

## Saída

- Na entrega do SWE: uma linha dizendo que os testes novos passam nas duas edições, com um caso citado.
- Numa revisão de testes: uma linha por teste, `arquivo › nome · pega a quebra? sim/não · sobrevive à refatoração? sim/não · ação: fica / reescrever / apagar`.

## Não faça

- Não enfraqueça um teste para ele passar.
- Não troque integração real por mock para ganhar velocidade.
- Não apague teste de outra frente sem trilha aprovada: reporte.
- Não conte cobertura como prova; um bom teste vale mais que dez frouxos.
