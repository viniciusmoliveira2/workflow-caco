# Workflow — configuração de <projeto>

<!-- Lido pelo orquestrador no pré-voo e pelas frentes por trecho. Muda raramente. -->

## Projeto
- idioma: pt-BR
- perfil: desenvolvimento | conteúdo
- branch_base: main
- piloto: sim | não · estado: <não começou | rodando desde AAAA-MM-DD>  <!-- com piloto não rodando, escopo novo só como aposta -->
- painel_notion: nenhum | <id do banco>  <!-- opcional: só itens que esperam o dono -->

## Frentes
- paralelismo: 2
- portas_dev: [<3101>, <3102>, <3103>]  <!-- uma por frente, reservada no estado.md -->
- portas_de_terceiros: [<porta> (<serviço>)]  <!-- nunca matar processo por porta -->
- recursos_sequenciais: <migrations nomeadas por data | número reservado no estado.md | nenhum>
- banco_local_compartilhado: <sim | não> · <regra: ex. reset só sem frente aberta>
- orcamento: ritmo_semanal_por_dia <13 %> · <régua de conversão medida, se houver>
- base_de_contexto: <N mil tokens em AAAA-MM-DD> · teto: <N mil; padrão = medida + 10 %>  <!-- `get_usage` numa sessão nova: prompt de sistema + ferramentas + MCP + skills + memória; toda frente paga isso ao nascer -->

## Comandos
<!-- Os mesmos do CLAUDE.md. dev_frente grava o PID; dev_parar mata só esse PID. -->
- dev_frente: `<comando> --porta <p>`
- dev_parar: `<comando>`
- testes: `<comando>`
- tipos: `<comando>`
- lint: `<comando>`
- build: `<comando>`
- layout: `<comando do teste de layout por rota>`
- verificar: `<comando que roda tudo acima>`
- verificacao_do_app: `.claude/skills/verificar-app/` <!-- gerada por gerar-verificacao-do-app -->

## Gatilhos de portão (caminhos deste projeto)
- modulo_compartilhado: [<pastas usadas por vários domínios>]
- ia: [<pastas do pipeline de IA>]
- seguranca: [<banco, políticas de acesso, funções, chave de serviço, e-mail, auth>]
- regulacao_do_dominio: nenhuma | <norma — fonte primária>

## Capturas
- pasta: `.workflow/capturas/` (no `.gitignore`; nunca versionar) · larguras: 375, 1280

## Não-alvos
<!-- O que revisões, auditorias e limpezas NÃO mexem, com o motivo. -->
- `<caminho ou decisão>` — <motivo>

## Modelos por papel
<!-- Só o que difere da tabela do /workflow. -->
- nenhum

## Regras curtas (até 5; vão em todo brief)
- <regra que ainda não virou máquina>
