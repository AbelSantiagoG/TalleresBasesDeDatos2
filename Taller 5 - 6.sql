CREATE TABLE clientes (
    identificacion varchar PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    edad INT NOT NULL,
    correo VARCHAR NOT NULL	
);
CREATE TABLE productos (
    codigo varchar PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    stock INT NOT NULL,
    valor_unitario float NOT NULL	
);
CREATE TABLE facturas (
    id varchar PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL,
    valor_total FLOAT NOT NULL,
    pedido_estado varchar CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')), 
    id_cliente varchar NOT NULL,
    id_producto varchar NOT NULL,
 	FOREIGN KEY (id_cliente) REFERENCES clientes(identificacion),
  	FOREIGN KEY (id_producto) REFERENCES productos(codigo)
);
create table auditorias(
	id SERIAL primary key,
	fecha_inicio DATE not null,
	fecha_final DATE not null,
	factura_id varchar not null,
	pedido_estado varchar CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO'))
);

create or replace procedure generar_auditoria(
	p_fecha_inicio DATE,
	p_fecha_final DATE
)
language plpgsql
as $$
declare 
	v_factura_id varchar;
	v_pedido_estado varchar;
	v_fecha_factura DATE;
begin
	
	for v_factura_id, v_fecha_factura, v_pedido_estado IN SELECT id, fecha, pedido_estado FROM facturas
	loop
		--if (v_fecha_factura BETWEEN p_fecha_inicio AND p_fecha_final) THEN
			RAISE NOTICE 'SAPA';
			insert into auditorias(id, fecha_inicio, fecha_final, factura_id, pedido_estado) values(default, p_fecha_inicio, p_fecha_final, v_factura_id, v_pedido_estado);
		--end if;
	end loop;
		
end;
$$

create or replace procedure obtener_total_stock()
language plpgsql
as $$
declare 
	v_total_stock integer := 0;
	v_stock_actual integer;
	v_nombre_producto varchar;
begin
	
	for v_stock_actual, v_nombre_producto IN SELECT stock, nombre FROM productos 
	loop
		RAISE NOTICE 'El nombre del producto es: %', v_nombre_producto;
		RAISE NOTICE 'El stock actual del producto es: %', v_stock_actual;
		v_total_stock := v_total_stock + v_stock_actual;
	end loop;
	
	RAISE NOTICE 'La cantidad total de productos es de: %', v_total_stock;
		
end;
$$

create or replace procedure simular_ventas_mes()
language plpgsql
as $$
declare 
	v_dia integer := 1;
	v_identificacion_cliente varchar;
begin
	
	WHILE v_dia <= 30 LOOP
		for v_identificacion_cliente IN SELECT identificacion FROM clientes
		loop
			insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1091354977', '1234');
		end loop;
		v_dia := v_dia + 1;
	END LOOP;
	
		
end;
$$



insert into productos(codigo, nombre, stock, valor_unitario) values ('1234', 'Compota', 15, 1200);
insert into productos(codigo, nombre, stock, valor_unitario) values ('4567', 'Jarabe', 50, 120);
insert into clientes(identificacion, nombre, edad, correo) values ('1091354977', 'Abel Gomez', 19, 'abelsantiago1000gmail.com');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1091354977', '1234');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('2', '2024-12-02', 1, 600, 'PENDIENTE', '1091354977', '4567');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('3', '2024-12-15', 2, 1000, 'BLOQUEADO', '1091354977', '1234');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('4', '2024-01-23', 3, 25000, 'ENTREGADO', '1091354977', '4567');

UPDATE facturas SET pedido_estado = 'PENDIENTE' WHERE id = '1';


call obtener_total_stock();
call generar_auditoria('2024-12-01', '2024-12-31');

select * from auditorias;

-- truncate auditorias ;
x	