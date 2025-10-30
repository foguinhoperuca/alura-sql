
-- Indice

-- Indice B-TREE

CREATE INDEX idx_codigo_do_produto_btree ON tabela_de_produtos (CODIGO_DO_PRODUTO);

SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = '1';

SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO > '1';

-- Indice HASH

CREATE INDEX idx_cpf_cliente_hash ON tabela_de_clientes USING HASH (CPF);

SELECT * FROM tabela_de_clientes WHERE CPF = '1';

-- Geometric

CREATE INDEX idx_tabela_de_clientes_geo ON tabela_de_clientes_geo USING GIST (geometria);

SELECT cpf, geometria
FROM tabela_de_clientes_geo
WHERE ST_DWithin(
    geometria, -- geometria do cliente
    ST_SetSRID(ST_MakePoint(-43.2096, -22.9035), 4326), -- ponto de referência (longitude, latitude)
    10000 -- distância em metros (10 km)
);

-- SP-GiST

-- BRIN







