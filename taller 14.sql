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
    
create sequence taller14.numero_fe
	start with 100
	increment by 100;
	

create or replace procedure fill_db()
language plpgsql
as $$
declare
    i integer;
begin
    for i in 1..50 loop
        insert into taller14.usuarios2 (codigo, cliente, producto, descuento, valor_total, numero_fe)
        values (
            nextval('taller14.codigo_usuarios_seq'),  
            'Cliente ' || i, 
            'Producto ' || i,  
            i * 100,  
            i * 5000,  
            nextval('taller14.numero_fe') 
        );
    end loop;
end;
$$;

call fill_db();


