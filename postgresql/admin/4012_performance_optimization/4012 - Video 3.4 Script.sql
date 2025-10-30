
-- CTE

-- SubQuery

EXPLAIN (FORMAT JSON) SELECT c.NOME, (
SELECT SUM(INF.quantidade) AS quantidade
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
ON NF.numero = INF.numero
WHERE data_venda >= '2022-01-01'
AND NF.CPF = c.CPF
    ) AS total_vendas
FROM tabela_de_clientes c;

-- 526799071.14
-- 454021494.91
-- 454021494.91

EXPLAIN (FORMAT JSON) WITH vendas_2022 AS (
SELECT NF.CPF, SUM(INF.quantidade) AS quantidade
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
ON NF.numero = INF.numero
WHERE data_venda >= '2022-01-01'
GROUP BY NF.CPF)
SELECT c.NOME, v.quantidade
FROM tabela_de_clientes c
JOIN vendas_2022 v ON c.CPF = v.CPF;

-- 17955.56
-- 16370.95
-- 16370.95
-- 16371.1

CREATE INDEX idx_cpf_cliente_hash ON tabela_de_clientes USING HASH (CPF);
CREATE INDEX idx_data_venda ON notas_fiscais (DATA_VENDA);
CREATE INDEX idx_nota_fiscal_cpf ON notas_fiscais (CPF);

EXPLAIN (FORMAT JSON) WITH vendas_2022 AS MATERIALIZED (
SELECT NF.CPF, SUM(INF.quantidade) AS quantidade
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
ON NF.numero = INF.numero
WHERE data_venda >= '2022-01-01'
GROUP BY NF.CPF)
SELECT c.NOME, v.quantidade
FROM tabela_de_clientes c
JOIN vendas_2022 v ON c.CPF = v.CPF;

-- 16371.1


