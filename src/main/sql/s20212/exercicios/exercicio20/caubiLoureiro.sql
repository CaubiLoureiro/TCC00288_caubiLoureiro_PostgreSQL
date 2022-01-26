DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;


CREATE TABLE empregado(
    nome varchar(30),
    salario int
);

CREATE TABLE emp_auditoria(
    
    cod_usu varchar(30),
    data_alt date,
    nome_ant varchar(30),
    salario_ant int,
    nome_dep varchar(30),
    salario_dep int

);




CREATE OR REPLACE FUNCTION auditoria() RETURNS TRIGGER
AS 
$$

DECLARE
BEGIN

    IF (TG_OP = 'DELETE') THEN
        INSERT INTO emp_auditoria VALUES(user, now(), OLD.nome, OLD.salario, NULL, NULL);
        RETURN OLD;
    ELSEIF(TG_OP = 'UPDATE') THEN
        INSERT INTO emp_auditoria VALUES(user, now(), OLD.nome, OLD.salario, NEW.nome, NEW.salario);
        RETURN NEW;
    ELSEIF(TG_OP = 'INSERT') THEN
        INSERT INTO emp_auditoria VALUES(user, now(), NULL, NULL, NEW.nome, NEW.salario);
        RETURN NEW;
    END IF;

END;
$$ language plpgsql;





CREATE TRIGGER audit
AFTER INSERT OR UPDATE OR DELETE ON empregado
FOR EACH ROW EXECUTE PROCEDURE
auditoria();


INSERT INTO empregado VALUES('Caubi', 1000);

UPDATE empregado SET salario = 5000 WHERE nome = 'Caubi';
SELECT * FROM emp_auditoria;

