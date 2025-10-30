
-- Vamos verificar a tabela de itens de notas fiscais

-- Criar novo campo

ALTER TABLE itens_notas_fiscais
ADD COLUMN QUANTIDADE_REAL REAL;

UPDATE itens_notas_fiscais
SET QUANTIDADE_REAL = QUANTIDADE;

SELECT * FROM itens_notas_fiscais LIMIT 10;


-- Execute a consulta

EXPLAIN ANALYZE SELECT * FROM itens_notas_fiscais WHERE 
QUANTIDADE * 1.00001 >= 10 AND QUANTIDADE / 0.99999 <= 20;
-- 37724.72

EXPLAIN ANALYZE SELECT * FROM itens_notas_fiscais WHERE 
QUANTIDADE_REAL * 1.00001 >= 10 AND QUANTIDADE_REAL / 0.99999 <= 20;
-- 35087.34

-- restrições nas colunas

CREATE TABLE notas_fiscais (
  CPF varchar(11) NOT NULL,
  MATRICULA varchar(5) NOT NULL,
  DATA_VENDA date,
  NUMERO int NOT NULL,
  IMPOSTO real NOT NULL
);

ALTER TABLE notas_fiscais
ADD COLUMN NUMERO_UNICO int;

ALTER TABLE notas_fiscais
ADD CONSTRAINT UK_NUMERO_UNICO UNIQUE (NUMERO_UNICO);

UPDATE notas_fiscais SET NUMERO_UNICO = NUMERO;

SELECT * FROM notas_fiscais LIMIT 10;

EXPLAIN ANALYZE
SELECT * FROM notas_fiscais WHERE NUMERO = 1000;
-- 5287.68

EXPLAIN ANALYZE
SELECT * FROM notas_fiscais WHERE NUMERO_UNICO = 1000;
-- 8.44








