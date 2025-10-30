
-- Listando os indices criados

SELECT
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS index_scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM
    pg_stat_user_indexes
WHERE
    schemaname = 'public';

-- Execute

SELECT * FROM tabela_de_clientes WHERE CPF = '5576228758';

