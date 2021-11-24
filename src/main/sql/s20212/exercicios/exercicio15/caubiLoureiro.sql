
DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

CREATE TABLE cliente (
    cpf integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (cpf)
);

CREATE TABLE conta (
    agencia integer NOT NULL,
    numero integer NOT NULL,
    cliente integer NOT NULL,
    saldo real NOT NULL default 0,
    CONSTRAINT conta_pk PRIMARY KEY
    (agencia,numero),
    CONSTRAINT cliente_fk FOREIGN KEY
    (cliente) REFERENCES cliente (cpf)
);

CREATE TABLE movimentacao (
    agencia integer NOT NULL,
    conta integer NOT NULL,
    data_hora timestamp NOT NULL default
    current_timestamp,
    valor real NOT NULL,
    descricao character varying NOT NULL,
    CONSTRAINT mov_pk PRIMARY KEY
    (conta,agencia,data_hora),
    CONSTRAINT conta_fk FOREIGN KEY
    (agencia,conta) REFERENCES conta
    (agencia,numero)
);


INSERT INTO cliente VALUES(1, 'Joao'),
                          (2, 'Pedro');
INSERT INTO conta VALUES(1, 1, 1),
                        (1, 2, 1),
                        (2, 1, 1),
                        (2, 2, 2);
INSERT INTO movimentacao VALUES (1, 1, '2021-02-27 04:00:00', 1000, 'Entrada'),
                                (1, 1, '2021-02-27 05:00:00', 500, 'Saida'),
                                (1, 2, '2021-02-27 06:00:00', 200, 'Entrada'),
                                (2, 1, '2021-02-27 07:00:00', 1500, 'Entrada'),
                                (2, 1, '2021-02-27 08:00:00', 200, 'Entrada'),
                                (2, 2, '2021-02-27 09:00:00', 75, 'Entrada'),
                                (2, 2, '2021-02-27 10:00:00', 750, 'Saida');


CREATE OR REPLACE FUNCTION atualizar() RETURNS VOID 
AS 
$$


DECLARE
    
    contas CURSOR FOR SELECT * FROM conta;



    movimentacoes CURSOR FOR SELECT agencia, conta, valor, descricao FROM movimentacao;  

    novoSaldo real;





BEGIN

    FOR cont IN contas LOOP
        novoSaldo := cont.saldo;
        FOR transacao IN movimentacoes LOOP

            IF(transacao.agencia = cont.agencia AND transacao.conta = cont.numero)THEN


                IF(transacao.descricao = 'Entrada') THEN
                    novoSaldo := novoSaldo + transacao.valor;
                   
                ELSE
                    novoSaldo := novoSaldo - transacao.valor;
                    
                END IF;

            END IF;
  
        END LOOP;

        UPDATE conta SET saldo = novoSaldo WHERE (conta.agencia = cont.agencia AND conta.numero = cont.numero);


    END LOOP;

    

END;

$$ LANGUAGE plpgsql;



SELECT * FROM conta;

SELECT atualizar();

SELECT * FROM conta;


