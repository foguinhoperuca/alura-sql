
-- Reindexação

REINDEX INDEX idx_bairro;

REINDEX TABLE tabela_de_clientes;

REINDEX SCHEMA public;

-- VACCUM

VACUUM tabela_de_clientes;

VACUUM FULL;

-- ANALYZER

ANALYZE tabela_de_clientes;

-- Indice Parcial

CREATE INDEX idx_bairro_parcial ON tabela_de_clientes (BAIRRO)
WHERE BAIRRO = 'Centro';

-- Indices funcionais

CREATE INDEX idx_nome_lower ON tabela_de_vendedores (LOWER(NOME));

SELECT * FROM tabela_de_vendedores WHERE (LOWER(NOME)) = 'victor';

-- Indice composto

CREATE INDEX idx_bairro_idade ON tabela_de_clientes (IDADE, BAIRRO);

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE IDADE = 30 AND BAIRRO = 'Centro';

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Centro';

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Jardins';











