create table tipo_contrato(
	id varchar primary key,
	descripcion varchar,
	cargo varchar,
	salario_total numeric
);
CREATE TABLE empleados (
	identificacion varchar primary key,
	nombre varchar,
	tipo_contrato_id varchar,
	foreign key(tipo_contrato_id) references tipo_contrato(id)
);
create table conceptos(
	codigo varchar primary key,
	nombre varchar CHECK (nombre IN ('salario', 'horas_extras', 'prestaciones', 'impuestos')),
	porcentaje int
);
CREATE TABLE nominas (
	id varchar primary key,
	mes int,
	ano int,
	fecha_pago date,
	total_devengado numeric,
	total_deducciones numeric,
	total numeric,
	cliente_id varchar,
	foreign key(cliente_id) references empleados(identificacion)
);
CREATE TABLE detalles_nomina (
	id varchar primary key,
	concepto_id varchar,
	valor numeric,
	nomina_id varchar,
	foreign key(concepto_id) references conceptos(codigo),
	foreign key(nomina_id) references tipo_contrato(id)
);


create or replace procedure poblar_base()
language plpgsql
as $$
declare 
	v_edad_cliente int;
	i int;
	v_valor_unitario_producto int;
	v_valor_total_producto int;
	v_cantidad_producto int;
	v_id_random int;
begin

	FOR i IN 1..50 
	LOOP
		v_edad_cliente := FLOOR(RANDOM() * 20) + 1;
		insert into usuarios(id, identificacion, nombre, edad, correo) values(i, 'identificacion' || i,  'Falcao ' || i , v_edad_cliente, 'madarauchiha' || i ||'@gmail.com');
	END LOOP;
	
	FOR i IN 1..25
	LOOP
		v_cantidad_producto := FLOOR(RANDOM() * 20) + 1;
		v_valor_unitario_producto := FLOOR(RANDOM() * (5000 - 500 + 1)) + 500;
		v_valor_total_producto := v_cantidad_producto * v_valor_unitario_producto;
		v_id_random := FLOOR(RANDOM() * 50) +1;
		insert into facturas(id, fecha, producto, cantidad, valor_unitario, valor_total, usuario_id) values(i, '2024-12-01', 'Arepas' , v_cantidad_producto, v_valor_unitario_producto, v_valor_total_producto, v_id_random);
	END LOOP;

end;
$$