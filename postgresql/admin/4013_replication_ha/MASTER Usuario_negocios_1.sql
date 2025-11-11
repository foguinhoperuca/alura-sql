
-- 5.1

SELECT current_user;

SELECT tv.MATRICULA, tv.NOME, EXTRACT(YEAR FROM data_venda), 
	SUM(inf.quantidade * inf.preco) AS faturamento
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais inf
ON NF.numero = INF.numero
INNER JOIN tabela_de_vendedores tv
ON tv.MATRICULA = nf.MATRICULA
WHERE CPF IN (SELECT CPF FROM tabela_de_clientes WHERE LIMITE_DE_CREDITO > 5000)
AND EXTRACT(YEAR FROM data_venda) = 2022
GROUP BY tv.MATRICULA, tv.NOME, EXTRACT(YEAR FROM data_venda);

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

SELECT MAX(NUMERO) FROM notas_fiscais;

INSERT INTO notas_fiscais VALUES ('1234567890', '00235','2022-01-01', '205652', 10);
INSERT INTO itens_notas_fiscais VALUES ('205652', '1000889', 10000000, 1);
INSERT INTO notas_fiscais VALUES ('1234567890', '00236','2022-01-01', '205653', 10);
INSERT INTO itens_notas_fiscais VALUES ('205653', '1000889', 10000000, 1);
INSERT INTO notas_fiscais VALUES ('1234567890', '00237','2022-01-01', '205654', 10);
INSERT INTO itens_notas_fiscais VALUES ('205654', '1000889', 10000000, 1);
INSERT INTO notas_fiscais VALUES ('1234567890', '00238','2022-01-01', '205655', 10);
INSERT INTO itens_notas_fiscais VALUES ('205655', '1000889', 10000000, 1);

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


