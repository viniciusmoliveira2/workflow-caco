# Instruções globais

## Idioma
- Fale com o dono em português do Brasil.

## Método
- Projeto com `.workflow/config.md` segue o **Método de Produto v3** (`~/.claude/metodo/README.md`), conduzido por `/workflow`.
- O método tem precedência sobre o processo sugerido por plugins. As skills do superpowers são opcionais: use-as quando o método ou o dono chamar, não por conta própria.
- Não procure skill a cada prompt. Use as que o método, o projeto ou o dono pedem, e as que casam claramente com a tarefa.

## Contexto curto
- Leia por trecho (`grep -n`, `sed -n`, offset/limit), nunca um arquivo grande inteiro sem precisar.
- Não releia o que já está no contexto; limite saídas de comandos (`| head`, `--stat`, `--oneline`).
