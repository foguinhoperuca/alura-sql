-- postgresql-administracao-monitoramento.05
VACUUM;
VACUUM FULL;
ANALYZE;
VACUUM ANALYZE;

-- Verify optimizations
SELECT
    relname,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
;
