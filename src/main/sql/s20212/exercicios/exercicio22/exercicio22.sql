DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

create table conta_corrente(
    id int primary key,
    abertura timestamp not null,
    encerramento timestamp
);

create table limite_credito(
    conta_corrente int references conta_corrente(id),
    valor float not null,
    inicio timestamp not null,
    fim timestamp
);

create table movimento(
    conta_corrente int references conta_corrente(id),
    "data" timestamp,
    valor float not null,
    primary key (conta_corrente,"data")
);



insert into conta_corrente values(0, CURRENT_TIMESTAMP),
                                    (1, CURRENT_TIMESTAMP);
insert into limite_credito values(0, 500, CURRENT_TIMESTAMP, NULL),
                                 (1, 100, CURRENT_TIMESTAMP, '2021-04-19'::timestamp);



























































