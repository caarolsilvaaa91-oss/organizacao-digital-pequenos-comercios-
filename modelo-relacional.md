# Modelo relacional

```mermaid
erDiagram
    CLIENTES ||--o{ PEDIDOS : realiza
    PEDIDOS ||--|{ ITENS_PEDIDO : contem
    PRODUTOS ||--o{ ITENS_PEDIDO : aparece_em
    CLIENTES {
      int id_cliente PK
      varchar nome
      varchar telefone
      varchar email UK
    }
    PRODUTOS {
      int id_produto PK
      varchar nome
      decimal preco
      int estoque
      boolean ativo
    }
    PEDIDOS {
      int id_pedido PK
      int id_cliente FK
      timestamp data_pedido
      enum status
    }
    ITENS_PEDIDO {
      int id_item PK
      int id_pedido FK
      int id_produto FK
      int quantidade
      decimal preco_unitario
    }
```

## Restrições e decisões
- Chaves primárias identificam cada registro.
- `pedidos.id_cliente` referencia `clientes.id_cliente`.
- `itens_pedido.id_pedido` referencia `pedidos.id_pedido`; excluir um pedido exclui seus itens (`ON DELETE CASCADE`).
- `itens_pedido.id_produto` referencia `produtos.id_produto`; produtos referenciados não podem ser excluídos fisicamente (`ON DELETE RESTRICT`).
- `clientes.email` é único quando informado.
- Preços não podem ser negativos; estoque não pode ser negativo; quantidade do item deve ser maior que zero.
- `preco_unitario` é copiado para o item do pedido para preservar o valor histórico, mesmo que o preço atual do produto mude.
- A remoção lógica (`ativo = FALSE`) preserva o histórico do catálogo.
