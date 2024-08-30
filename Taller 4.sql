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

create or replace procedure verificar_stock(
	p_producto_id varchar,
	p_cantidad_compra int
)
language plpgsql
as $$
declare 
	stock_actual int;
begin
	
	select stock into stock_actual from productos where codigo = p_producto_id;

	IF stock_actual < p_cantidad_compra THEN
		RAISE NOTICE 'Stock insuficiente, pedido: % Disponible: %', p_cantidad_compra, stock_actual;
	ELSE
		RAISE NOTICE 'Stock suficiente, pedido: %  Disponible: %', p_cantidad_compra, stock_actual;
	END IF;
end;
$$

create or replace procedure actualizar_estado_pedido(
	p_factura_id varchar,
	p_nuevo_estado varchar
)
language plpgsql
as $$
declare 
	v_estado_actual varchar;
begin
	
	select pedido_estado into v_estado_actual from facturas where id = p_factura_id;

	IF v_estado_actual = 'ENTREGADO' THEN
		RAISE NOTICE 'EL PEDIDO YA FUE ENTREGADO';
	ELSE
		UPDATE facturas SET pedido_estado = p_nuevo_estado WHERE id = p_factura_id;
		RAISE NOTICE 'Estado actualizado';
	END IF;
end;
$$

insert into productos(codigo, nombre, stock, valor_unitario) values ('1234', 'Compota', 15, 1200);
insert into clientes(identificacion, nombre, edad, correo) values ('1091354977', 'Abel Gomez', 19, 'abelsantiago1000gmail.com');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1091354977', '1234');

UPDATE facturas SET pedido_estado = 'PENDIENTE' WHERE id = '1';


call verificar_stock('1234', 100);
call actualizar_estado_pedido('1', 'ENTREGADO');

