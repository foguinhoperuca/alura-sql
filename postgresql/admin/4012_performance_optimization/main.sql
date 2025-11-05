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

/**
 * 03 - Análise e Otimização de Consultas Avançadas
 */

--
-- 03.01
--
EXPLAIN SELECT * FROM frutally.customers WHERE neighborhood = 'Centro';
EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE neighborhood = 'Centro';

EXPLAIN ANALYZE SELECT * FROM frutally.customers WHERE purchase_volume > 10000;

EXPLAIN ANALYZE
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

--
-- 03.03
--
EXPLAIN ANALYZE
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

CREATE INDEX idx_sold ON frutally.invoices(sold);
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

CREATE INDEX idx_identification_document ON invoices(identification_document);
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

DROP INDEX idx_identification_document;
CREATE INDEX idx_sold ON frutally.invoices(sold);
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    i.sold
FROM frutally.customers AS c
JOIN frutally.invoices AS i ON i.identification_document = c.identification_document
WHERE
    i.sold > '2023-01-01'
;

--
-- 03.05
--
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    customer_name
FROM frutally.customers
WHERE
    identification_document IN (
        SELECT
            identification_document
        FROM frutally.invoices
        WHERE
            sold > '2023-01-01'
    )
;

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name
FROM frutally.cutomers AS c
JOIN frutally.invoices AS i ON c.identification_document = i.identification_document
WHERE
    i.sold > '2023-01-01'
;
DROP INDEX idx_identification_document_customer_hash;
DROP INDEX idx_sold;

EXPLAIN (FORMAT JSON)
SELECT
    c.customeri_name,
    (SELECT MAX(sold) FROM frutally.invoices AS i WHERE i.identification_document = c.identification_document) AS 'last_buy'
FROM frutally.customers AS c
;
EXPLAIN (FORMAT JSON)
WITH
    last_sell AS (
        SELECT
            i.identification_document,
            MAX(sold) AS 'Last_buy'
        FROM frutally.invoices AS i
        GROUP BY
            i.identification_document
    )
SELECT
    c.customer_name,
    l.last_buy
FROM frutally.customers AS c
JOIN last_sell AS l ON c.identification_document = l.identification_document
;

EXPLAIN ANALYZE
SELECT
    age,
    COUNT(*)
FROM frutally.customers AS c
GROUP BY
    c.age
HAVING
    COUNT(*) > 10
;
EXPLAIN ANALYZE
SELECT
    age,
    COUNT(*)
FROM frutally.customers AS c
WHERE
    c.age <> 0
GROUP BY
    c.age
HAVING
    COUNT(*) > 10
;

EXPLAIN (FORMAT JSON)
SELECT
    product_name,
    (SELECT SUM(t.quantity) FROM frutally.invoice_items AS t WHERE t.product_code = p.code) * 0.10 AS 'cost'
FROM frutally.products AS p
;
EXPLAIN (FORMAT JSON)
WITH
    quantity_total AS (
        SELECT
            product_code,
            SUM(quantity) AS qnt
        FROM invoice_items AS i
        GROUP BY
            i.product_code
    )
SELECT
    p.product_name,
    q.qnt * 0.10 AS 'commission'
FROM frutally.products AS p
LEFT JOIN quantity_total AS q ON p.code = q.product_code
;

UPDATE frutally.customers SET
    age = 01
WHERE
    SUBSTRING(customer_name, 1, 7) = 'Client'
;

--
-- 03.07
--
EXPLAIN (FORMAT JSON)
SELECT
    c.customer_name,
    (SELECT
        SUM(t.quantity) AS qnt
    FROM frutally.invoices AS i
    INNER JOIN invoices_items AS t ON i.invoice_number = t.invoice_item_number
    WHERE
        sold >= '2022-01-01'
        AND i.identification_document = c.identification_document
    ) AS 'total_sells'
FROM frutally.customers AS c
;

EXPLAIN (FORMAT JSON)
WITH
    sells_2022 AS (
        SELECT
            i.identification_document,
            SUM(t.quantity) AS qnt
        FROM frutally.invoices AS i
        INNER JOIN invoice_items AS t ON i.invoice_number = t.invoice_item_number
        WHERE
            sold >= '2022-01-01'
        GROUP BY
            i.cpf
    )
SELECT
    c.customer_name,
    s.qnt
FROM frutally.customers AS c
JOIN sells_2022 AS s ON c.identification_document = v.identification_document
;

CREATE INDEX idx_identification_document_hash ON frutally.customers USING HASH(identification_document);
CREATE INDEX idx_sold ON frutally.invoices(sold);
CREATE INDEX idx_invoice_identification_document ON frutally.invoices(identification_document);
EXPLAIN (FORMAT JSON)
WITH
    sells_2022 AS (
        SELECT
            i.identification_document,
            SUM(t.quantity) AS qnt
        FROM frutally.invoices AS i
        INNER JOIN invoice_items AS t ON i.invoice_number = t.invoice_item_number
        WHERE
            sold >= '2022-01-01'
        GROUP BY
            i.cpf
    )
SELECT
    c.customer_name,
    s.qnt
FROM frutally.customers AS c
JOIN sells_2022 AS s ON c.identification_document = v.identification_document
;

/**
 * 04 - Estruturação e Manutenção de Tabelas oara Desempenho
 */

--
-- 04.01
--
SELECT
    relname AS "table_name",
    indexrelname AS "index_name"
FROM pg_stat_user_indexes
WHERE
    schemaname = 'frutally'
;

-- TODO implement an pgplsql to drop all indexes found

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    SUM(i.quantity * i.price) AS "invoicing"
FROM frutally.customers AS c
INNER JOIN frutally.invoices AS i ON c.identification_document = i.identification_document
INNER JOIN frutally.invoice_items AS t ON i.invoice_number = t.invoice_item_number
GROUP BY
    c.customer_name
;

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    SUM(i.quantity * i.price) AS "invoicing"
FROM frutally.customers AS c
INNER JOIN frutally.invoices_and_item_desnormalized AS d ON c.identification_document = d.identification_document
GROUP BY
    c.customer_name
;

--
-- 04.03
--
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
i   *
FROM frutally.products
WHERE
    code = '1040107'
;

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT
    c.customer_name,
    COUNT(*)
FROM frutally.customers AS c
INNER JOIN frutally.invoices AS i ON c.identification_number = i.identification_number
GROUP BY
    c.customer_name
;

--
-- 04.05
--
SELECT
    EXTRACT(YEAR FROM sold) AS "year",
    COUNT(*)
FROM frutally.invoices AS i
GROUP BY
    EXTRACT(YEAR FROM sold)
ORDER BY
    EXTRACT(YEAR FROM sold)
;

EXPLAIN ANALYZE
SELECT
    *
FROM frutally.invoices_part
WHERE
    sold BETWEEN '2023-06-01' AND '2023-12-31'
;
 
--
-- 04.07
--
EXPLAIN ANALYZE
SELECT
    *
FROM frutally.invoice_items
WHERE
    quantity * 1.00001 >= 10
    AND quantity / 0.99999 <= 20
;
EXPLAIN ANALYZE
SELECT
    *
FROM frutally.invoice_items
WHERE
    quantity_real * 1.00001 >= 10
    AND quantity_real / 0.99999 <= 20
;

EXPLAIN ANALYZE
SELECT
    *
FROM frutally.invoice_items
WHERE
    quantity = 1000
;
EXPLAIN ANALYZE
SELECT
    *
FROM frutally.invoice_items
WHERE
    quantity_unique = 1000
;
/**
 * 05 - Otimização Prática de Consuiltas SQL no PostgreSQL
 */


--
-- 05.01
--

--
-- 05.03
--

--
-- 05.05
--

--
-- 05.07
--

--
-- 05.09
--
