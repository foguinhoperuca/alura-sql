
-- Chaves primárias

-- Ver script de criação da tabela de produtos

EXPLAIN (ANALYZE, FORMAT JSON) SELECT * FROM tabela_de_produtos
	WHERE CODIGO_DO_PRODUTO = '1040107';
-- 504.4

ALTER TABLE tabela_de_produtos ADD PRIMARY KEY (codigo_do_produto);

EXPLAIN (ANALYZE, FORMAT JSON) SELECT * FROM tabela_de_produtos
	WHERE CODIGO_DO_PRODUTO = '1040107';
-- 8.3

-- Chaves estrangeiras

EXPLAIN (ANALYZE, FORMAT JSON) SELECT c.NOME, COUNT(*) FROM
tabela_de_clientes c
INNER JOIN
notas_fiscais nf
ON c.CPF = nf.CPF
GROUP BY c.NOME;

-- 8366.14
-- 6079.49

ALTER TABLE tabela_de_clientes
ADD CONSTRAINT unique_cpf UNIQUE (CPF);

ALTER TABLE notas_fiscais
ADD CONSTRAINT fk_notas_fiscais_cpf
FOREIGN KEY (CPF) REFERENCES tabela_de_clientes(CPF);

EXPLAIN (ANALYZE, FORMAT JSON) SELECT c.NOME, COUNT(*) FROM
tabela_de_clientes c
INNER JOIN
notas_fiscais nf
ON c.CPF = nf.CPF
GROUP BY c.NOME;

-- 6079.49

EXPLAIN ANALYZE SELECT c.NOME, COUNT(*) FROM
tabela_de_clientes c
INNER JOIN
notas_fiscais nf
ON c.CPF = nf.CPF
GROUP BY c.NOME;

-- "HashAggregate  (cost=5879.33..6079.49 rows=20016 width=21) (actual time=77.336..77.405 rows=15 loops=1)"
-- "  Group Key: c.nome"
-- "  Batches: 1  Memory Usage: 793kB"
-- "  ->  Hash Join  (cost=744.36..4851.57 rows=205552 width=13) (actual time=4.276..48.654 rows=205552 loops=1)"
-- "        Hash Cond: ((nf.cpf)::text = (c.cpf)::text)"
-- "        ->  Seq Scan on notas_fiscais nf  (cost=0.00..3567.52 rows=205552 width=11) (actual time=0.020..9.173 rows=205552 loops=1)"
-- "        ->  Hash  (cost=494.16..494.16 rows=20016 width=24) (actual time=4.136..4.137 rows=20016 loops=1)"
-- "              Buckets: 32768  Batches: 1  Memory Usage: 1379kB"
-- "              ->  Seq Scan on tabela_de_clientes c  (cost=0.00..494.16 rows=20016 width=24) (actual time=0.008..1.658 rows=20016 loops=1)"
-- "Planning Time: 0.235 ms"
-- "Execution Time: 78.133 ms"

ALTER TABLE notas_fiscais
DROP CONSTRAINT fk_notas_fiscais_cpf;

-- "HashAggregate  (cost=5879.33..6079.49 rows=20016 width=21) (actual time=92.581..92.667 rows=15 loops=1)"
-- "  Group Key: c.nome"
-- "  Batches: 1  Memory Usage: 793kB"
-- "  ->  Hash Join  (cost=744.36..4851.57 rows=205552 width=13) (actual time=4.767..57.320 rows=205552 loops=1)"
-- "        Hash Cond: ((nf.cpf)::text = (c.cpf)::text)"
-- "        ->  Seq Scan on notas_fiscais nf  (cost=0.00..3567.52 rows=205552 width=11) (actual time=0.010..10.567 rows=205552 loops=1)"
-- "        ->  Hash  (cost=494.16..494.16 rows=20016 width=24) (actual time=4.595..4.595 rows=20016 loops=1)"
-- "              Buckets: 32768  Batches: 1  Memory Usage: 1379kB"
-- "              ->  Seq Scan on tabela_de_clientes c  (cost=0.00..494.16 rows=20016 width=24) (actual time=0.008..1.892 rows=20016 loops=1)"
-- "Planning Time: 1.120 ms"
-- "Execution Time: 93.312 ms"

