
-- MASTER Postgres

-- 1.2

-- Roteiro do curso
-- Vamos criar um usuário DBA. 
-- Este usuário DBA vai criar replicar a base de dados FRUTALLY_VENDAS. 

-- Depois vamos criar usuários que irão editar a base de dados de 
-- escrita e os que vão ler dados da base de dados de leitura.

-- Implementaremos esta regras usando grupos de usuários e 
-- alguns deles terão privilégios de acesso diferenciados.

-- 1.3

CREATE USER frutally_dba WITH PASSWORD 'postgres';
ALTER USER frutally_dba WITH SUPERUSER;

-- 1.4

SELECT current_user;

