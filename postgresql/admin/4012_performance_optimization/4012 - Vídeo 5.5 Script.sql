-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta
-- 3937.73 (444.707) -- Com as chaves primárias (*)
-- 3937.73 (461.388) -- Com CTE -- Não apresentou melhoras
-- 16729.76 (487.344) -- Com tabela desnormalizada

-- Fazer tabela particionada

DROP TABLE notas_fiscais_itens_part;
CREATE TABLE notas_fiscais_itens_part (
  CPF varchar(11) NOT NULL,
  MATRICULA varchar(5) NOT NULL,
  DATA_VENDA date NOT NULL,
  NUMERO serial NOT NULL,
  IMPOSTO real NOT NULL,
  CODIGO_DO_PRODUTO varchar(10) NOT NULL,
  QUANTIDADE int NOT NULL,
  PRECO real NOT NULL
) PARTITION BY RANGE (data_venda);

ALTER TABLE notas_fiscais_itens_part
ADD CONSTRAINT pk_notas_fiscais_itens_part PRIMARY KEY (NUMERO, CODIGO_DO_PRODUTO, DATA_VENDA);

CREATE INDEX idx_nfi_data_venda_part ON notas_fiscais_itens_part (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2015 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2015 ON notas_fiscais_itens_part_2015 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2016 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2016 ON notas_fiscais_itens_part_2016 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2017 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2017 ON notas_fiscais_itens_part_2017 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2018 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2018 ON notas_fiscais_itens_part_2018 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2019 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2019 ON notas_fiscais_itens_part_2019 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2020 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2020 ON notas_fiscais_itens_part_2020 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2021 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2021 ON notas_fiscais_itens_part_2021 (DATA_VENDA);

CREATE TABLE notas_fiscais_itens_part_2022 PARTITION OF notas_fiscais_itens_part
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
CREATE INDEX idx_notas_fiscais_itens_part_2022 ON notas_fiscais_itens_part_2022 (DATA_VENDA);

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2015-01-01' AND data_venda < '2016-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2016-01-01' AND data_venda < '2017-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2017-01-01' AND data_venda < '2018-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2018-01-01' AND data_venda < '2019-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2019-01-01' AND data_venda < '2020-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2020-01-01' AND data_venda < '2021-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2021-01-01' AND data_venda < '2022-01-01';

INSERT INTO notas_fiscais_itens_part
SELECT * FROM notas_fiscais_itens
WHERE data_venda >= '2022-01-01' AND data_venda < '2023-01-01';

EXPLAIN ANALYZE SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    i.DATA_VENDA, i.IMPOSTO, i.QUANTIDADE,  i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + i.IMPOSTO / 100)) AS valor_com_imposto
FROM notas_fiscais_itens_part i
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
-- 15468.85 (2842.453) -- Com tabela desnormalizada

EXPLAIN ANALYZE SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor,
    v.MATRICULA, p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA,
    i.DATA_VENDA, i.IMPOSTO, i.QUANTIDADE,  i.PRECO,
    (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + i.IMPOSTO / 100)) AS valor_com_imposto
FROM notas_fiscais_itens_part i
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON i.CPF = c.CPF
JOIN tabela_de_vendedores v ON i.MATRICULA = v.MATRICULA
WHERE (i.DATA_VENDA BETWEEN '2023-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false;

-- 26756.53 -- Consulta Original
-- 25022.39 -- Indices aplicados no filtro da consulta
-- 3937.73 (444.707) -- Com as chaves primárias (*)
-- 3937.73 (461.388) -- Com CTE -- Não apresentou melhoras
-- 16729.76 (487.344) -- Com tabela desnormalizada
-- 15468.85 (2842.453) -- Com tabela particionada

