-- Projeto: Organização Digital para Pequenos Comércios em Casa
-- Banco: MySQL 8.0+
-- Execute este arquivo em um ambiente de testes. Os comandos DELETE são exemplos.

CREATE DATABASE IF NOT EXISTS organizacao_digital
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE organizacao_digital;

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(160) UNIQUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(80),
    preco DECIMAL(10,2) NOT NULL,
    estoque INT UNSIGNED NOT NULL DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_produtos_preco CHECK (preco >= 0),
    CONSTRAINT chk_produtos_estoque CHECK (estoque >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente','em_andamento','concluido','cancelado')
        NOT NULL DEFAULT 'pendente',
    observacao VARCHAR(500),
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_item_preco CHECK (preco_unitario >= 0),
    CONSTRAINT fk_itens_pedidos
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_itens_produto ON itens_pedido(id_produto);

-- Dados demonstrativos (podem ser executados novamente após limpar as tabelas,
-- ou em uma base nova).
INSERT INTO clientes (nome, telefone, email) VALUES
('Ana Souza', '(67) 99999-1111', 'ana.exemplo@email.com'),
('Bruno Lima', '(67) 98888-2222', 'bruno.exemplo@email.com');

INSERT INTO produtos (nome, categoria, preco, estoque) VALUES
('Bolo de cenoura', 'Alimentos', 25.00, 10),
('Caneca artesanal', 'Presentes', 32.50, 7),
('Pão caseiro', 'Alimentos', 12.00, 15);

INSERT INTO pedidos (id_cliente, status, observacao) VALUES
(1, 'pendente', 'Entrega a combinar'),
(2, 'concluido', 'Pedido demonstrativo');

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 25.00),
(1, 3, 1, 12.00),
(2, 2, 1, 32.50);

-- CONSULTA: listar produtos disponíveis
SELECT id_produto, nome, categoria, preco, estoque
FROM produtos
WHERE ativo = TRUE
ORDER BY nome;

-- CONSULTA: pedidos com cliente e total calculado
SELECT p.id_pedido, c.nome AS cliente, p.data_pedido, p.status,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS total_pedido
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
LEFT JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome, p.data_pedido, p.status
ORDER BY p.data_pedido DESC;

-- CONSULTA: produtos mais vendidos (quantidade total)
SELECT pr.nome, SUM(ip.quantidade) AS unidades_vendidas
FROM itens_pedido ip
JOIN produtos pr ON pr.id_produto = ip.id_produto
JOIN pedidos pe ON pe.id_pedido = ip.id_pedido
WHERE pe.status <> 'cancelado'
GROUP BY pr.id_produto, pr.nome
ORDER BY unidades_vendidas DESC;

-- ATUALIZAÇÃO: alterar preço e estoque de um produto
UPDATE produtos
SET preco = 27.00, estoque = 9
WHERE id_produto = 1;

-- REMOÇÃO: exemplo seguro para testar em uma transação e desfazer
START TRANSACTION;
INSERT INTO clientes (nome, telefone, email)
VALUES ('Cliente temporário', NULL, 'temporario.exemplo@email.com');
DELETE FROM clientes WHERE email = 'temporario.exemplo@email.com';
ROLLBACK;

-- Exemplo de exclusão lógica de produto (preserva histórico de pedidos)
UPDATE produtos SET ativo = FALSE WHERE id_produto = 3;

-- Verificação dos dados
SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
