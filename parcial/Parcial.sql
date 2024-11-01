create table usuarios(
	id serial primary key,
	nombre varchar,
	direccion varchar,
	email varchar,
	fecha_registro date,
	estado varchar check (estado in('activo', 'inactivo'))
);

create table tarjetas(
	id serial primary key,
	numero_tarjeta varchar,
	fecha_expiracion date,
	cvv int,
	tipo_tarjeta varchar check (tipo_tarjeta in('visa', 'mastercard'))
);

create table productos(
	id int primary key,
	codigo_producto varchar,
	nombre varchar,
	categoria varchar check (categoria in('celular', 'pc', 'televisor')),
	porcentaje_impuesto int,
	precio numeric
);

create table pagos(
	id int primary key,
	codigo_pago varchar,
	fecha date,
	estado varchar check(estado in('exitoso', 'fallido')),
	monto numeric,
	producto_id int,
	tarjeta_id int,
	usuario_id int,
	foreign key (producto_id) references productos(id),
	foreign key (tarjeta_id) references tarjetas(id),
	foreign key (usuario_id) references usuarios(id)
);

create table comprobantes_pago_xml(
	id serial primary key,
	detalle xml
);

create table comprobantes_pago_json(
	id serial primary key,
	detalle jsonb
);

--Primera pregunta
--A
create or replace function obtener_pagos_usuario(p_usuario_id int, p_fecha date)
returns table(t_codigo_pago varchar, t_producto_id int, t_monto numeric, t_estado varchar)
as
$$
declare

begin
		RETURN QUERY
		SELECT codigo_pago, producto_id, monto, estado
		FROM pagos
		WHERE usuario_id = p_usuario_id AND fecha = p_fecha;
end;
$$
language plpgsql;

--B
create or replace function obtener_tarjetas_usuario(p_usuario_id int)
returns table(t_nombre_usuario varchar, t_email varchar, t_numero_tarjeta varchar, t_cvv int, t_tipo_tarjeta varchar)
as
$$
declare
	v_nombre_usuario varchar;
	v_email varchar;
	v_id_tarjeta int;
	v_numero_tarjeta varchar;
	v_cvv int;
	v_tipo_tarjeta varchar;
begin	
	
	select tarjeta_id into v_id_tarjeta from pagos where usuario_id = p_usuario_id;
	--select numero_tarjeta, cvv, tipo_tarjeta into v_numero_tarjeta, v_cvv, v_tipo_tarjeta from tarjetas where id = v_id_tarjeta;
	--select nombre, email into v_nombre_usuario, v_email from usuarios where id = p_usuario_id;

	RETURN QUERY
	select nombre, email  from usuarios where id = p_usuario_id;
	select numero_tarjeta, cvv, tipo_tarjeta from tarjetas where id = v_id_tarjeta;

end;
$$
language plpgsql;

--Segunda pregunta
--A
create or replace function obtener_ptarjetas_detalladas(p_usuario_id int)
returns varchar
as
$$
declare
	mi_cursor cursor for select 
begin
		
		
end;
$$
language plpgsql;

--B
create or replace function obtener_ptarjetas_detalladas(p_fecha date)
returns varchar
as
$$
declare
	mi_cursor cursor for select monto, estado, producto_id, usuario_id from pagos where fecha = p_fecha;
	v_monto numeric;
	v_estado varchar;
	v_producto_id int;
	v_usuario_id int;

	v_retorno varchar
begin	
		open mi_cursor;
		loop
			fetch mi_cursor into v_monto, v_estado, v_producto_id, v_usuario_id;
			v_retorno := '' | v_monto | v_estado | v_producto_id | v_usuario_id;
			exit when not found; 
		end loop;
		close mi_cursor;
		return v_retorno;
end;
$$
language plpgsql;

--C
create or replace procedure guardar_xml(datos xml)
as
$$
declare
	
begin	
		insert into comprobantes_pago_xml(detalle) values(datos);
end;
$$
language plpgsql;

--D 
create or replace procedure guardar_json(datos jsonb)
as
$$
declare
	
begin	
		insert into comprobantes_pago_json(detalle) values(datos);
end;
$$
language plpgsql;

--Pregunta 3
--A
create or replace function validaciones_producto()
returns trigger
as
$$
declare
begin	
		if NEW.precio <= 0 or NEW.precio >= 20000 then
			raise exception 'Precio inválido';
		elsif NEW.porcentaje_impuesto <= 11 or NEW.porcentaje_impuesto > 20 then
			raise exception 'porcentaje inválido';
		end if;
		insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) 
		values(NEW.codigo_producto, NEW.nombre, NEW.categoria, NEW.porcentaje_impuesto, NEW.precio);
		return new;
end;
$$
language plpgsql;

create trigger validaciones_producto
before insert on productos
for each row
execute function validaciones_producto();

--B
create trigger xml_trigger
after insert on comprobantes_pago
for each row
execute function validaciones_producto();

--4 Pregunta
--A
create sequence codigo_producto
start with 5
increment by 5
no maxvalue;

create sequence codigo_pagos
start with 1
increment by 100
no maxvalue;






insert into usuarios(nombre, direccion, email, fecha_registro, estado) values('Abel', 'Buenos Aires', 'abelsantiago100@gmail.com', '2024-10-10', 'activo');
insert into usuarios(nombre, direccion, email, fecha_registro, estado) values('B', 'allá', 'B@gmail.com', '2024-10-10', 'activo');
insert into usuarios(nombre, direccion, email, fecha_registro, estado) values('C', 'acá', 'C@gmail.com', '2024-10-31', 'activo');
insert into usuarios(nombre, direccion, email, fecha_registro, estado) values('D', 'al frente', 'D@gmail.com', '1950-10-10', 'activo');
insert into usuarios(nombre, direccion, email, fecha_registro, estado) values('E', 'atrás', 'E@gmail.com', '2024-01-02', 'activo');

insert into tarjetas(numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values('1234', '2026-12-01', 123, 'visa');
insert into tarjetas(numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values('4321', '2026-12-01', 123, 'mastercard');
insert into tarjetas(numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values('1010', '2026-12-01', 123, 'visa');

insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) values('1234', 'papaya', 'celular', 20, 2000);
insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) values('4321', 'tamarindo', 'televisor', 10, 1000);
insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) values('1111', 'computador hp', 'pc', 30, 3000);

insert into pagos(codigo_pago, fecha, estado, monto, producto_id, tarjeta_id, usuario_id) 
values('1234', '2024-10-10', 'exitoso', 5000, 1, 1, 2);


select obtener_pagos_usuario(2, '2024-10-10');
select obtener_tarjetas_usuario(2);


call guardar_xml('<Pago><codigoPago>"1"</codigoPago><nombreUsuario>"1"</nombreUsuario><numeroTarjeta>"1"</numeroTarjeta><nombreProducto>"1"</nombreProducto><montoPago>"1"</montoPago></Pago>');
call guardar_json(
'{
	"emailUsuario":"a",
	"numeroTarjeta": "b",
	"tipoTarjeta": "c",
	"codigoProducto": "123",
	"codigoPago": "12",
	"montoPago": "15"
}'
);

insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) values('1234', 'papaya', 'celular', 19, 200);

-- Con cursores realizar las siguietnes funciones:
--obtener tarjetas con detalle de usuario parámetro: usuario_id, retornar en un varchar numero_tarjeta, fecha_expiracion, nombre, email
--parámetro: fecha, retornar en un varchar: monto, estado, nombre_producto, porcentaje_impuesto, usuario_direccion, email





















