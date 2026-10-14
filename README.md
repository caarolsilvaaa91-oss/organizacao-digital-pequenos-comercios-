# Organização Digital para Pequenos Comércios em Casa — Módulo 3

Projeto acadêmico de modelagem e manipulação de banco de dados e controle de versão, dando continuidade ao projeto web do Módulo 2.

## Objetivo
Organizar produtos, clientes e pedidos de pequenos comércios domésticos com um banco de dados relacional e registrar a evolução do código com Git.

## Tecnologias
- MySQL 8.0+
- SQL
- Git e GitHub
- Aplicação web anterior: HTML5, CSS3, JavaScript e Bootstrap 5.3

## Modelo de dados
- `clientes`: dados de clientes.
- `produtos`: catálogo, preço, estoque e indicador de ativo.
- `pedidos`: pedido vinculado a um cliente.
- `itens_pedido`: produtos e quantidades de cada pedido; guarda o preço unitário praticado no momento da venda.

Relacionamentos: um cliente pode possuir vários pedidos; um pedido possui vários itens; um produto pode aparecer em vários itens de pedido. As chaves estrangeiras protegem a integridade referencial.

## Como executar
1. Instale/inicie o MySQL 8.0+ e abra MySQL Workbench ou outro cliente SQL.
2. Abra `sql/schema_e_dados.sql`.
3. Execute o script em um ambiente de testes. Ele cria o banco `organizacao_digital`, as tabelas, dados demonstrativos e exemplos de SELECT, UPDATE e DELETE.
4. Confira os resultados das consultas. Faça capturas de tela reais para anexar ao relatório.

> Atenção: execute em uma base de testes. O script contém comandos de atualização e exemplos de exclusão. Em produção, utilize credenciais seguras, cópias de segurança e validação das operações.

## Estrutura
```text
.
├── README.md
├── .gitignore
├── sql/
│   └── schema_e_dados.sql
└── docs/
    ├── modelo-relacional.md
    └── roteiro-versionamento.md
```

## Git: sequência sugerida
```bash
git init
git add README.md .gitignore sql docs
git commit -m "docs: documenta objetivo e estrutura do projeto"
git add sql/schema_e_dados.sql
git commit -m "feat: cria esquema relacional e dados demonstrativos"
git add docs
git commit -m "docs: adiciona modelo de dados e roteiro de versionamento"
git branch -M main
```

Crie um repositório vazio no GitHub e conecte-o (substitua `USUARIO` pelo seu usuário):
```bash
git remote add origin https://github.com/USUARIO/organizacao-digital-pequenos-comercios.git
git push -u origin main
```

Depois de publicar, substitua o endereço provisório no relatório pelo link real do repositório. Não informe que o projeto foi publicado antes de confirmar o `push`.

## Próximos passos
- Executar o script e registrar evidências reais.
- Fazer commits à medida que as alterações forem concluídas.
- Publicar no GitHub e atualizar o relatório com o link real.
- Futuramente, integrar o banco a uma API/backend; o SQL deste módulo é a camada de persistência demonstrativa, não uma integração já concluída com a interface web.
