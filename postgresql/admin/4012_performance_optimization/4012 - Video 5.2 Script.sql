
EXPLAIN (ANALYZE, FORMAT JSON) SELECT 
    c.NOME AS nome_cliente, c.CPF,
    c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO,
    p.EMBALAGEM, p.PRECO_DE_LISTA,
    n.DATA_VENDA, n.IMPOSTO,
    i.QUANTIDADE, i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + n.IMPOSTO / 100)) AS valor_com_imposto
FROM itens_notas_fiscais i
JOIN notas_fiscais n ON i.NUMERO = n.NUMERO
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON n.CPF = c.CPF
JOIN tabela_de_vendedores v ON n.MATRICULA = v.MATRICULA
WHERE (n.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false;  

-- 26756.53 -- Consulta Original

-- Crie indices para os filtros

-- Índice para a coluna DATA_VENDA na tabela notas_fiscais
CREATE INDEX idx_data_venda ON notas_fiscais (DATA_VENDA);

-- Índice para a coluna CIDADE na tabela tabela_de_clientes
CREATE INDEX idx_cidade ON tabela_de_clientes (CIDADE);

-- Índice para a coluna IDADE na tabela tabela_de_clientes
CREATE INDEX idx_idade ON tabela_de_clientes (IDADE);

-- Índice para a coluna PRECO_DE_LISTA na tabela tabela_de_produtos
CREATE INDEX idx_preco_de_lista ON tabela_de_produtos (PRECO_DE_LISTA);

-- Índice para a coluna DE_FERIAS na tabela tabela_de_vendedores
CREATE INDEX idx_de_ferias ON tabela_de_vendedores (DE_FERIAS);


-- Execute a consulta novamente e veja se houve ganho

EXPLAIN (ANALYZE, FORMAT JSON) SELECT 
    c.NOME AS nome_cliente, c.CPF,
    c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO,
    p.EMBALAGEM, p.PRECO_DE_LISTA,
    n.DATA_VENDA, n.IMPOSTO,
    i.QUANTIDADE, i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + n.IMPOSTO / 100)) AS valor_com_imposto
FROM itens_notas_fiscais i
JOIN notas_fiscais n ON i.NUMERO = n.NUMERO
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON n.CPF = c.CPF
JOIN tabela_de_vendedores v ON n.MATRICULA = v.MATRICULA
WHERE (n.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false; 

-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta