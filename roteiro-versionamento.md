# Roteiro de versionamento

## Boas práticas
- Fazer commits pequenos, frequentes e com mensagens que expliquem a intenção.
- Não incluir senhas, tokens ou dados pessoais reais no repositório.
- Usar branches para mudanças maiores e revisar antes de integrar.
- Manter README atualizado e conferir `git status` antes de cada commit.

## Exemplo de fluxo
```bash
git status
git add sql/schema_e_dados.sql
git commit -m "feat: cria tabelas e relacionamentos"
git add docs/modelo-relacional.md
git commit -m "docs: documenta entidades e restrições"
git log --oneline
```

Para uma funcionalidade isolada:
```bash
git switch -c feat/consulta-relatorio-vendas
# edite e teste os arquivos
git add .
git commit -m "feat: adiciona consulta de resumo de vendas"
git switch main
git merge feat/consulta-relatorio-vendas
```

O fluxo acima é uma sugestão. No relatório, descreva apenas os comandos e commits que você realmente executou.
