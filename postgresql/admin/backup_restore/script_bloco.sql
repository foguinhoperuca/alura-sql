
SELECT * FROM notas_fiscais;
SELECT MAX(numero) FROM notas_fiscais;
-- 
SELECT MAX(data_venda) FROM notas_fiscais;
-- 

DO $$
DECLARE
    data_venda_var date := '2023-01-01';
    numero_referencia int := 205651;
    novo_numero_1 int := 205652;
    novo_numero_2 int := 205653;
    novo_numero_3 int := 205654;
BEGIN
    INSERT INTO public.notas_fiscais
    SELECT cpf, matricula, data_venda_var, novo_numero_1, imposto 
    FROM notas_fiscais 
    WHERE numero = numero_referencia;

    INSERT INTO public.itens_notas_fiscais
    SELECT novo_numero_1, codigo_do_produto, quantidade, preco
    FROM itens_notas_fiscais 
    WHERE numero = numero_referencia;

    INSERT INTO public.notas_fiscais
    SELECT cpf, matricula, data_venda_var, novo_numero_2, imposto 
    FROM notas_fiscais 
    WHERE numero = numero_referencia;

    INSERT INTO public.itens_notas_fiscais
    SELECT novo_numero_2, codigo_do_produto, quantidade, preco
    FROM itens_notas_fiscais 
    WHERE numero = numero_referencia;

    INSERT INTO public.notas_fiscais
    SELECT cpf, matricula, data_venda_var, novo_numero_3, imposto 
    FROM notas_fiscais 
    WHERE numero = numero_referencia;

    INSERT INTO public.itens_notas_fiscais
    SELECT novo_numero_3, codigo_do_produto, quantidade, preco
    FROM itens_notas_fiscais 
    WHERE numero = numero_referencia;

    CHECKPOINT;
    PERFORM pg_switch_wal();
END $$;
