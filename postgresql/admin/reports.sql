/**
 * Custom reports used.
 */

--
-- Class 2.04
--
SHOW work_mem;
SHOW maintenance_work_mem;
SHOW effective_cache_size;
SHOW shared_buffers;
SHOW ALL;

SELECT current_setting('work_mem'), current_setting('maintenance_work_mem'), current_setting('effective_cache_size'), current_setting('shared_buffers');

SELECT
    s.name,
    s.setting
FROM pg_settings AS s
WHERE
    s.name IN (
        'server_version',
        'port',
        'work_mem',
        'maintenance_work_mem',
        'effective_cache_size',
        'shared_buffers'
    )
;

-- work_mem = 1MB
-- maintenance_work_mem = 16MB 
-- effective_cache_size = 16MB
-- shared_buffers = 128MB

-- work_mem = 64MB
-- maintenance_work_mem = 1GB 
-- effective_cache_size = 12GB
-- shared_buffers = 4GB

EXPLAIN ANALYZE
    SELECT
        a.product_name,
        EXTRACT(YEAR FROM b.sold) AS "SOLD_YEAR"
        , SUM(c.quantity) AS "SOLD_QUANTITY"
    FROM products AS a
    INNER JOIN invoice_items AS c ON a.code = c.product_code
    INNER JOIN invoices AS b ON c.invoice_item_number = b.invoice_number
    WHERE
        a.packaging = 'Garrafa'
    GROUP BY
        a.product_name,
        EXTRACT(YEAR FROM b.sold)
    HAVING
        SUM(c.quantity) > 300000
    ORDER BY
        a.product_name,
        EXTRACT(YEAR FROM b.sold)
;
