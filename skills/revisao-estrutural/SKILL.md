---
name: revisao-estrutural
description: Portão de entrega (diff acima de 400 linhas, arquivo cruzando 1.000, módulo compartilhado ou IA). Revisão de estrutura só do diff da frente, até 5 achados. Para subagente que devolve só texto.
---

# Revisão estrutural

Revisão de manutenibilidade só do diff da frente. Procura o movimento que deixa a mudança bem mais simples sem mudar comportamento. Poucos achados, de alta convicção. Não edita código.

## Quando é obrigatória

Na entrega, quando vale qualquer gatilho: diff acima de 400 linhas; arquivo cruzando 1.000 linhas; mudança em módulo compartilhado (usado por duas ou mais áreas); mudança em código de IA. Quem chama: orquestrador ou verificador, num subagente (Opus, esforço médio) que recebe só a branch base, o nome da frente e o caminho da config, lê o diff sozinho e devolve só texto.

## Preparar

1. `git diff --stat <base>...HEAD` e `git diff <base>...HEAD` (base da config, senão `main`).
2. Leia inteiro cada arquivo tocado e os chamadores das funções cuja assinatura ou retorno mudou.
3. Leia os não-alvos e invariantes em `.workflow/config.md`: textos travados por hash, contratos byte a byte, ordens que são segurança.
4. Tamanho antes e depois: `git show <base>:<arquivo> | wc -l` e `wc -l <arquivo>`.

## O que procurar, por prioridade

1. **Regressão estrutural**: o diff deixou o módulo mais acoplado, com mais estado ou mais difícil de ler.
2. **Simplificação perdida**: existe uma reformulação que faz sumir ramos, helpers, modos ou camadas inteiras, usando melhor a arquitetura que já existe. Mover complexidade de lugar não conta.
3. **Espaguete**: `if` avulso em fluxo não relacionado, caso especial espalhado, booleano de uso único, modo anulável, flag que complica o fluxo existente.
4. **Tipos e fronteiras**: `any`, `unknown`, cast, opcional desnecessário, objeto improvisado no lugar de tipo ou contrato compartilhado, fallback silencioso escondendo uma invariante.
5. **Tamanho**: arquivo que cruzou 1.000 linhas por causa do diff. Isentos: testes, seeds, gerados, fixtures e migrations.
6. **Camada canônica e reuso**: lógica de funcionalidade vazando para caminho compartilhado; helper sob medida quando já existe o canônico (cite o caminho); lógica fora da camada dona do conceito; wrapper que só repassa.
7. **Atomicidade**: escritas relacionadas que podem ficar pela metade (várias mutações sem transação ou função atômica); orquestração sequencial sem motivo.

## Limites

- **Só o diff.** Movimento que exige mexer fora dele vira item de backlog (classe dívida), nunca exigência da frente.
- **Até 5 achados.** Havendo mais, fique com os de maior convicção e diga quantos deixou de fora.
- **Não-alvos e invariantes valem**: não proponha mudar texto travado por hash nem retrato de contrato. Ordem que é segurança (verificar antes de gravar, filtro antes do modelo, conferir posse antes de usar a chave de serviço) não se paraleliza nem se reordena.
- Sem gosto pessoal, nome, estilo ou "considere". Achado sem caso concreto não entra.

## Formato por achado

```
N. <título curto> — `arquivo:linha`
- Problema: <o que está estruturalmente errado, com o caso concreto>
- Movimento: <a mudança proposta; prefira a que apaga>
- Risco de mudar comportamento: baixo | médio | alto — <por quê>
- Teste que prova que nada mudou: <teste existente ou o teste a escrever>
- Classe: bloqueante | recomendado | dívida
```

- **Bloqueante**: regressão estrutural clara; arquivo cruzando 1.000 sem motivo forte; espaguete em fluxo compartilhado; mutação não atômica com estado parcial possível; helper duplicado com canônico óbvio.
- **Recomendado**: melhora real dentro do diff, sem estado de risco.
- **Dívida**: fora do diff ou cara demais para a frente.

Feche com `Veredito: aprovar` ou `Veredito: corrigir N e M antes do merge`, e `Não lido:` com o que não abriu. Sem achados: `Sem achados estruturais.` e uma linha do que leu.

## Não faça

- Não edite, não reestruture e não abra outro subagente.
- Não apague nem proponha apagar comentário com ID de decisão (ex.: `A-…`, `D-…`, `S-…`, número de ADR).
- Não aprove só porque funciona; não reprove por cosmético.
- Não conte linhas de teste, seed ou gerado no limite de 1.000.
- Não procure bug funcional aqui; isso é da revisão de bugs.
