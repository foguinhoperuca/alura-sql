DO $$ BEGIN RAISE INFO 'CUSTOMERS'; END $$;
TRUNCATE TABLE frutally.customers RESTART IDENTITY;
\copy frutally.customers (identification_document, customer_name, address_line_one, address_line_two, neighborhood, city, state, zip_code, birthday, age, gender, credit_limit, purchase_volume, first_time_buying) FROM 'database/data/fixtures/4010_customers.csv' WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"');

DO $$ BEGIN RAISE INFO 'PRODUCTS'; END $$;
TRUNCATE TABLE frutally.products RESTART IDENTITY;
\copy frutally.products (code, product_name, packaging, product_size, flavor, list_price) FROM 'database/data/fixtures/4010_products.csv' WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"');

DO $$ BEGIN RAISE INFO 'SALESMANS'; END $$;
TRUNCATE TABLE frutally.salesmans RESTART IDENTITY;
\copy frutally.salesmans (registration_number, salesman_name, commission_rate, admission, vacation, neighborhood) FROM 'database/data/fixtures/4010_salesmans.csv' WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"');

DO $$ BEGIN RAISE INFO 'INVOICES'; END $$;
TRUNCATE TABLE frutally.invoices RESTART IDENTITY;
\copy frutally.invoices (identification_document, registration_number, sold, invoice_number, taxes) FROM 'database/data/fixtures/4010_invoices.csv' WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"');

DO $$ BEGIN RAISE INFO 'INVOICE ITEMS'; END $$;
TRUNCATE TABLE frutally.invoice_items RESTART IDENTITY;
\copy frutally.invoice_items (invoice_item_number, product_code, quantity, price) FROM 'database/data/fixtures/4010_invoice_items.csv' WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"');

-- Coord for:
-- Rio de Janeiro: (-43.2096, -22.9035); São Paulo: (-46.6333, -23.5505)
DO $$ BEGIN RAISE INFO 'CUSTOMERS GEO'; END $$;
TRUNCATE TABLE frutally.customers_geo RESTART IDENTITY;
INSERT INTO frutally.customers_geo (identification_document, geom) VALUES 
    ('1234567890',  ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)), 
    ('1471156710',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)), 
    ('19290992743', ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)), 
    ('2600586709',  ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)),  
    ('3623344710',  ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)),  
    ('492472718',   ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)),   
    ('50534475787', ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)), 
    ('5576228758',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)),  
    ('5648641702',  ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)),  
    ('5840119709',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)),  
    ('7771579779',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)),  
    ('8502682733',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)),  
    ('8719655770',  ST_GeomFromText('POINT(-46.6333 -23.5505)', 4326)),  
    ('9283760794',  ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)),  
    ('94387575700', ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326)), 
    ('95939180787', ST_GeomFromText('POINT(-43.2096 -22.9035)', 4326))
; 

INSERT INTO frutally.invoice_and_item_desnormalized (
  identification_document,
  registration_number,
  sold,
  invoice_number,
  taxes,
  product_code,
  quantity,
)
SELECT
  identification_document,
  registration_number,
  sold,
  invoice_number,
  taxes,
  product_code,
  quantity,
  price
FROM frutally.invoices AS i
INNER JOIN invoices_items AS t ON i.invoice_number = t.invoice_item_number
;

-- performance_optimization 04.05
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2015-01-01' AND sold <= '2016-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2016-01-01' AND sold <= '2017-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2017-01-01' AND sold <= '2018-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2018-01-01' AND sold <= '2019-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2019-01-01' AND sold <= '2020-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2020-01-01' AND sold <= '2021-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2021-01-01' AND sold <= '2022-01-01';
INSERT INTO frutally.invoices_part SELECT * FROM frutally.invoices WHERE sold >= '2022-01-01' AND sold <= '2023-01-01';

-- performance_optimization 04.07
UPDATE frutally.invoice_items SET
    quantity_real = quantity
;

UPDATE frutally.invoice_items SET
    quantity_unique = quantity
;
