-- -- Excelent accommodations
-- SELECT
--   *
-- FROM insight_places.reviews AS r
-- WHERE
--   r.rate >= 4
-- LIMIT 5
-- ;

-- -- How many accommodations is the best rated?
-- SELECT
--   a.accommodation_type,
--   COUNT(*) AS "total_rate_excelent"
-- FROM insight_places.accommodations AS a
-- LEFT JOIN insight_places.reviews AS r ON a.id = r.accommodation_id
-- WHERE
--   r.rate >= 5
-- GROUP BY
--   a.accommodation_type
-- ;

-- -- Total Active Accommodations
-- WITH
--   accommodation_type_active AS (
--     SELECT
--       a.accommodation_type,
--       COUNT(*) AS "total_by_type_active"
--     FROM insight_places.accommodations AS a
--     WHERE
--       a.active IS TRUE
--     GROUP BY
--       a.accommodation_type
--   ),
--   accommodation_type_total AS (
--     SELECT
--       accommodation_type,
--       COUNT(*) AS "total_by_type"
--     FROM insight_places.accommodations AS a
--     GROUP BY
--       a.accommodation_type
--   )
-- SELECT
--   t.accommodation_type AS "Type",
--   t.total_by_type AS "TOTAL by Type",
--   a.total_by_type_active AS "ACTIVES"
-- FROM insight_places.accommodation_type_total AS t
-- LEFT JOIN insight_places.accommodation_type_active AS a ON t.accommodation_type = a.accommodation_type
-- ;

-- -- Avarage ticket
-- SELECT
--   client_id,
--   AVG(total_price) AS "AVARAGE Ticket"
-- FROM insight_places.rents AS r
-- GROUP BY
--   client_id
-- ;

-- Avarage time
SELECT
  client_id,
  AVG(DATEDIFF(r.end_date, start_date)) AS "avarage_stays_in_days"
FROM insight_places.rents AS r
GROUP BY
  client_id
 ORDER BY
   avarage_stays_in_days DESC
LIMIT 10
;
