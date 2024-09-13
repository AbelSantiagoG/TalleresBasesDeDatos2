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
    valor_total number NOT NULL,
    pedido_estado varchar(9) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')), 
    id_cliente varchar(10) NOT NULL,
    id_producto varchar(10) NOT NULL,
 	FOREIGN KEY (id_cliente) REFERENCES clientes(identificacion),
  	FOREIGN KEY (id_producto) REFERENCES productos(codigo)
);

create or replace procedure verificar_stock(p_producto varchar(10), p_cantidad_compra integer)
IS 
	v_total_stock integer := 0;
	v_stock_actual integer;
	v_nombre_producto varchar;
BEGIN
	
   	SELECT stock, nombre INTO v_stock_actual, v_nombre_producto FROM productos WHERE codigo = p_producto;
   
	DBMS_OUTPUT.PUT_LINE('El nombre del producto es: ' || v_nombre_producto);
    DBMS_OUTPUT.PUT_LINE('El stock actual del producto es: ' || v_stock_actual);
   
   	IF v_stock_actual >= p_cantidad_compra THEN
        DBMS_OUTPUT.PUT_LINE('Hay suficiente stock para la compra.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No hay suficiente stock para la compra.');
    END IF;
   
end;

-- Insertar en la tabla productos
INSERT INTO productos(codigo, nombre, stock, valor_unitario) VALUES ('1234', 'Compota', 15, 1200);

INSERT INTO productos(codigo, nombre, stock, valor_unitario) VALUES ('4567', 'Jarabe', 50, 120);

-- Insertar en la tabla clientes
INSERT INTO clientes(identificacion, nombre, edad, correo) VALUES ('1091354977', 'Abel Gomez', 19, 'a1000@gmail.com');

-- Insertar en la tabla facturas
INSERT INTO facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) VALUES ('1', TO_DATE('2024-08-30', 'YYYY-MM-DD'), 5, 6000, 'ENTREGADO', '1091354977', '1234');

INSERT INTO facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) VALUES ('2', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 1, 600, 'PENDIENTE', '1091354977', '4567');

INSERT INTO facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) VALUES ('3', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 2, 1000, 'BLOQUEADO', '1091354977', '1234');

INSERT INTO facturas(id, fecha, cantidad, valor_total, pedido_estado, id_cliente, id_producto) VALUES ('4', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 3, 25000, 'ENTREGADO', '1091354977', '4567');

UPDATE facturas SET pedido_estado = 'PENDIENTE' WHERE id = '1';

CALL verificar_stock('1234', 12);
