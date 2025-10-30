
-- Melhoria no desempenho

-- Facilidade de manutenção

SELECT EXTRACT(YEAR FROM data_venda) AS ano, COUNT(*) 
FROM notas_fiscais 
GROUP BY EXTRACT(YEAR FROM data_venda)
ORDER BY EXTRACT(YEAR FROM data_venda);

CREATE TABLE notas_fiscais_part (
    CPF varchar(11) NOT NULL,
     MATRICULA varchar(5) NOT NULL,
     DATA_VENDA date,
     NUMERO int NOT NULL,
     IMPOSTO real NOT NULL
) PARTITION BY RANGE (data_venda);

CREATE TABLE notas_fiscais_part_2015 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');

CREATE TABLE notas_fiscais_part_2016 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');

CREATE TABLE notas_fiscais_part_2017 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');

CREATE TABLE notas_fiscais_part_2018 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');

CREATE TABLE notas_fiscais_part_2019 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');

CREATE TABLE notas_fiscais_part_2020 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE notas_fiscais_part_2021 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE notas_fiscais_part_2022 PARTITION OF notas_fiscais_part
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2015-01-01' AND data_venda < '2016-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2016-01-01' AND data_venda < '2017-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2017-01-01' AND data_venda < '2018-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2018-01-01' AND data_venda < '2019-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2019-01-01' AND data_venda < '2020-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2020-01-01' AND data_venda < '2021-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2021-01-01' AND data_venda < '2022-01-01';

INSERT INTO notas_fiscais_part
SELECT * FROM notas_fiscais
WHERE data_venda >= '2022-01-01' AND data_venda < '2023-01-01';

-- Testar as duas consultas

EXPLAIN ANALYZE
SELECT * FROM notas_fiscais WHERE data_venda BETWEEN '2023-06-01' AND '2023-12-31';
-- 4325.79
-- 55.183 ms

EXPLAIN ANALYZE
SELECT * FROM notas_fiscais_part WHERE data_venda BETWEEN '2023-06-01' AND '2023-12-31';
-- 0.00
-- 0.010 ms








