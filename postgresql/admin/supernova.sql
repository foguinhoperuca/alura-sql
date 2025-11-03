-- TODO implement database for this formation

-- CREATE SCHEMA and others objects that will be used in all courses
-- Set default permission and by user

-- FIXME define correct level of use here with terraform and big bang.

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

-- DROP SCHEMA IF EXISTS :alura_schema CASCADE;
-- CREATE SCHEMA IF NOT EXISTS :alura_schema AUTHORIZATION :alura_role;

-- TODO implement here all CREATE extension need.
CREATE EXTENSION pg_stat_statements;

