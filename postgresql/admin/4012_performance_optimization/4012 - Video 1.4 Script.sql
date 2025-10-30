
-- CPU

-- Memória

-- I/O de Disco

-- Conexões Ativas

-- Executar esta consulta

SELECT pid, usename, state, query, query_start
FROM pg_stat_activity
WHERE state = 'active';

-- Execute esta consulta abaixo.

SELECT simulate_delay(40000); 

-- Outro comando de monitoramento

SELECT
    datname,
    numbackends,
    xact_commit,
    xact_rollback,
    blks_read,
    blks_hit,
    tup_returned,
    tup_fetched,
    tup_inserted,
    tup_updated,
    tup_deleted
FROM
    pg_stat_database;

