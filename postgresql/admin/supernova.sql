-- TODO implement database for this formation

-- CREATE SCHEMA and others objects that will be used in all courses
-- Set default permission and by user


/**
 * Before supernova, must have a "universe" with the follow:
 * - users: postgres, sysapps, dba, view_report, dba_person (or any MS AD user that will access by QGIS);
 * - database: any name but must be one in place. Default name will be alura (and variations: alura_prod, alura_stage, dtin_homolog, alura_dev, alura_local) or gis (with same variations);
 * - schema public is already created and must have this tables: qgis_projects and spatial_ref_sys;
 */

\set alura_role `echo "$(echo "$ALURA_SYSTEM_NAME")_app"`
\set alura_db `echo "$DB_DATABASE"`
\set alura_schema `echo "$ALURA_SYSTEM_NAME"`
\set alura_user `echo "$DB_USER"`
\set alura_pwd `echo "$DB_PASS"`


\echo '|-------------------------------------------------|'
\echo '| SHOW SCRIPT VARIABLES                           |'
\echo '|-------------------------------------------------|'
\echo '| alura_role-->' :alura_role
\echo '| alura_db-->' :alura_db
\echo '| alura_schema-->' :alura_schema
\echo '| alura_user -->' :alura_user
\echo '| alura_pwd--> <DO_NOT_SHOW_HERE_ONLY_IF_REAL_NEED>'
\echo '|-------------------------------------------------|'

--
-- Droping/Revoking objects in correct order
--
-- REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM :alura_role;
-- REVOKE ALL PRIVILEGES ON SCHEMA public FROM :alura_role;

DROP SCHEMA IF EXISTS :alura_schema CASCADE;

-- -- TODO implement custom user and role for this formation: frutally
-- REVOKE ALL PRIVILEGES ON DATABASE :alura_db FROM :alura_user;
-- REVOKE ALL PRIVILEGES ON DATABASE :alura_db FROM :alura_role;
-- DROP ROLE IF EXISTS :alura_user;
-- DROP ROLE IF EXISTS :alura_role;
-- --
-- -- Creating and granting
-- --
-- CREATE ROLE :alura_user WITH
--   LOGIN
--   NOSUPERUSER
--   INHERIT
--   NOCREATEDB
--   NOCREATEROLE
--   NOREPLICATION
--   NOBYPASSRLS
--   PASSWORD :'alura_pwd'
-- ;
-- CREATE ROLE :alura_role WITH
--   NOLOGIN
--   NOSUPERUSER
--   INHERIT
--   NOCREATEDB
--   NOCREATEROLE
--   NOREPLICATION
--   NOBYPASSRLS
-- ;
-- GRANT :alura_role, sysalura TO :alura_user;
-- GRANT :alura_role TO alura_dba;
-- GRANT CONNECT ON DATABASE :alura_db TO :alura_user;
-- GRANT CONNECT ON DATABASE :alura_db TO :alura_role;
-- GRANT SELECT, REFERENCES ON TABLE public.qgis_projects TO :alura_role;
-- GRANT SELECT, REFERENCES ON TABLE public.spatial_ref_sys TO :alura_role;

CREATE SCHEMA IF NOT EXISTS :alura_schema AUTHORIZATION :alura_role;
-- TODO create a more complex permission system
-- GRANT ALL ON SCHEMA :alura_schema TO postgres WITH GRANT OPTION;
-- GRANT ALL ON SCHEMA :alura_schema TO dba WITH GRANT OPTION;
-- GRANT ALL ON SCHEMA :alura_schema TO :alura_user;
-- GRANT USAGE ON SCHEMA :alura_schema TO :alura_role;
-- GRANT USAGE ON SCHEMA :alura_schema TO view_report;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT USAGE                                      ON TYPES     TO postgres WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT USAGE                                      ON TYPES     TO dba WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT USAGE                                      ON TYPES     TO alerta_defesa_civil;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT USAGE                                      ON TYPES     TO :alura_role;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON SEQUENCES TO postgres WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON SEQUENCES TO dba WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON SEQUENCES TO alerta_defesa_civil;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON SEQUENCES TO :alura_role;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT SELECT                                     ON SEQUENCES TO view_report;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON TABLES    TO postgres WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON TABLES    TO dba WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT ALL                                        ON TABLES    TO alerta_defesa_civil;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT INSERT, SELECT, UPDATE, DELETE, REFERENCES ON TABLES    TO :alura_role;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT SELECT                                     ON TABLES    TO view_report;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT EXECUTE                                    ON FUNCTIONS TO postgres WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT EXECUTE                                    ON FUNCTIONS TO dba WITH GRANT OPTION;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT EXECUTE                                    ON FUNCTIONS TO alerta_defesa_civil;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA :alura_schema GRANT EXECUTE                                    ON FUNCTIONS TO :alura_role;

GRANT USAGE ON SCHEMA public TO :alura_role;
