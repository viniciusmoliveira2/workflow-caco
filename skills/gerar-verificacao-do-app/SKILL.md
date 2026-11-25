---
name: gerar-verificacao-do-app
description: Uma vez por projeto (QA). Gera a skill local .claude/skills/verificar-app/ que sobe o app, entra com usuário de teste, percorre as rotas principais, captura 375/1280 e testa o layout.
---

# Gerar a verificação do app

Gera, uma vez por projeto, a skill local `.claude/skills/verificar-app/`, que sobe o app, entra com usuário de teste, percorre as rotas principais e captura evidência como um usuário faria. Ela é escrita para o próximo agente, que vai lê-la a frio, no meio de uma tarefa.

## Quando é obrigatória

Uma vez por projeto, pelo QA (ou pelo SWE no esqueleto), antes da primeira entrega com tela ou serviço. De novo só quando o jeito de subir, entrar ou navegar mudar. `prova-executada` e o teste de layout usam a skill gerada.

## 1. Perguntar ao repositório, não ao dono

Responda pelo código; pergunte só o que não dá para observar.

- **Superfície**: web, API ou CLI. Escolha a principal.
- **Subir**: o comando do próprio projeto (scripts do manifesto, README, `.claude/launch.json`); se houver script de subir e parar por frente, use-o. Porta da frente em `.workflow/config.md`. Variáveis, migrations, seed.
- **Entrar**: usuários de teste do seed ou das fixtures do projeto. A skill aponta o arquivo; nunca copia a senha.
- **Dirigir**: primeiro o que já existe (Playwright do projeto, testes de ponta a ponta, `curl` nas rotas); depois o navegador do app Claude, aberto pela configuração do `launch.json`.
- **Observar**: capturas, árvore de acessibilidade, resposta HTTP, log, linha no banco.
- **Isolar**: duas instâncias convivem (porta por worktree, banco compartilhado)? Se não, a skill manda não dirigir instância de outra frente.

Se o projeto não sobe como está, conserte ou relate com precisão antes de gerar.

## 2. Gerar `.claude/skills/verificar-app/SKILL.md`

Frontmatter `name: verificar-app` e `description` com o app, a superfície e quando usar. Seções, todas com comandos, rotas e seletores reais do projeto:

- **Subir**: comando exato e sinal de pronto. Pronto é usável (login responde e seed carregado), não só porta aberta. Grave o PID do que você subiu.
- **Doutor**: checagem só de leitura. O processo é seu (PID gravado)? Porta certa, build certo, sessão válida? Rode primeiro sempre que algo parecer errado.
- **Entrar**: login de cada perfil de teste, apontando o arquivo do seed.
- **Rotas principais**: 3 a 5 jornadas com seletor estável (papel e nome acessível, rota, `data-*`), a ação e o estado final observável que prova.
- **Capturas**: 375 e 1280 px quando houver tela; ficam na pasta da frente, fora do git; só dado de seed.
- **Teste de layout** por rota tocada: sem rolagem lateral a 375 (`document.documentElement.scrollWidth <= window.innerWidth`), alvos interativos de pelo menos 44 px, foco visível ao navegar com Tab. Prefira um script no Playwright do projeto, que vira teste.
- **Limpar**: parar só o PID que você iniciou; a evidência sobrevive à limpeza.
- **Pegadinhas**: o que já desperdiçou uma execução.

Opcional: `features/` com um arquivo por jornada (o que é, como chegar, como dirigir, pegadinhas).

## 3. Provar a skill antes de entregar

Rode a skill gerada uma vez de ponta a ponta: subir, doutor, entrar, uma jornada, captura, limpar. Depois confirme que a evidência ainda existe. Conserte o que falhar, limpando a cada tentativa. Skill nunca executada é rascunho. Feche com `prova-executada`.

## Regras de processo

- **Nunca mate pela porta**: `lsof -ti:<porta> | xargs kill` pode derrubar outro serviço que escuta nela (o Docker, por exemplo).
- **Nunca use `pkill` geral** nem mate por nome de processo.
- **Mate só o PID que você iniciou** e gravou.
- **Nunca abra navegador por CDP**, headless externo ou qualquer coisa que peça permissão de gravação de tela; use o navegador do app ou o Playwright do projeto.
- **Credenciais só de teste**, lidas do seed do projeto; nunca escritas no chat, na skill ou em log.
- Nunca resete banco compartilhado com outra frente aberta.

## Não faça

- Não invente comando, rota ou seletor: só o que existe no repositório.
- Não enfraqueça uma jornada para ela passar: precondição que falta no seed vira pegadinha e falha relatada.
- Não dirija instância que você não subiu.
- Não grave a skill fora de `.claude/skills/verificar-app/` do projeto.
