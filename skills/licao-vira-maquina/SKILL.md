---
name: licao-vira-maquina
description: Portão de fim de marco. Use para agrupar os erros que os agentes repetiram e propor torná-los impossíveis (arquitetura > tipo > lint > teste > hook > texto), tirando o texto que virou máquina.
---

# Lição vira máquina

Os agentes repetem os mesmos erros porque a regra mora só em texto, e nada falha quando ninguém a lê. Este portão acha os erros repetidos do marco e propõe torná-los impossíveis. Pressuposto: todo contribuidor é um agente que vê só os arquivos que abriu, copia o exemplo mais próximo e pega o caminho mais curto que compila.

## Quando é obrigatória

No fim de cada marco, pelo orquestrador ou por um subagente dele. Esforço: cerca de 30 minutos. A saída é limitada.

## 1. Juntar evidência do marco

- Commits de correção e reverts: `git log --oneline <início do marco>..HEAD` filtrado por `fix` e `revert`.
- Devoluções da Segurança e do QA nas pastas das frentes e no estado do projeto.
- Incidentes registrados (estado, passagens, memória do projeto).
- Regras "nunca" e "sempre" que existem só como texto: CLAUDE.md, briefs, config, memória.

Agrupe em classes. Uma classe conta quando aconteceu duas vezes ou mais, ou uma vez com incidente caro.

## 2. Camada mais alta que funciona

Para cada classe, tente nesta ordem e diga por que a camada acima não serviu:

1. **Arquitetura**: um dono por estado, um jeito suportado por tarefa; esconder o interno para o import errado falhar; fonte única no lugar de listas sincronizadas à mão; apagar o jeito antigo que um agente copiaria.
2. **Tipo**: o estado ruim não compila.
3. **Lint ou checagem estática**: a mensagem de erro diz o arquivo, tipo ou função a usar. Padrão já comum: falhar só quando a mudança acrescenta mais.
4. **Teste** de comportamento (ver `testar-comportamento`); conserte também o teste que passa com o comportamento quebrado.
5. **Hook** do Claude Code que nega o comando ou a edição: para erro operacional, como matar processo pela porta, comando proibido, edição de arquivo reservado ou de migration aplicada.
6. **Texto**, por último, só para o que exige julgamento.

## 3. Provar

Cada check proposto tem de falhar num erro passado real: reaplique o erro (o commit ruim ou um equivalente mínimo) numa cópia descartável e mostre a saída do check. Sem essa prova, a proposta fica marcada "não provada". Exceção ao check vai na própria linha, com motivo, validade e aprovação do dono.

## 4. O texto sai

Quando uma lição vira máquina, o texto correspondente sai do CLAUDE.md, dos briefs e da memória; fica no máximo uma linha na tabela "regra → o que a garante". Regra que já estava escrita e reincidiu sem nada que a garantisse é reincidência: suba de camada na mesma proposta.

## Saída

Uma tabela de até 10 linhas, ordenada por ocorrências:

| erro | ocorrências (evidência) | hoje barrado por | camada proposta | prova de que o check falha no erro passado |
|---|---|---|---|---|
| matar o servidor pela porta | 3 (commit `abc123`, incidente de 05/08, passagem da frente X) | texto em 4 lugares | hook que nega `lsof … \| kill` + script de parar por PID | hook rodado com o comando do incidente → negado |

Depois da tabela:
- para cada linha, o texto a remover quando ela for aprovada (arquivo e trecho);
- as classes descartadas, uma linha cada, com o motivo.

## Não faça

- Não implemente nada nesta etapa: a saída é proposta ao orquestrador e ao dono; o que for aprovado vira trilha própria.
- Não edite configuração global, hooks, CLAUDE.md nem memória aqui.
- Não proponha só texto quando uma camada acima resolve.
- Não passe de cerca de 30 minutos: classes menores ficam para o próximo marco, com a contagem.
- Não conte como classe um erro que só aconteceu uma vez sem custo.
