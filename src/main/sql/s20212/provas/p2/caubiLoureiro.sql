DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

CREATE TABLE Atividade(
    id INT,
    nome VARCHAR);

CREATE TABLE Artista(
    id INT,
    nome VARCHAR,
    rua VARCHAR,
    cidade VARCHAR,
    estado VARCHAR,
    cep VARCHAR,
    atividade INT);

CREATE TABLE Arena(
    id INT,
    nome VARCHAR,
    cidade VARCHAR,
    capacidade INT);

CREATE TABLE Concerto(
    id INT,
    artista INT,
    arena INT,
    inicio TIMESTAMP,
    fim TIMESTAMP,
    preco FLOAT);


INSERT INTO Atividade values (1, 'cantor');
INSERT INTO Atividade values (2, 'guitarrista');
INSERT INTO Atividade values (3, 'pianista');
INSERT INTO Artista values (1, 'Axl Rose','Rua das Flores','Rio de Janeiro','Rio de Janeiro','26600000', 1);
INSERT INTO Artista values (2, 'Slash','Rua das Neves','São Paulo','São Paulo','26626000', 2);
INSERT INTO Artista values (3, 'Chopin', 'Rua das Flores','Rio de Janeiro', 'Rio de Janeiro', '26600000', 2);
INSERT INTO Arena values (1, 'Arena - UFF', 'Rio de Janeiro', 12);
INSERT INTO Arena values (2, 'Maracanã', 'Rio de Janeiro', 10);
INSERT INTO Arena values (3, 'Vivo Rio', 'Rio de Janeiro', 20);



CREATE OR REPLACE FUNCTION Unicidade() RETURNS TRIGGER AS $$
declare
begin
    
    IF EXISTS (SELECT * FROM Concerto
                WHERE concerto.id != new.id AND
                (concerto.arena = new.arena OR concerto.artista = new.artista) AND
                (concerto.inicio BETWEEN new.inicio AND new.fim or concerto.fim BETWEEN new.inicio and new.fim)) THEN
        raise exception 'ARENAS E ARTISTA JÁ ESTÃO OCUPADOS NESSE HORARIO.';
    END IF;

    return NEW;
end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION VerificaQtdAtividade() RETURNS TRIGGER AS $$
declare
    contador int;
    indice record;
begin
    
    FOR indice in SELECT DISTINCT * FROM TabelaTemp LOOP

        Select count(*) from Artista WHERE atividade = indice.id INTO contador;
        IF contador = 0 THEN
            raise exception 'ATIVIDADE SEM ARTISTA!';
        END IF;

    END LOOP;

    return NULL;
end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION RegistrosArtistaAnt() RETURNS TRIGGER AS $$
declare
begin
    INSERT INTO TabelaTemp values(old.atividade);
    return null;
end;
$$ language plpgsql;




CREATE OR REPLACE FUNCTION CriaTempFunction() RETURNS TRIGGER AS $$
declare
begin
    create temp table TabelaTemp(id int) on commit drop;
    return null;
end;
$$ language plpgsql;



CREATE TRIGGER Unicidade
AFTER INSERT OR UPDATE ON Concerto FOR EACH ROW
EXECUTE PROCEDURE Unicidade();



CREATE TRIGGER CriaTemp
BEFORE UPDATE OR DELETE ON Artista FOR EACH STATEMENT
EXECUTE PROCEDURE CriaTempFunction();




CREATE TRIGGER RegistrosArtistaAnt
AFTER UPDATE OR DELETE ON Artista FOR EACH ROW
EXECUTE PROCEDURE RegistrosArtistaAnt();




CREATE TRIGGER VerificaQtdAtividade
AFTER UPDATE OR DELETE ON Artista FOR EACH STATEMENT
EXECUTE PROCEDURE VerificaQtdAtividade();









-- -- Problema da atividade vazia:
--DELETE FROM Artista WHERE id = 1;
--UPDATE Artista set atividade = 2 WHERE id = 1;

-- Arenas ocupadas
--INSERT INTO Concerto values (1, 1, 1, '2030-01-26 01:00:00', '2030-01-26 05:10:00', 1000);
--INSERT INTO Concerto values (2, 1, 2, '2030-01-26 01:00:00', '2030-01-26 05:05:00', 2000);

-- Artistas ocupados
-- INSERT INTO Concerto values (1, 1, 1, '2030-01-26 01:00:00', '2030-01-26 04:10:00');
-- INSERT INTO Concerto values (2, 2, 1, '2030-01-26 01:00:00', '2020-01-26 04:05:00');

-- -- Horários ocupados
--INSERT INTO Concerto values (1, 1, 1, '2030-01-26 01:00:00', '2030-01-26 05:10:00');
--INSERT INTO Concerto values (2, 2, 1, '2030-01-26 01:00:00', '2030-01-26 05:05:00');
--INSERT INTO Concerto values (3, 3, 1, '2030-01-26 01:00:00', '2020-11-10 05:30:00');
