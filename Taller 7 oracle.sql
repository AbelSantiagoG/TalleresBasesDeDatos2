ALTER USER INVENTARIO QUOTA UNLIMITED ON USERS;

CREATE TABLE clientes (
    identificacion varchar(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    edad integer NOT NULL,
    correo VARCHAR(20) NOT NULL	
);
CREATE TABLE productos (
    codigo varchar(10) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    stock integer NOT NULL,
    valor_unitario number NOT NULL	
);
CREATE TABLE facturas (
    id varchar(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad integer NOT NULL,
    valor_total FLOAT NOT NULL,
    pedido_estado varchar(9) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')), 
    id_cliente varchar(10) NOT NULL,
    id_producto varchar(10) NOT NULL,
 	FOREIGN KEY (id_cliente) REFERENCES clientes(identificacion),
  	FOREIGN KEY (id_producto) REFERENCES productos(codigo)
);

create or replace procedure verificar_stock()
IS 
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



insert into productos(codigo, nombre, stock, valor_unitario) values ('1234', 'Compota', 15, 1200);
insert into productos(codigo, nombre, stock, valor_unitario) values ('4567', 'Jarabe', 50, 120);
insert into clientes(identificacion, nombre, edad, correo) values ('1091354977', 'Abel Gomez', 19, 'abelsantiago1000gmail.com');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1091354977', '1234');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('2', '2024-12-02', 1, 600, 'PENDIENTE', '1091354977', '4567');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('3', '2024-12-15', 2, 1000, 'BLOQUEADO', '1091354977', '1234');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) values ('4', '2024-01-23', 3, 25000, 'ENTREGADO', '1091354977', '4567');

UPDATE facturas SET pedido_estado = 'PENDIENTE' WHERE id = '1';
