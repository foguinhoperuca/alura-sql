
-- Remover índices

SELECT
    relname AS table_name,
    indexrelname AS index_name
FROM pg_stat_user_indexes WHERE schemaname = 'public';

-- CREATE INDEX idx_codigo_do_produto_btree ON tabela_de_produtos (CODIGO_DO_PRODUTO);
DROP INDEX idx_codigo_do_produto_btree;
-- CREATE INDEX idx_tabela_de_clientes_geo ON tabela_de_clientes_geo USING GIST (geometria);
DROP INDEX idx_tabela_de_clientes_geo;
-- CREATE INDEX idx_bairro ON tabela_de_clientes (BAIRRO);
DROP INDEX idx_bairro;
-- CREATE INDEX idx_bairro_parcial ON tabela_de_clientes (BAIRRO);
DROP INDEX idx_bairro_parcial;
-- CREATE INDEX idx_nome_lower ON tabela_de_vendedores (LOWER(NOME));
DROP INDEX idx_nome_lower;
-- CREATE INDEX idx_bairro_idade ON tabela_de_clientes (IDADE, BAIRRO);
DROP INDEX idx_bairro_idade;
-- CREATE INDEX idx_cpf_cliente_hash ON tabela_de_clientes USING HASH (CPF);
DROP INDEX idx_cpf_cliente_hash;
-- CREATE INDEX idx_data_venda ON notas_fiscais (DATA_VENDA);
DROP INDEX idx_data_venda;
-- CREATE INDEX idx_nota_fiscal_cpf ON notas_fiscais (CPF);
DROP INDEX idx_nota_fiscal_cpf;

SELECT
    relname AS table_name,
    indexrelname AS index_name
FROM pg_stat_user_indexes WHERE schemaname = 'public';

-- Normalização e Desnormalização

EXPLAIN (ANALYZE, FORMAT JSON) 
	SELECT c.nome, 
	SUM(inf.quantidade * inf.preco) as FATURAMENTO
FROM tabela_de_clientes c
INNER JOIN notas_fiscais nf ON c.CPF = nf.CPF
INNER JOIN itens_notas_fiscais inf ON nf.NUMERO = inf.NUMERO
GROUP BY c.nome;
-- 32302.43

CREATE TABLE notas_fiscais_itens (
  CPF varchar(11) NOT NULL,
  MATRICULA varchar(5) NOT NULL,
  DATA_VENDA date NOT NULL,
  NUMERO serial NOT NULL,
  IMPOSTO real NOT NULL,
  CODIGO_DO_PRODUTO varchar(10) NOT NULL,
  QUANTIDADE int NOT NULL,
  PRECO real NOT NULL
);

INSERT INTO notas_fiscais_itens 
	(CPF, MATRICULA, DATA_VENDA, NUMERO, CODIGO_DO_PRODUTO, QUANTIDADE, PRECO, IMPOSTO)
SELECT 
    nf.CPF, 
    nf.MATRICULA, 
    nf.DATA_VENDA, 
    nf.NUMERO,
    inf.CODIGO_DO_PRODUTO, 
    inf.QUANTIDADE, 
    inf.PRECO,
    nf.IMPOSTO  
FROM 
    notas_fiscais nf
INNER JOIN 
    itens_notas_fiscais inf ON nf.NUMERO = inf.NUMERO;

SELECT * FROM notas_fiscais_itens;

EXPLAIN (ANALYZE, FORMAT JSON) 
	SELECT c.nome, SUM(nfi.quantidade * nfi.preco) as FATURAMENTO
FROM tabela_de_clientes c
INNER JOIN notas_fiscais_itens nfi ON c.CPF = nfi.CPF
GROUP BY c.nome;

-- 31436.07




