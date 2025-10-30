
-- EXPLAIN

-- EXPLAIN ANALYZER

EXPLAIN SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Centro';

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Centro';

-- Tipo de Scan

-- Custos Estimados

-- Tempo de Execução

-- Linhas e Loops

-- Seq Scan` em tabelas grandes ???

-- Altos custos estimados ???

-- Loops repetitivos??

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE VOLUME_DE_COMPRA > 10000;

EXPLAIN ANALYZE SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';





