COPY frutally.customers (identification_document, customer_name, address_line_one, address_line_two, neighborhood, city, state, zip_code, birthday, age, gender, credit_limit, purchase_volume, first_time_buying)
    FROM '/tmp/pgdata/4010_customers.csv'
    WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"')
;

COPY frutally.products (code, product_name, packaging, product_size, flavor, list_price)
    FROM '/tmp/pgdata/4010_products.csv'
    WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"')
;

COPY frutally.salesmans (registration_number, salesman_name, commission_rate, admission, vacation, neighborhood)
    FROM '/tmp/pgdata/4010_salesmans.csv'
    WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"')
;

COPY frutally.invoices (identification_document, registration_number, sold, invoice_number, taxes)
    FROM '/tmp/pgdata/4010_invoices.csv'
    WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"')
;

COPY frutally.invoice_items (invoice_item_number, product_code, quantity, price)
    FROM '/tmp/pgdata/4010_invoice_items.csv'
    WITH (FORMAT csv, HEADER false, DELIMITER ';', QUOTE '"')
;
