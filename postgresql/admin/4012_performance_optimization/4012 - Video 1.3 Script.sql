
-- pg_stat_statements

-- pg_stat_activity

-- Editar o PostgreSql.conf

-- shared_preload_libraries = 'pg_stat_statements'
-- pg_stat_statements.track = all
-- pg_stat_statements.max = 10000
-- pg_stat_statements.track_utility = on

-- Executar 3 vezes esta consulta

SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Jardins';
SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Jardins';
SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Jardins';

-- Para buscar as estatísticas das consultas

CREATE EXTENSION pg_stat_statements;

SELECT query,calls,total_exec_time,min_exec_time,max_exec_time,mean_exec_time
FROM pg_stat_statements WHERE query LIKE 'SELECT * FROM tabela_de_clientes%';
