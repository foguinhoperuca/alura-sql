/**
 * 01 - Otimização de Consultas no Postgreql
 */

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

/**
 * 02 - Índices e suas Aplicações para Otimização
 */
--
-- 02.01
--
CREATE INDEX idx_product_code_btree ON frutally.products(code);
SELECT * FROM frutally.products WHERE code  = '1';
SELECT * FROM frutally.products WHERE code  > '1';

CREATE INDEX idx_customer_identification_document_hash ON frutally.customers USING HASH(identification_document);
SELECT * FROM frutally.customers WHERE identification_document = '1';

CREATE INDEX idx_customers_geo ON frutally.customers_geo USING GIST(geom);
SELECT
    identification_document,
    geom
FROM frutally.customers_geo
WHERE
    ST_DWithin(
        geom,
        ST_SetSRID(ST_MakePoint(-43.2096, -22.9035), 4326),
        10000 
    )
;

--
-- 02.03
--
SELECT
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS index_scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM pg_stat_user_indexes
WHERE
    schemaname = 'frutally'
;
SELECT * FROM frutally.customers WHERE identification_document = '5576228758';

--
-- 02.05
--
EXPLANIN ANALYZE SELECT * FROM frutally.customers WHERE neighborhood = 'Centro';

CREATE INDEX idx_neighborhood ON frutally.customers(neighborhood);
EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE neighborhood = 'Centro';

--
-- 02.07
--
REINDEX INDEX frutally.idx_neighborhood;
REINDEX TABLE frutally.customers;
REINDEX SCHEMA frutally;

VACUUM frutally.customers;
VACCUM FULL;

ANALYZER frutally.customers;

CREATE INDEX idx_neighborhood_partial ON frutally.customers(neighborhood) WHERE neighborhood = 'Centro';

CREATE INDEX idx_name_lower ON frutally.slaesmas(LOWER(salesman_name));
SELECT * FROM frutally.salesmansWHERE (LOWER(saleman_name)) = 'victor';

CREATE INDEX idx_neighborhood-age ON frutally.customers(age, neighborhood);
EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE age = 30 AND neighborhood = 'Centro';
EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE neighborhood = 'Centro';
EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE neighborhood = 'Jardins';

CREATE INDEX idx_registration_number ON frutally.salesmans(registration_number);
SELECT * FROM frutally.salesmans WHERE registration_number = '00236';
