

create or replace function classifica(cod varchar, inicio integer, fim integer) 
returns table(nome TEXT, ponto integer, vitoria integer, derrota integer, empate integer) 
as $$

declare
    
    nome TEXT;
    ponto integer;
    vitoria integer;
    derrota integer;
    empate integer;
    
    nomeTime CURSOR(cod varchar) FOR select sigla FROM time_ WHERE sigla IN
                                          (select time1 FROM jogo WHERE campeonato = cod) or 
                                          (select time2 FROM jogo WHERE campeonato = cod);

begin

    CREATE TABLE TEMPORARY classif (nome TEXT, ponto integer, vitoria integer, derrota integer, empate integer);


    for iniciais IN nomeTime(cod) loop
        select count(*) from jogo where (iniciais = time1 and gols1 > gols2) or (iniciais = time2 and gols2>gols2)
        into vitoria;

        select count(*) from jogo where (iniciais = time1 or iniciais = time2) and (gols1 = gols2)
        into empate;

        select count(*) from jogo where(iniciais = time1 and gols1<gols2) or (iniciais = time2 and gols2<gols1)
        into derrota;

        ponto := 3*vitoria + empate;

        insert into classif values(iniciais, ponto, vitoria, derrota, empate);

    end loop;

    
    return select * from classif order by(ponto, vitoria) limit inicio offset fim;

  

end;

$$
language plpgsql;










