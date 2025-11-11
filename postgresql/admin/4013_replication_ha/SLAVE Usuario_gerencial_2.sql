
-- 5.2

SELECT * FROM tabela_de_vendedores;

SELECT current_user;

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