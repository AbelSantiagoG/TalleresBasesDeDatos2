CREATE TABLE clientes (
    identificacion int PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    edad INT NOT NULL,
    correo VARCHAR NOT null,
    telefono varchar not NULL
);
create TABLE servicios (
    codigo int PRIMARY KEY,
    tipo varchar not null,
    monto numeric NOT NULL,
    cuota int not null,
    intereses int not null,
    valor_total numeric not null,
    estado varchar CHECK (estado IN ('PAGO', 'NO_PAGO', 'PENDIENTE_PAGO')),
    cliente_id int not null,
    foreign key (cliente_id) references clientes(identificacion)
);
create TABLE pagos (
    id int PRIMARY KEY,
    codigo_transaccion varchar,
    fecha_pago DATE not null,
    total numeric not null,
    servicio_id int not null,
    foreign key (servicio_id) references servicios(codigo)
);

create or replace procedure fill_db()
language plpgsql
as $$
declare 
	v_edad_cliente int;
	i int;
	j int;
	v_id_servicio int := 1;
	v_monto_servicio numeric;
	v_cuota_servicio int;
begin
	
	FOR i IN 1..50 
	LOOP
		v_edad_cliente := FLOOR(RANDOM() * 20) + 1;
		v_monto_servicio := i *500;
		v_cuota_servicio := i * 2;
		insert into clientes(identificacion, nombre, edad, correo, telefono) values(i, 'Falcao ' || i , v_edad_cliente, 'madarauchiha' || i ||'@gmail.com', '305357502' || i);
		for j IN 1..3
			insert into servicios(codigo, tipo, monto, cuota, intereses, valor_total, estado, cliente_id) values (v_id_servicio, 'tipo' || i, v_monto_servicio, v_cuota_servicio, 
			v_id_servicio := v_id_servicio + 1;
		loop
			
		end loop; 
	END LOOP;
		
end;
$$

call fill_db();
select * from clientes;
drop table clientes;
drop table servicios;
drop table pagos;
--truncate clientes;