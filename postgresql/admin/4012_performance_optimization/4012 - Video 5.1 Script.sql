SELECT 
    con.constraint_name,
    con.constraint_type,
    con.table_name,
    col.column_name
FROM 
    information_schema.table_constraints con
JOIN 
    information_schema.constraint_column_usage col 
ON 
    con.constraint_name = col.constraint_name
WHERE 
    con.constraint_schema = 'public'
ORDER BY 
    con.table_name, con.constraint_type;

-- Comandos para reverter modificações da base de dados

ALTER TABLE tabela_de_produtos
DROP CONSTRAINT IF EXISTS tabela_de_produtos_pkey;

-- ALTER TABLE notas_fiscais
-- DROP CONSTRAINT IF EXISTS fk_notas_fiscais_cpf;

ALTER TABLE itens_notas_fiscais
DROP COLUMN IF EXISTS QUANTIDADE_REAL;

ALTER TABLE notas_fiscais
DROP CONSTRAINT IF EXISTS UK_NUMERO_UNICO;

ALTER TABLE notas_fiscais
DROP COLUMN IF EXISTS NUMERO_UNICO;

DROP TABLE notas_fiscais_part;

ALTER TABLE tabela_de_clientes
DROP CONSTRAINT IF EXISTS unique_cpf;

SELECT
    relname AS table_name,
    indexrelname AS index_name
FROM pg_stat_user_indexes WHERE schemaname = 'public';

-- Consulta

EXPLAIN (ANALYZE, FORMAT JSON) SELECT 
    c.NOME AS nome_cliente, c.CPF, c.CIDADE, v.NOME AS nome_vendedor, v.MATRICULA,
    p.NOME_DO_PRODUTO, p.EMBALAGEM, p.PRECO_DE_LISTA, n.DATA_VENDA,
    n.IMPOSTO, i.QUANTIDADE, i.PRECO, (i.QUANTIDADE * i.PRECO) AS valor_venda,
    ((i.QUANTIDADE * i.PRECO) * (1 + n.IMPOSTO / 100)) AS valor_com_imposto
FROM itens_notas_fiscais i
JOIN notas_fiscais n ON i.NUMERO = n.NUMERO
JOIN tabela_de_produtos p ON i.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
JOIN tabela_de_clientes c ON n.CPF = c.CPF
JOIN tabela_de_vendedores v ON n.MATRICULA = v.MATRICULA
WHERE 
    (n.DATA_VENDA BETWEEN '2020-01-01' AND '2023-12-31')  
    AND c.CIDADE IS NOT NULL                             
    AND c.IDADE > 18                                       
    AND p.PRECO_DE_LISTA > 2.3                               
    AND v.DE_FERIAS = false;  

-- 26756.53

    
