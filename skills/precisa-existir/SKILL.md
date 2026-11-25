---
name: precisa-existir
description: Portão do plano (trilhas M e G; P quando cria arquivo). Use antes de construir para decidir item a item se algo precisa existir, se já existe no código ou na plataforma e qual o mínimo.
---

# Precisa existir?

O melhor código é o que não precisa ser escrito. Este portão roda no plano, antes da primeira linha, e transforma cada item do plano numa decisão com evidência.

## Quando é obrigatória

- Plano das trilhas M e G: todo item.
- Trilha P: quando o plano cria arquivo novo (componente, módulo, script, migration, rota).
- Quem usa: o SWE ao escrever o plano. O conferente de plano recusa plano sem a seção `## Precisa existir?`.

## Antes da escada

Leia o pedido e o código que ele toca. Liste onde a mudança precisa chegar: chamadores, testes, fixtures, config, exports, spec. Isso é escopo; recurso extra não é. Leia os não-alvos em `.workflow/config.md`.

## A escada

Pare no primeiro degrau que resolve o item por inteiro.

1. **Precisa existir?** Recurso, opção ou flexibilidade que ninguém pediu fica fora; nomeie em uma linha. Pedido vago leva à menor versão que faz o essencial.
2. **Já existe neste código?** Procure antes de decidir: helper, componente, função do banco, hook, schema de validação, padrão vizinho. Ex.: `rg -n "<conceito>" lib components app`, `rg -l "export (function|const) <nome>"`. Use do jeito que o código vizinho usa. Componente da casa vence widget nativo.
3. **Plataforma ou biblioteca padrão** (framework, banco, navegador, linguagem)? Use, a menos que o projeto tenha o seu.
4. **Dependência já instalada?** Confira o manifesto e o lockfile. Nunca adicione dependência por poucas linhas; dependência nova é decisão registrada.
5. **O mínimo que funciona.** Sem abstração, wrapper, opção, config ou código "para depois" que ninguém pediu. Mantenha a estrutura que o código já tem: camadas, interfaces, convenções.

## Apagar antes de somar

- Antes de construir, veja o que sai no caminho da mudança: código morto, validador redundante, referência órfã, protótipo superado. A remoção vem primeiro na ordem do plano.
- Remoção fora do escopo da frente não entra: vira item de backlog.
- Decisão repetida em vários lugares vai para uma fonte única; o resto recebe o resultado.
- Desenhe para o uso observado, não para caso hipotético.

## Nunca corte

- Validação em fronteira de confiança (entrada do usuário, API, banco).
- Tratamento de erro que evita perda de dado.
- Segurança (permissão, isolamento por perfil, segredo) e acessibilidade (alvo de toque, foco, rótulo).
- O TDD do projeto e o teste da lógica nova não trivial.
- Qualquer coisa que o pedido ou a spec aprovada exige.

Seja preguiçoso na solução, nunca na mudança: o plano cobre todo chamador, teste e fixture que a mudança quebra.

## Saída

Seção `## Precisa existir?` no plano, um parágrafo por item:

> **Item 3 — busca de cliente no diálogo.** Decisão: reusar. Degrau 2: `components/busca/BuscaPessoa.tsx:12` já faz a busca com espera; o diálogo só passa `onSelect`. Nada novo além de uma prop. Fora: filtro por status (ninguém pediu).

Cada parágrafo traz:
- **decisão**: cortar · reusar · plataforma · dependência existente · construir o mínimo;
- **degrau** em que parou;
- **evidência**: caminho real `arquivo:linha` do que já existe, ou o comando de busca e o que ele devolveu (busca sem resultado também é evidência, desde que o comando esteja escrito);
- **fora**: o que ficou de fora e por quê, em uma linha.

Feche a seção com uma linha: o que a busca não cobriu.

## Não faça

- Não questione a spec aprovada além do degrau 1. Se achar que um item inteiro não deveria existir, registre como pergunta ao orquestrador; não corte por conta própria.
- Não crie helper novo quando o degrau 2 achou um quase igual: estenda o existente ou diga por que não serve.
- Não cite caminho que não abriu nem que a busca não devolveu.
- Não marque atalho com comentário especial no código; limite conhecido vai no plano ou numa decisão registrada.
- Não use este portão para tirar validação, segurança, acessibilidade ou teste.
