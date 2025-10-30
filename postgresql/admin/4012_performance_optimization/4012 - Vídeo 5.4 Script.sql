EXPLAIN ANALYZE SELECT 
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
-- 3937.73 (444.707) -- Com as chaves primárias

EXPLAIN ANALYZE
WITH 
cte_notas_itens AS (
    SELECT n.NUMERO, n.CPF, n.MATRICULA, n.DATA_VENDA, n.IMPOSTO,
        i.CODIGO_DO_PRODUTO, i.QUANTIDADE, i.PRECO, (i.QUANTIDADE * i.PRECO) AS valor_venda
    FROM notas_fiscais n
    JOIN itens_notas_fiscais i ON n.NUMERO = i.NUMERO
    WHERE n.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31'
)
SELECT c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor, v.MATRICULA,
    p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA, cte_notas_itens.DATA_VENDA, cte_notas_itens.IMPOSTO,
    cte_notas_itens.QUANTIDADE, cte_notas_itens.PRECO, cte_notas_itens.valor_venda,
    (cte_notas_itens.valor_venda * (1 + cte_notas_itens.IMPOSTO / 100)) AS valor_com_imposto
FROM cte_notas_itens
JOIN tabela_de_produtos p ON cte_notas_itens.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON cte_notas_itens.CPF = c.CPF
JOIN tabela_de_vendedores v ON cte_notas_itens.MATRICULA = v.MATRICULA
WHERE c.CIDADE IS NOT NULL 
    AND c.IDADE > 18 
    AND p.PRECO_DE_LISTA > 2.3
    AND v.DE_FERIAS = false;

-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta
-- 3937.73 (444.707) -- Com as chaves primárias
-- 3937.73 (461.388) -- Com CTE -- Não apresentou melhoras

-- Criar uma tabela desnormalizada

DROP TABLE notas_fiscais_itens;
CREATE TABLE notas_fiscais_itens (
  CPF varchar(11) NOT NULL,
  MATRICULA varchar(5) NOT NULL,
  DATA_VENDA date NOT NULL,
  NUMERO serial NOT NULL,
  IMPOSTO real NOT NULL,
  CODIGO_DO_PRODUTO varchar(10) NOT NULL,
  QUANTIDADE int NOT NULL,
  PRECO real NOT NULL
);

-- criar chave primária

ALTER TABLE notas_fiscais_itens
ADD CONSTRAINT pk_notas_fiscais_itens PRIMARY KEY (NUMERO, CODIGO_DO_PRODUTO);

CREATE INDEX idx_nfi_data_venda ON notas_fiscais_itens (DATA_VENDA);

-- inserir dados

INSERT INTO notas_fiscais_itens 
	(CPF, MATRICULA, DATA_VENDA, NUMERO, CODIGO_DO_PRODUTO, QUANTIDADE, PRECO, IMPOSTO)
SELECT nf.CPF, nf.MATRICULA, nf.DATA_VENDA, nf.NUMERO, inf.CODIGO_DO_PRODUTO, 
    inf.QUANTIDADE, inf.PRECO, nf.IMPOSTO  
FROM notas_fiscais nf
INNER JOIN itens_notas_fiscais inf ON nf.NUMERO = inf.NUMERO;

-- testar consulta

EXPLAIN ANALYZE SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    i.DATA_VENDA, i.IMPOSTO, i.QUANTIDADE,  i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + i.IMPOSTO / 100)) AS valor_com_imposto
FROM notas_fiscais_itens i
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON i.CPF = c.CPF
JOIN tabela_de_vendedores v ON i.MATRICULA = v.MATRICULA
WHERE (i.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false; 

-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta
-- 3937.73 (444.707) -- Com as chaves primárias
-- 3937.73 (461.388) -- Com CTE -- Não apresentou melhoras
-- 6159.02 (2865.466) -- Com tabela desnormalizada

-- Melhorar as estatitsicas

ANALYZE notas_fiscais_itens;
CREATE INDEX idx_nfi_cpf ON notas_fiscais_itens (CPF);
CREATE INDEX idx_nfi_matricula ON notas_fiscais_itens (MATRICULA);
CREATE INDEX idx_nfi_codigo_do_produto ON notas_fiscais_itens (CODIGO_DO_PRODUTO);
CREATE INDEX idx_nfi_data_venda_range ON notas_fiscais_itens (DATA_VENDA)
WHERE DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31';

EXPLAIN ANALYZE SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    i.DATA_VENDA, i.IMPOSTO, i.QUANTIDADE,  i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + i.IMPOSTO / 100)) AS valor_com_imposto
FROM notas_fiscais_itens i
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON i.CPF = c.CPF
JOIN tabela_de_vendedores v ON i.MATRICULA = v.MATRICULA
WHERE (i.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false; 

-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta
-- 3937.73 (444.707) -- Com as chaves primárias (*)
-- 3937.73 (461.388) -- Com CTE -- Não apresentou melhoras
-- 16729.76 (487.344) -- Com tabela desnormalizada