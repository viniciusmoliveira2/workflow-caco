---
name: raio-de-impacto
description: Portão da Segurança (banco, RLS, plpgsql, IA, service_role, e-mail, auth). Use para achar o que a mudança quebra fora do diff e provar, executando, o fato que a torna segura.
---

# Raio de impacto

Descobre o que a mudança quebra fora do diff, antes do merge, e prova com execução o fato que a torna segura. Listar chamadores não é o trabalho; o grep faz isso em segundos. O trabalho é a quebra que o grep não mostra. Texto convincente sem execução não vale nada.

## Quando é obrigatória

Na revisão de segurança, quando o diff toca: banco (migration, schema), RLS, função plpgsql ou gatilho, IA (prompt, modelo, verificação da resposta), chave de serviço (`service_role`/cliente admin), e-mail, autenticação ou sessão. Quem usa: o agente de Segurança.

## Regra central

**Achado só vale com comando + saída.** Risco sem execução vai para "não provado", nunca para a lista de achados.

## Escala de certeza

Para cada fato do qual a segurança depende, leve-o até o nível mais alto que for barato e diga onde parou:

1. Você afirmou. Sem valor sozinho.
2. Você apontou a linha: `arquivo:linha` real, ou o fonte da biblioteca na versão fixada.
3. Você mostrou, passo a passo, que o caso ruim não acontece.
4. Você rodou: script ou teste que chama o código real e falha alto se você estiver errado.
5. Você reproduziu no app rodando.

Achados e o fato de segurança precisam chegar ao nível 4 ou 5.

## Passos

1. **Leia a mudança**: diff, símbolos adicionados, alterados e removidos, o que passa a fazer de diferente, inclusive o que o diff não diz.
2. **Ache o fato único que a torna segura** (ex.: "essa função só é executável pela chave de serviço"; "a política filtra por `auth.uid()` em todo SELECT"). Se ele vale, a maioria dos riscos cai junto. Gaste o tempo aqui.
3. **Olhe onde o grep para**: políticas de outras tabelas que leem a coluna; gatilho que dispara na escrita; `SECURITY DEFINER` × `INVOKER` e os grants reais (`revoke` só de `public` pode não bloquear `anon`; confira); job ou cron que lê a mesma tabela; e-mail que interpola o dado; JSON que a rota devolve; cache; outro serviço lendo os mesmos bytes; ordem de deploy entre app e migration.
4. **Seja honesto com cada risco**: chance real, custo real, `arquivo:linha`. Separe confirmados de verificados e descartados. Busca sem resultado também é resposta, com o comando escrito. Nunca invente chamador nem API.
5. **Prove**: escreva e rode o script ou teste no banco local, com sessões reais dos perfis afetados e de `anon`. Cole o que aconteceu. Só dado de seed.

## Triagem

- **Auto-fix**: correção pequena, local, sem decisão de produto e com teste que prova. A Segurança aplica e fecha com `prova-executada`.
- **Devolver ao SWE**: correção que muda lógica, schema ou contrato. Vai com o comando que reproduz.
- **Escalar ao dono**: aceitar ou não um risco, decisão regulatória ou de produto, custo alto. Vai com chance, custo e opções.

## Saída

- **O que muda**: inclusive o que não é óbvio.
- **Fato de segurança**: enunciado · nível alcançado · comando · saída. Se não provou, escreva "não provado".
- **Achados**: título · `arquivo:linha` · como quebra · chance × custo · comando · saída · triagem.
- **Descartados**: o que verificou e por que está ok, com o comando quando rodou.
- **Antes do merge**: o teste ou repro mais barato que pega o bug real, com o script.

## Não faça

- Não entregue a análise sem ao menos um comando executado.
- Não rode nada contra produção nem com segredo real; nunca chame rota protegida com segredo válido num banco compartilhado.
- Não resete nem recrie banco compartilhado com outra frente aberta; use os scripts do projeto.
- Não edite migration já aplicada.
- Não grave saída com dado pessoal ou sensível fora do projeto.
