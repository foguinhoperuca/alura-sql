
-- Execute

EXPLAIN ANALYZE SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';

-- Criar um indice na coluna DATA_VENDA

CREATE INDEX idx_data_venda ON notas_fiscais (DATA_VENDA);

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';

-- Criar o indice CPF na tabela de notas fiscais

CREATE INDEX idx_cpf_notas ON notas_fiscais (CPF);

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';

-- retirar o indice de data e manter apenas o de CPF.

DROP INDEX idx_cpf_notas;

CREATE INDEX idx_data_venda ON notas_fiscais (DATA_VENDA);

EXPLAIN (ANALYZE, FORMAT JSON)  SELECT c.NOME, v.DATA_VENDA FROM tabela_de_clientes c
JOIN notas_fiscais v ON c.CPF = v.CPF
WHERE v.DATA_VENDA > '2023-01-01';







