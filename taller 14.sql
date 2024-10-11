create table taller14.usuarios2(
	id serial primary key,
	codigo bigint,
	cliente varchar,
	producto varchar,
	descuento bigint,
	valor_total numeric,
	numero_fe bigint
);

create sequence taller14.codigo_usuarios_seq
	start with 1000
	increment by 1;	


