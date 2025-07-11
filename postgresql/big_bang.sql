-- TODO implement basic instalation for all courses

DROP USER IF EXISTS 'alura'@'%';
CREATE USER 'alura'@'%' IDENTIFIED BY '<MY_SECRET_PASSOWRD_HERE>';

-- ALSO create database alura


REVOKE ALL PRIVILEGES ON DATABASE :alura_db FROM :alura_user;
REVOKE ALL PRIVILEGES ON DATABASE :alura_db FROM :alura_role;

DROP ROLE IF EXISTS :alura_role;
DROP ROLE IF EXISTS :alura_user;

--
-- Creating and granting
--
CREATE ROLE :alura_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  PASSWORD :'alura_pwd'
;
CREATE ROLE :alura_role WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
;


GRANT :alura_role, syspms TO :alura_user;
GRANT :alura_role TO alura_Manager;

GRANT CONNECT ON DATABASE :alura_db TO :alura_user;
GRANT CONNECT ON DATABASE :alura_db TO :alura_role;
GRANT USAGE ON SCHEMA public TO :alura_role;
GRANT SELECT, REFERENCES ON TABLE public.qgis_projects TO :alura_role;
