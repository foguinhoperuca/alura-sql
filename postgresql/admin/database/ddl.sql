DO $$
DECLARE
    i INTEGER;
    new_identification_number VARCHAR(16);
    new_basename TEXT := 'Client Generated ';
    pool_addresses TEXT[] := ARRAY['Street Alfa', 'Street Beta', 'Street Gamma', 'Street Delta', 'Street Epilson'];
    pool_neighborhood TEXT[] := ARRAY['Center', 'Country-Side', 'Main Avenue', 'Commercial District', 'Suburbia'];
    pool_cities TEXT[] := ARRAY['Sorocaba', 'São Paulo', 'Rio de Janeiro', 'Brasília', 'Belo Horizonte', 'Salvador'];
    pool_states TEXT[] := ARRAY['SP', 'RJ', 'DF', 'MG', 'BA'];
    pool_zip_codes TEXT[] := ARRAY['20000000', '80012212', '22000000', '88192029', '21002020'];
    new_birthday DATE;
    new_age SMALLINT;
    new_gender CHAR(1);
    new_credit_limit NUMERIC;
    new_purchase_volume NUMERIC;
    new_first_time_buying BOOLEAN;
BEGIN
    FOR i IN 1..20000 LOOP
        new_identification_number := LPAD(CAST(FLOOR(RANDOM() * 1e11)::BIGINT AS TEXT), 11, '0');
        new_birthday := DATE '1970-01-01' + (FLOOR(RANDOM() * 15000) * '1 day'::INTERVAL);
        new_age := EXTRACT(YEAR FROM AGE(new_birthday));
        new_gender := CASE WHEN RANDOM() > 0.5 THEN 'M' ELSE 'F' END;
        new_credit_limit := ROUND((RANDOM() * 100000 + 50000)::NUMERIC, 2);
        new_purchase_volume := ROUND((RANDOM() * 50000 + 1000)::NUMERIC, 2);
        new_first_time_buying := CASE WHEN RANDOM() > 0.5 THEN TRUE ELSE FALSE END;

        INSERT INTO frutally.customers (identification_document, customer_name, address_line_one, address_line_two, neighborhood, city, state, zip_code, birthday, age, gender, credit_limit, purchase_volume, first_time_buying) VALUES (
            new_identification_number,
            new_basename || i,
            pool_addresses[FLOOR(RANDOM() * ARRAY_LENGTH(pool_addresses, 1) + 1)],
            '',
            pool_neighborhood[FLOOR(RANDOM() * ARRAY_LENGTH(pool_neighborhood, 1) + 1)],
            pool_cities[FLOOR(RANDOM() * ARRAY_LENGTH(pool_cities, 1) + 1)],
            pool_states[FLOOR(RANDOM() * ARRAY_LENGTH(pool_states, 1) + 1)],
            pool_zip_codes[FLOOR(RANDOM() * ARRAY_LENGTH(pool_zip_codes, 1) + 1)],
            new_birthday,
            0, -- not using new_age var
            new_gender,
            new_credit_limit,
            new_purchase_volume,
            new_first_time_buying
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INTEGER;
    new_product_code VARCHAR(7);
    new_product_name TEXT;
    new_basename TEXT := 'Product Generated ';
    new_packaging TEXT;
    new_product_size TEXT;
    new_flavor TEXT;
    new_list_price REAL;
    pool_packagings TEXT[] := ARRAY['Bottle', 'PET', 'Can'];
    pool_product_sizes TEXT[] := ARRAY['350 ml', '470 ml', '700 ml', '1 Lt', '1,5 Lt', '2 Lt'];
    pool_flavors TEXT[] := ARRAY['Grape', 'Lima/Lemmon', 'Cherry/Apple', 'Watermelon', 'Açai', 'Orange', 'Strawberry', 'Passion Fruit', 'Apple'];
BEGIN
    FOR i IN 1..20000 LOOP
        new_product_code := LPAD(CAST(FLOOR(RANDOM() * 1e7)::BIGINT AS TEXT), 7, '0');
        WHILE EXISTS (SELECT 1 FROM frutally.products WHERE code = new_product_code) LOOP
            new_product_code := LPAD(CAST(FLOOR(RANDOM() * 1e7)::BIGINT AS TEXT), 7, '0');
        END LOOP;
        new_product_name := new_basename || new_product_code || ' - '  || pool_flavors[FLOOR(RANDOM() * ARRAY_LENGTH(pool_flavors, 1) + 1)];
        new_packaging := pool_packagings[FLOOR(RANDOM() * ARRAY_LENGTH(pool_packagings, 1) + 1)];
        new_product_size := pool_product_sizes[FLOOR(RANDOM() * ARRAY_LENGTH(pool_product_sizes, 1) + 1)];
        new_flavor := pool_flavors[FLOOR(RANDOM() * ARRAY_LENGTH(pool_flavors, 1) + 1)];
        new_packaging := pool_packagings[FLOOR(RANDOM() * ARRAY_LENGTH(pool_packagings, 1) + 1)];
        new_list_price := ROUND((RANDOM() * 50 + 2)::NUMERIC, 2);

        INSERT INTO frutally.products(code, product_name, packaging, product_size, flavor, list_price) VALUES (
            new_product_code,
            new_product_name,
            new_packaging,
            new_product_size,
            new_flavor,
            new_list_price
        );
    END LOOP;
END $$;
