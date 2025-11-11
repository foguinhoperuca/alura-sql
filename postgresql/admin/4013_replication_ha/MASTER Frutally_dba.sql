
-- MASTER Frutally_dba

-- 1.4

SELECT current_user;

-- 2.1

-- wal_level = logical
-- max_wal_senders = 5
-- max_replication_slots = 10
-- listen_addresses = '*'

-- 2.2

-- C:\Program Files\PostgreSQL\16\data_slave
-- pg_basebackup -D "C:\Program Files\PostgreSQL\16\data_slave" -Fp -Xs -P -R -h localhost -U frutally_dba
-- port = 5433
-- max_logical_replication_workers = 5
-- max_worker_processes = 10
-- wal_level = replica - remover
-- pg_ctl register -N "postgresql-slave" -D "C:\Program Files\PostgreSQL\16\data_slave" -S auto
-- Pare o serviço da MASTER
-- host replication frutally_dba 127.0.0.1/32 md5 na pg_hba.conf
-- Reinicie a MASTER

-- 2.3

-- Subir o serviço da SLAVE.
-- Criar a publicação

CREATE PUBLICATION publicacao_master
FOR ALL TABLES;

SELECT * FROM pg_publication;
SELECT * FROM pg_publication_tables WHERE pubname = 'publicacao_master';

-- Vamos parar e subir o servico novamente limpando os Logs

-- 2.4

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

INSERT INTO tabela_de_vendedores (MATRICULA, NOME, PERCENTUAL_COMISSAO, DATA_ADMISSAO, DE_FERIAS, BAIRRO)
VALUES ('00239', 'João da Silva', 0.05, '2021-06-01', FALSE, 'Centro');

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

UPDATE tabela_de_vendedores SET bairro = 'Jardins';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

-- ALTER TABLE tabela_de_vendedores REPLICA IDENTITY DEFAULT;
-- ALTER TABLE tabela_de_clientes REPLICA IDENTITY DEFAULT;
-- ALTER TABLE tabela_de_produtos REPLICA IDENTITY DEFAULT;
-- ALTER TABLE notas_fiscais REPLICA IDENTITY DEFAULT;
-- ALTER TABLE itens_notas_fiscais REPLICA IDENTITY DEFAULT;

-- ALTER TABLE tabela_de_vendedores REPLICA IDENTITY FULL;
-- ALTER TABLE tabela_de_clientes REPLICA IDENTITY FULL;
-- ALTER TABLE tabela_de_produtos REPLICA IDENTITY FULL;
-- ALTER TABLE notas_fiscais REPLICA IDENTITY FULL;
-- ALTER TABLE itens_notas_fiscais REPLICA IDENTITY FULL;

-- ALTER TABLE <TABELA> REPLICA IDENTITY DEFAULT; - Caso chave primária

DELETE FROM tabela_de_vendedores WHERE MATRICULA = '00239';

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00239';

-- 3.1

-- USUARIOS_NEGOCIOS - Vão poder ler e escrever na MASTER
-- USUARIOS_GERENCIAIS - Vão poder apenas ler na SLAVE

CREATE ROLE USUARIOS_NEGOCIOS;

-- 3.2

CREATE USER usuario_negocios_1 WITH PASSWORD 'postgres';
GRANT USUARIOS_NEGOCIOS TO usuario_negocios_1;

-- 4.1

GRANT SELECT, INSERT, UPDATE, DELETE ON tabela_de_vendedores TO USUARIOS_NEGOCIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON tabela_de_produtos TO USUARIOS_NEGOCIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON tabela_de_clientes TO USUARIOS_NEGOCIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON notas_fiscais TO USUARIOS_NEGOCIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON itens_notas_fiscais TO USUARIOS_NEGOCIOS;

-- 5.1

-- usuario_negocios_1
-- acessar o ambiente MASTER 
-- incluir/alterar/excluir dados do ambiente MASTER
-- não acesse o ambiente SLAVE
-- ele NÃO PODE incluir/alterar/excluir no ambiente SLAVE

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

