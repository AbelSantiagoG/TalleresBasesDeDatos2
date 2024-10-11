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
	v_intereses_servicio int := 2;
	v_valor_total_servicio numeric;
	v_fecha_pago date;
begin
	
	FOR i IN 1..50 
	LOOP
		v_edad_cliente := FLOOR(RANDOM() * 20) + 1;
		insert into clientes(identificacion, nombre, edad, correo, telefono) values(i, 'Falcao ' || i , v_edad_cliente, 'madarauchiha' || i ||'@gmail.com', '305357502' || i);
		v_monto_servicio := i * 500;
		v_cuota_servicio := i * 10;
		for j IN 1..3
		loop
			v_intereses_servicio := v_intereses_servicio * j;
			v_valor_total_servicio := v_monto_servicio + (v_monto_servicio * (v_intereses_servicio / 100));
			insert into servicios(codigo, tipo, monto, cuota, intereses, valor_total, estado, cliente_id) values (v_id_servicio, 'tipo' || i, v_monto_servicio, v_cuota_servicio, v_intereses_servicio, v_valor_total_servicio, 'NO_PAGO', i);  
			v_id_servicio := v_id_servicio + 1;
			v_intereses_servicio := 2;
		end loop; 
		SELECT DATE '2024-01-01' + INTERVAL '1 day' * FLOOR(RANDOM() * 365) into v_fecha_pago;
		insert into pagos(id, codigo_transaccion, fecha_pago, total, servicio_id) values(i, ''||i, v_fecha_pago, 100, i*2);
	END LOOP;

end;
$$

create or replace function transacciones_total_mes(p_mes date, p_identificacion int)
returns numeric
as $$
declare 
    v_total_transacciones numeric := 0;
    v_id_servicio int;
    v_valor_servicio numeric;
    v_fecha_pago date;
    v_mes date;
begin

    for v_id_servicio in select codigo from servicios where cliente_id = p_identificacion 
    loop
        select total, fecha_pago into v_valor_servicio, v_fecha_pago from pagos where servicio_id = v_id_servicio;
        v_mes := date_trunc('month', v_fecha_pago);
        if v_mes = date_trunc('month', p_mes) then
            v_total_transacciones := v_total_transacciones + v_valor_servicio;
        end if;
    end loop;

    return v_total_transacciones;
end;
$$
language plpgsql;



call fill_db();
select * from clientes;
select * from pagos;
select * from servicios;

select transacciones_total_mes('2024-02-27', 1);
--drop table clientes;
--drop table servicios;
--drop table pagos;
--truncate clientes;