
-- Plano de execução

-- Eficiência de Consulta

-- Diagnóstico de Problemas de Desempenho

-- Otimização de Consultas

-- Gerando o plano de execução

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Centro';

-- Copie e cole o plano de execução.
-- crie o indice

CREATE INDEX idx_bairro ON tabela_de_clientes (BAIRRO);

EXPLAIN ANALYZE SELECT * FROM tabela_de_clientes WHERE BAIRRO = 'Centro';