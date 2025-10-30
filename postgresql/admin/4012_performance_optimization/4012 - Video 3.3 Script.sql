
-- Subqueries

-- Joins

-- Usando Subquerie

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT NOME FROM tabela_de_clientes 
WHERE CPF IN (SELECT CPF FROM notas_fiscais WHERE DATA_VENDA > '2023-01-01');
-- 12.35
-- 4572.48

-- Usando JOIN

EXPLAIN (ANALYZE, FORMAT JSON) SELECT c.NOME FROM tabela_de_clientes c
JOIN notas_fiscais nf ON c.CPF = nf.CPF
WHERE nf.DATA_VENDA > '2023-01-01';
-- 12.34
-- 4769.82

DROP INDEX idx_cpf_cliente_hash;
DROP INDEX idx_data_venda;


-- CTEs (COMMON TABLE EXPRESSIONS)

EXPLAIN (FORMAT JSON) 
	SELECT NOME, (SELECT MAX(DATA_VENDA) FROM notas_fiscais WHERE CPF = c.CPF) AS ultima_compra
FROM tabela_de_clientes c;
-- 82379694.84

EXPLAIN (FORMAT JSON) 
	WITH ultima_venda AS (
    SELECT CPF, MAX(DATA_VENDA) AS ultima_compra 
    FROM notas_fiscais 
    GROUP BY CPF
)
SELECT c.NOME, uv.ultima_compra 
FROM tabela_de_clientes c
JOIN ultima_venda uv ON c.CPF = uv.CPF;
-- 4328.43

-- Outro exemplo

EXPLAIN ANALYZE SELECT IDADE, COUNT(*)
FROM tabela_de_clientes
GROUP BY IDADE
HAVING COUNT(*) > 10;
-- 480.76

EXPLAIN ANALYZE SELECT IDADE, COUNT(*)
FROM tabela_de_clientes
WHERE IDADE <> 0
GROUP BY IDADE
HAVING COUNT(*) > 10;
-- 430.76

-- Outro exemplo

EXPLAIN (FORMAT JSON) SELECT nome_do_produto, 
	(SELECT SUM(quantidade) FROM itens_notas_fiscais WHERE codigo_do_produto = p.codigo_do_produto) * 0.10 AS custo
FROM tabela_de_produtos p;
-- 406848521.36

EXPLAIN (FORMAT JSON) WITH total_quantidade AS (
    SELECT codigo_do_produto, SUM(quantidade) AS quantidade 
    FROM itens_notas_fiscais 
    GROUP BY codigo_do_produto
)
SELECT p.nome_do_produto, tp.quantidade * 0.10 AS comissao
FROM tabela_de_produtos p
JOIN total_quantidade tp ON p.codigo_do_produto = tp.codigo_do_produto;
-- 14764.42















update tabela_de_clientes set IDADE = 0 where substring(nome,1,7) = 'Cliente'






