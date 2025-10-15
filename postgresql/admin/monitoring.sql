-- postgresql-administracao-monitoramento.03
CREATE EXTENSION pg_stat_statements;
SELECT * FROM pg_available_extensions;

-- Executed statements
SELECT
    query,
    calls,
    total_exec_time,
    rows,
    shared_blks_hit
FROM pg_stat_statements
WHERE
    dbid = (SELECT oid FROM pg_database WHERE datname = 'frutally') -- filter by DB
    -- query LIKE '%customers%' -- filter by query running (exec something like SELECT * FROM customers BEFORE this query)
ORDER BY
    total_exec_time DESC
LIMIT 10
;

-- postgresql-administracao-monitoramento.04
CREATE TABLE query_logs (
    log_time TIMESTAMP,
    duration_ms INTEGER,
    query TEXT
);
SELECT * FROM query_logs;
