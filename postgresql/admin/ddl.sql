DROP TABLE IF EXISTS salesmans;
CREATE TABLE salesmans (
  registration_number VARCHAR(8) NOT NULL,
  salesman_name VARCHAR(128),
  commission_rate REAL,
  admission DATE,
  vacation BOOLEAN,
  neighborhood VARCHAR(64)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  code VARCHAR(16) NOT NULL,
  product_name VARCHAR(64),
  packaging VARCHAR(32),
  product_size VARCHAR(16),
  flavor VARCHAR(32),
  list_price REAL NOT NULL
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
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

DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices (
  identification_document VARCHAR(16) NOT NULL,
  registration_number VARCHAR(8) NOT NULL,
  sold DATE,
  invoice_number SERIAL PRIMARY KEY,
  taxes REAL NOT NULL
);

DROP TABLE IF EXISTS invoice_items;
CREATE TABLE invoice_items (
  invoice_item_number INT NOT NULL,
  product_code VARCHAR(16) NOT NULL,
  quantity INT NOT NULL,
  price REAL NOT NULL
);
