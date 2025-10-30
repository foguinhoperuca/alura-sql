
-- shared_buffers = 4GB  

-- work_mem = 64MB 

-- maintenance_work_mem = 512MB

-- effective_cache_size = 12GB  

-- max_connections = 100

-- VACUUM

VACUUM (VERBOSE);

-- ANALYZE

ANALYZE tabela_de_clientes;

-- REINDEX

  REINDEX TABLE tabela_de_clientes;