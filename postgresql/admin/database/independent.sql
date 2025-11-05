DROP TABLE IF EXISTS frutally.salesmans;
CREATE TABLE frutally.salesmans (
  registration_number VARCHAR(8) NOT NULL,
  salesman_name VARCHAR(128),
  commission_rate REAL,
  admission DATE,
  vacation BOOLEAN,
  neighborhood VARCHAR(64)
);

DROP TABLE IF EXISTS frutally.products;
CREATE TABLE frutally.products (
  code VARCHAR(16) NOT NULL,
  product_name VARCHAR(64),
  packaging VARCHAR(32),
  product_size VARCHAR(16),
  flavor VARCHAR(32),
  list_price REAL NOT NULL
);
ALTER TABLE frutally.products ADD PRIMARY KEY (code);

DROP TABLE IF EXISTS frutally.customers;
CREATE TABLE frutally.customers (
  identification_document VARCHAR(16) NOT NULL,
  customer_name VARCHAR(100),
  -- FIXME is address_line or two different places!?
  address_line_one VARCHAR(150),
  address_line_two VARCHAR(150),
  neighborhood VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(2),
  zip_code VARCHAR(8),
  birthday DATE,
  age SMALLINT,
  gender VARCHAR(1),
  credit_limit REAL,
  purchase_volume REAL,
  first_time_buying BOOLEAN
);
ALTER TABLE frutally.customers ADD CONSTRAINT unique_identification_document UNIQUE(identification_document);

DROP TABLE IF EXISTS frutally.invoices;
CREATE TABLE frutally.invoices (
  identification_document VARCHAR(16) NOT NULL,
  registration_number VARCHAR(8) NOT NULL,
  sold DATE,
  invoice_number SERIAL PRIMARY KEY,
  taxes REAL NOT NULL
);
ALTER TABLE frutally.invoices ADD CONSTRAINT fk_invoices_identification_document FOREIGN KEY (identification_document) REFERENCES frutally.customers(identification_document);
ALTER TABLE frutally.invoices DROP CONSTRAINT fk_invoices_identification_document;
ALTER TABLE frutally.invoices ADD COLUMN invoice_number_unique INT;
ALTER TABLE frutally.invoices ADD CONSTRAINT uk_invoice_number_unique UNIQUE(invoice_number_unique);

DROP TABLE IF EXISTS frutally.invoice_items;
CREATE TABLE frutally.invoice_items (
  invoice_item_number INT NOT NULL,
  product_code VARCHAR(16) NOT NULL,
  quantity INT NOT NULL,
  price REAL NOT NULL
);
ALTER TABLE frutally.invoice_items ADD COLUMN quantity_real REAL;

 -- backup_restore: class 01.03
ALTER TABLE frutally.invoices ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- performance_optimization 01.02
DROP TABLE IF EXISTS frutally.customers_geo;
CREATE TABLE frutally.customers_geo (
  identification_document VARCHAR(16) NOT NULL,
  geom GEOMETRY(POINT, 4326)
);

DROP FUNCTION IF EXISTS frutally.simulate_delay;
CREATE OR REPLACE FUNCTION frutally.simulate_delay(p_iterations INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..p_iterations LOOP
        PERFORM pg_sleep(0.001);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- performance_optimization 04.01
CREATE TABLE frutally.invoice_and_item_desnormalized (
  identification_number VARCHAR(16) NOT NULL,
  registration_number VARCHAR(8) NOT NULL,
  sold DATE,
  invoice_number SERIAL PRIMARY KEY,
  taxes REAL NOT NULL,
  product_code VARCHAR(16) NOT NULL,
  quantity INT NOT NULL,
  price REAL NOT NULL
);

-- performance_optimization 04.07

DROP TABLE IF EXISTS frutally.invoices_part;
CREATE TABLE frutally.invoices_part (
  identification_document VARCHAR(16) NOT NULL,
  registration_number VARCHAR(8) NOT NULL,
  sold DATE,
  invoice_number SERIAL PRIMARY KEY,
  taxes REAL NOT NULL
)
PARTITION BY RANGE(sold)
;
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');
CREATE TABLE invoices_part_2015 PARTITION OF invoices_part FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
