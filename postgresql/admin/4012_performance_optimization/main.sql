--
-- 01.02
--
SELECT * FROM frutally.customers WHERE neighborhood = 'Jardins';
SELECT * FROM frutally.customers;

--
-- 01.06
--
SELECT
    query,
    calls,
    total_exec_time,
    min_exec_time,
    max_exec_time,
    mean_exec_time
FROM pg_stat_statements
WHERE
    query LIKE 'SELECT * FROM tabela_de_clientes%'
;

--
-- 01.08
--
SELECT
    pid,
    username,
    state,
    query,
    query_start
FROM pg_stat_activity
WHERE
    state = 'active'
;

SELECT frutally.simulate_delay(40000);
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
    pg_stat_database
;

--
-- 01.10
--
VACUUM(VERBOSE);
ANALYZE frutally.customers;
REINDEX TABLE frutally.customers;
