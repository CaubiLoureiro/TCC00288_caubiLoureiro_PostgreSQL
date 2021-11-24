DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

CREATE TABLE bairro (
	bairro_id integer NOT NULL,
	nome character varying NOT NULL,
	CONSTRAINT bairro_pk
        PRIMARY KEY(bairro_id));
	
CREATE TABLE municipio (
	municipio_id integer NOT NULL,
	nome character varying NOT NULL,
	CONSTRAINT municipio_pk
	PRIMARY KEY(municipio_id));
	
CREATE TABLE antena (
	antena_id integer NOT NULL,
	bairro_id integer NOT NULL,
	municipio_id integer NOT NULL,
	CONSTRAINT antena_pk
	PRIMARY KEY(antena_id),
	CONSTRAINT bairro_fk
	FOREIGN KEY(bairro_id)
	REFERENCES bairro (bairro_id),
	CONSTRAINT municipio_fk
	FOREIGN KEY (municipio_id)
	REFERENCES municipio (municipio_id));
	
CREATE TABLE ligacao (
	ligacao_id bigint NOT NULL,
	numero_orig bigint NOT NULL,
	numero_dest bigint NOT NULL,
	antena_orig integer NOT NULL,
	antena_dest integer NOT NULL,
	inicio timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fim timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT ligacao_pk
	PRIMARY KEY(ligacao_id),
	CONSTRAINT antena_orig_fk
	FOREIGN KEY(antena_orig)
	REFERENCES antena (antena_id),
	CONSTRAINT antena_dest_fk
	FOREIGN KEY(antena_dest)
	REFERENCES antena (antena_id));

INSERT INTO bairro VALUES(1, 'Méier'),
			(2, 'Barra da Tijuca'),
			(3, 'Nova Cidade'),
			(4, 'Venda das Pedras');

INSERT INTO municipio VALUES(1, 'Rio de Janeiro'),
                            (2, 'Itaboraí');

INSERT INTO antena VALUES(1, 1, 1),
                        (2, 2, 1),
                        (3, 3, 2),
                        (4, 3, 2),
                        (5, 4, 2);

INSERT INTO ligacao VALUES(1, 21966755666, 219644558840, 1, 1, '2021-02-23 04:00:00', '2021-02-23 04:10:00'),
                        (2, 21996605402, 2126453158, 1, 2, '2021-02-23 04:00:00', '2021-02-23 04:15:00'),
                        (3, 21966755666, 219644558840, 1, 3, '2021-02-23 04:00:00', '2021-02-23 04:20:00'),
                        (4, 21940028922, 219644558840, 1, 4, '2021-02-23 04:00:00', '2021-02-23 04:25:00'),
                        (5, 21966755666, 219644558840, 2, 1, '2021-02-23 04:00:00', '2021-02-23 04:30:00'),
                        (6, 21966755666, 219644558840, 2, 2, '2021-02-23 04:00:00', '2021-02-23 04:35:00'),
                        (7, 21966755666, 219644558840, 2, 3, '2021-02-23 04:00:00', '2021-02-23 04:40:00'),
                        (8, 21966755666, 219644558840, 2, 4, '2021-02-23 04:00:00', '2021-02-23 04:45:00'),
                        (9, 21966755666, 219644558840, 3, 1, '2021-02-23 04:00:00', '2021-02-23 04:50:00'),
                        (10, 21966755666, 219644558840, 3, 2, '2021-02-23 04:00:00', '2021-02-23 04:55:00'),
                        (11, 21966755666, 219644558840, 3, 3, '2021-02-23 04:00:00', '2021-02-23 05:00:00'),
                        (12, 21966755666, 219644558840, 3, 4, '2021-02-23 04:00:00', '2021-02-23 05:05:00'),
                        (13, 21966755666, 219644558840, 4, 1, '2021-02-23 04:00:00', '2021-02-23 05:10:00'),
                        (14, 21966755666, 219644558840, 4, 2, '2021-02-23 04:00:00', '2021-02-23 05:15:00'),
                        (15, 21966755666, 219644558840, 4, 3, '2021-02-23 04:00:00', '2021-02-23 05:20:00'),
                        (16, 21966755666, 219644558840, 4, 4, '2021-02-23 04:00:00', '2021-02-23 05:25:00');


CREATE OR REPLACE FUNCTION duracao() RETURNS Table(lid_id bigint, tempo TIME)
AS
$$

DECLARE

    regioes CURSOR FOR SELECT
    antena1 RECORD;
    antena2 RECORD;

BEGIN
    CREATE TEMPORARY TABLE lig_reg (ident bigint, lig_inicio timestamp, lig_fim timestamp;
    
    FOR ligacoes IN SELECT * FROM ligacao LOOP
        SELECT bairro_id, municipio_id FROM antena WHERE ligacoes.antena_orig = antena_id INTO antena1;
        SELECT bairro_id, municipio_id FROM antena WHERE ligacoes.antena_dest = antena_id INTO antena2;

        IF (antena1.bairro_id != antena2.bairro_id OR antena1.municipio_id != antena2.municipio_id) THEN
            INSERT INTO lig_reg VALUES(ligacoes.ligacao_id, ligacoes.inicio, ligacoes.fim);
        END IF;
        
      
    END LOOP;
    



END;
$$ LANGUAGE plpgsql;










































