create or replace function fatorial(integer) returns integer as
$$

declare
    contador integer;
    fatorial integer;
    parador integer;
begin
    parador := $1;
    contador := 1;
    fatorial := 1;
    for i in 1..$1 loop
        fatorial := fatorial * i;

    end loop;
    
    return fatorial;

end


$$
language plpgsql


select fatorial(2);