---
name: prova-executada
description: Portão de toda entrega. Use antes de dizer que algo está pronto: fecha com veredito VERIFICADO, NÃO VERIFICADO ou INCONCLUSIVO, com comando, saída e antes/depois. Sem comando, não vale.
---

# Prova executada

Entrega sem prova tem correção desconhecida. Este portão fecha toda entrega com um veredito tirado de evidência nova, da coisa real, não de um substituto.

## Quando é obrigatória

Toda entrega: SWE ao terminar, QA, Segurança ao aplicar correção, orquestrador antes do merge. Substitui `verification-before-completion`. Se o projeto tem a skill local `verificar-app` (gerada por `gerar-verificacao-do-app`), use-a para tudo que tem tela ou serviço.

## Passos

1. **Reescreva a afirmação de forma refutável**: condição, métrica, limiar. "Funciona" não serve; "a rota X devolve 404 para um usuário de outra conta" serve. Ligue ao critério numerado da spec quando houver.
2. **Escolha a menor superfície local** que pode refutá-la: teste focado, script de repro, requisição HTTP, consulta ao banco com a sessão certa, captura pela `verificar-app`.
3. **Antes** (quando houver): o estado antigo, como o commit pai, a base da branch ou o repro que falhava.
4. **Depois**: o estado novo, com o mesmo comando, os mesmos dados e o mesmo ambiente.
5. **Compare os artefatos brutos**: números, saída, resposta, captura.
6. **Rode os comandos de verificação** listados em `.workflow/config.md` (ex.: typecheck, lint, build, suíte) e registre o resultado de cada um.
7. **Dê exatamente um veredito.**

## Vereditos

- **VERIFICADO**: antes e depois diferem na direção prevista, no limiar, sem confusor óbvio; ou, sem antes, a afirmação foi exercitada na coisa real e passou.
- **NÃO VERIFICADO**: o comportamento ficou igual, foi na direção errada ou não chegou ao limiar.
- **INCONCLUSIVO**: sem linha de base válida, sinal ruidoso, medição que falhou, ambiente diferente que invalida a comparação, ou comando que não pôde rodar.

Não suavize resultado negativo. Um NÃO VERIFICADO claro é útil.

## A coisa real, não um substituto

- Processo vivo se confere direto (PID, resposta), não por log antigo ou arquivo derivado.
- Valor se lê na fonte (linha no banco, resposta da rota), não em cache, captura antiga ou relato de outro agente.
- "Compila" e "o subagente disse que passou" não são prova.
- Se a verificação falha, suspeite primeiro do método de observação.
- Prefira um script determinístico que se roda de novo a uma olhada única.

## Formato

```
VERIFICADO | NÃO VERIFICADO | INCONCLUSIVO
Afirmação: <refutável, com o critério da spec>
Evidência:
- `<comando>` → <saída resumida: 14 testes, 0 falhas / status 404 / ...>
- antes=<...> · depois=<...> · limiar=<...>
Verificação do projeto: typecheck ok · lint ok · build ok · suíte 812/812
Raciocínio: <um parágrafo curto: confusores e o que não foi coberto>
```

Várias afirmações: um bloco por afirmação e um veredito geral, que é o pior dos parciais.

## Evidência e dados

- A evidência fica dentro do projeto, na pasta da frente (ex.: `.workflow/frentes/<frente>/prova/`), ou só no texto. Siga a config sobre o que não se versiona (capturas, por padrão, ficam fora do git).
- Nunca grave dado pessoal ou sensível (nome, e-mail, dado de saúde, token, corpo de resposta com dado de usuário, conteúdo de prompt) em `/tmp` ou fora do projeto. Na dúvida, resuma no texto e mascare.
- Só dados de seed ou de teste; nunca de produção.

## Não faça

- Não declare pronto com "deve funcionar", "parece certo" ou "testei localmente" sem o comando.
- Não reaproveite saída de execução anterior à última mudança.
- Não troque a afirmação por uma mais fácil depois de ver o resultado.
- Não limpe o ambiente fora da regra do projeto: mate só o PID que você iniciou.
