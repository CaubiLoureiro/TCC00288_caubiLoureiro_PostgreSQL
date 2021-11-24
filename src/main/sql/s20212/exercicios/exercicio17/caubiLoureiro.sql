
DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;


CREATE TABLE produto(
    codigo VARCHAR,
    descricao VARCHAR,
    preco FLOAT
);

INSERT INTO produto VALUES  (1,'MacBookPro 2021', 20000),
                            (2,'MacBookAir 2021', 17000),
                            (3,'Avell A62', 8000),
                            (4,'DELL G3', 6500),
                            (5,'Positivo Motion', 50);



CREATE OR REPLACE FUNCTION total(p_produtos VARCHAR[], p_qtds INTEGER[]) RETURNS REAL 
AS
$$

DECLARE

    pedidos RECORD;
    valor REAL := 0;
    
    
   
BEGIN

    FOR pedidos IN (SELECT t.* FROM unnest(p_produtos, p_qtds) as t(codigoP,qtdP)) LOOP
       
        valor := valor + ((SELECT preco FROM produto WHERE (produto.codigo = pedidos.codigoP)) * pedidos.qtdP);


    END LOOP;
    
    RETURN valor;


END;

$$ LANGUAGE plpgsql;




SELECT total('{"1", "2", "3"}', '{1, 2, 3}');



