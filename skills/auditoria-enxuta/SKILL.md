---
name: auditoria-enxuta
description: Portão de fim de marco. Auditoria do repositório inteiro: código morto, exports sem uso, duplicados, laboratórios esquecidos, seeds por fase, arquivos gigantes. Até 20 achados; só diagnóstico.
---

# Auditoria enxuta

Auditoria periódica do repositório inteiro, feita como por quem acabou de herdar o código: o que pode sair, juntar ou encolher, e o que vai doer se ficar. Só diagnóstico: nada é alterado.

## Quando é obrigatória

No fim de cada marco, pelo orquestrador, num subagente que devolve só texto. Complementa a `licao-vira-maquina` (erros repetidos); não substitui a revisão de bugs nem a de segurança.

## 1. Mapear

- README, config de build e deploy, dependências, pontos de entrada (rotas, actions, jobs, scripts do manifesto) e testes.
- `.workflow/config.md`: os não-alvos (nada listado ali é achado) e a carga esperada.
- Repositório grande: vá fundo onde o erro custa mais e diga o que não leu.

## 2. Procurar

1. **Código morto e exports sem uso**: função, componente, tipo, rota.
2. **Helpers duplicados**: dois fazendo a mesma coisa (fique com um e cite o caminho).
3. **Compatibilidade sem dados**: ramo, coluna, flag ou adaptador mantido para um estado que não existe mais nos dados nem no uso.
4. **Laboratórios, protótipos e rotas de demonstração** esquecidos depois da fase que os criou.
5. **Seeds e scripts por fase** que ninguém mais roda.
6. **Arquivos gigantes** (acima de 1.000 linhas; isentos gerados e fixtures) e função que faz vários trabalhos. Divida por trabalho, nunca por contagem de linhas.
7. **Peso sem retorno**: dependência que faz o que a plataforma ou poucas linhas fazem; abstração com uma implementação; wrapper que só repassa; quase-cópias que mudam juntas.

Bug ou risco de segurança encontrado no caminho entra também, no topo, com o caso concreto.

## 3. Conferir antes de reportar

- Antes de chamar algo de sem uso, busque na árvore inteira, incluindo testes, fixtures, config, strings e referências dinâmicas (rota por nome de arquivo, nome montado em tempo de execução). Escreva o comando, ex.: `rg -n "<nome>"`.
- "Sem dados" se prova com consulta ao banco local, ao seed ou ao schema; se não der para provar, diga.
- Todo achado tem caso concreto. Sem caso, sem achado.
- Proposta: a menor mudança que funciona, de preferência apagando.

## 4. Saída

Comece com `O que este repositório faz:` em duas ou três frases e a carga assumida.

Depois, até 20 achados numerados e ranqueados (maior custo primeiro), em grupos **Corrigir**, **Deveria** e **Bom ter** (pule grupo vazio). Cada achado:

```
N. <título> — `arquivo:linhas`
- O que é: <uma frase>
- Caso concreto: <comando de busca e resultado, contagem, último uso>
- Proposta: <a menor mudança; quantas linhas saem>
- Se ignorarmos: <o custo real>
```

Feche com:
- `Veredito:` uma linha;
- `Enxuto: -N linhas, -M dependências possíveis.`;
- `Não lido:` o que não leu ou não conseguiu rodar;
- quantos achados menores ficaram de fora, se houver.

## Não faça

- Não apague, mova nem edite nada. Cada remoção aprovada vira uma trilha P própria.
- Não reporte item listado nos não-alvos do projeto.
- Não proponha apagar comentário com ID de decisão.
- Não conte arquivo gerado, migration aplicada ou dado oficial versionado como gigante ou morto.
- Sem gosto, estilo, "considere" ou preocupação vaga.
