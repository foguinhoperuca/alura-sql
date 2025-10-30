EXPLAIN (ANALYZE, FORMAT JSON) SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    n.DATA_VENDA, n.IMPOSTO, i.QUANTIDADE,  i.PRECO,
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

--  Criar chaves primárias

-- Adicionar chave primária na tabela de clientes
ALTER TABLE tabela_de_clientes
ADD CONSTRAINT pk_tabela_de_clientes PRIMARY KEY (CPF);

-- Adicionar chave primária na tabela de produtos
ALTER TABLE tabela_de_produtos
ADD CONSTRAINT pk_tabela_de_produtos PRIMARY KEY (CODIGO_DO_PRODUTO);

-- Adicionar chave primária na tabela de vendedores
ALTER TABLE tabela_de_vendedores
ADD CONSTRAINT pk_tabela_de_vendedores PRIMARY KEY (MATRICULA);

-- Adicionar chave primária na tabela de notas fiscais
ALTER TABLE notas_fiscais
ADD CONSTRAINT pk_notas_fiscais PRIMARY KEY (NUMERO);

-- Adicionar chave primária composta na tabela de itens de notas fiscais
ALTER TABLE itens_notas_fiscais
ADD CONSTRAINT pk_itens_notas_fiscais PRIMARY KEY (NUMERO, CODIGO_DO_PRODUTO);

-- Tentando de novo

EXPLAIN (ANALYZE, FORMAT JSON) SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    n.DATA_VENDA, n.IMPOSTO, i.QUANTIDADE,  i.PRECO,
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
-- 3937.73 -- Com as chaves primárias


