-- TODO (define as global var in forge) Default name will be dtin (and variations: dtin_prod, dtin_stage, dtin_homolog, dtin_dev, dtin_local) or gis (with same variations);

\echo '--------------------------- BEFORE terraform.sql :: Put all customization bellow ---------------------------'
\i :forgesys_path/forge/terraform.sql
\echo '--------------------------- AFTER terraform.sql :: Put all customization above   ---------------------------'
