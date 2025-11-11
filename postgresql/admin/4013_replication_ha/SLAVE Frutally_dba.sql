
-- 2.3

-- Apague todo o conteúdo das tabelas

DELETE FROM itens_notas_fiscais;
DELETE FROM notas_fiscais;
DELETE FROM tabela_de_vendedores;
DELETE FROM tabela_de_clientes;
DELETE FROM tabela_de_produtos;

-- renomeie o arquivo standby.signal paea standby.sign_

CREATE SUBSCRIPTION assinatura_slave
CONNECTION 'host=localhost port=5432 user=frutally_dba dbname=FRUTALLY_VENDAS password=postgres'
PUBLICATION publicacao_master;

SELECT * FROM pg_stat_subscription;

-- Vamos parar e subir o servico novamente limpando os Logs

-- 2.4

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

-- ALTER TABLE tabela_de_vendedores REPLICA IDENTITY FULL;
-- ALTER TABLE tabela_de_clientes REPLICA IDENTITY FULL;
-- ALTER TABLE tabela_de_produtos REPLICA IDENTITY FULL;
-- ALTER TABLE notas_fiscais REPLICA IDENTITY FULL;
-- ALTER TABLE itens_notas_fiscais REPLICA IDENTITY FULL;

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

-- 3.1

CREATE ROLE USUARIOS_GERENCIAIS;

-- 3.3

CREATE USER usuario_gerencial_1 WITH PASSWORD 'postgres';
CREATE USER usuario_gerencial_2 WITH PASSWORD 'postgres';
GRANT USUARIOS_GERENCIAIS TO usuario_gerencial_1;
GRANT USUARIOS_GERENCIAIS TO usuario_gerencial_2;

-- 4.2

GRANT SELECT ON tabela_de_vendedores TO USUARIOS_GERENCIAIS;
GRANT SELECT ON tabela_de_produtos TO USUARIOS_GERENCIAIS;
GRANT SELECT ON tabela_de_clientes TO USUARIOS_GERENCIAIS;
GRANT SELECT ON notas_fiscais TO USUARIOS_GERENCIAIS;
GRANT SELECT ON itens_notas_fiscais TO USUARIOS_GERENCIAIS;

-- 4.3

SELECT * FROM tabela_de_vendedores;

-- usuario_gerencial_1 -- 00235 e 00236
-- usuario_gerencial_2 -- 00237 e 00238

-- Segurança a Nível de Linha (Row-Level Security - RLS)

ALTER TABLE tabela_de_vendedores ENABLE ROW LEVEL SECURITY;

CREATE POLICY vendedor_policy_user1 ON tabela_de_vendedores
  FOR SELECT
  TO usuario_gerencial_1
  USING (MATRICULA IN ('00235', '00236'));

CREATE POLICY vendedor_policy_user2 ON tabela_de_vendedores
  FOR SELECT
  TO usuario_gerencial_2
  USING (MATRICULA IN ('00237', '00238'));

ALTER TABLE tabela_de_vendedores FORCE ROW LEVEL SECURITY;

-- 5.2 

SELECT * FROM tabela_de_vendedores;

-- 5.3

-- 5.3

SELECT tv.MATRICULA, 
       tv.NOME, 
       EXTRACT(YEAR FROM nf.data_venda), 
       TO_CHAR(SUM(inf.quantidade * inf.preco), '999G999G999D99') AS faturamento
FROM notas_fiscais nf
INNER JOIN itens_notas_fiscais inf ON nf.numero = inf.numero
INNER JOIN tabela_de_vendedores tv ON tv.MATRICULA = nf.MATRICULA
WHERE CPF IN (
    SELECT CPF 
    FROM tabela_de_clientes 
    WHERE LIMITE_DE_CREDITO > 5000
)
AND EXTRACT(YEAR FROM nf.data_venda) = 2022
GROUP BY tv.MATRICULA, tv.NOME, EXTRACT(YEAR FROM nf.data_venda);































