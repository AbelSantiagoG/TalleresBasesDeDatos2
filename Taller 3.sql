CREATE TABLE clientes (
    identificacion varchar(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    correo VARCHAR(50) NOT NULL	
);
CREATE TABLE productos (
    codigo varchar(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    stock INT NOT NULL,
    valor_unitario float NOT NULL	
);
CREATE TABLE pedidos (
    id varchar(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL,
    valor_total FLOAT NOT NULL,	
    id_cliente varchar(10) NOT NULL,
    id_producto varchar(10) NOT NULL,
 	FOREIGN KEY (id_cliente) REFERENCES clientes(identificacion),
  	FOREIGN KEY (id_producto) REFERENCES productos(codigo)
); 



BEGIN;
	INSERT INTO clientes (identificacion, nombre, edad, correo) 
	VALUES ('1091354977', 'Abel Gomez', 12, 'abelsantiago1000@gmail.com');
	INSERT INTO clientes (identificacion, nombre, edad, correo) 
	VALUES ('60354761', 'Sonia Lopez', 45, 'sonialopez@gmail.com');
	INSERT INTO clientes (identificacion, nombre, edad, correo) 
	VALUES ('123456789', 'Mily Lopez', 5, 'milylopez@gmail.com');

	INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
	VALUES ('123AB', 'Panela', 42, 1500);
	INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
	VALUES ('456CD', 'Compota', 1, 2500);
	INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
	VALUES ('789EF', 'Arroz', 50, 5000);

	INSERT INTO pedidos (id, fecha, cantidad, valor_total, id_cliente, id_producto) 
	VALUES ('1','2024-08-05', 2, 3000, '1091354977', '123AB');
	INSERT INTO pedidos (id, fecha, cantidad, valor_total, id_cliente, id_producto) 
	VALUES ('2','2024-05-03', 1, 2500, '60354761', '456CD');
	INSERT INTO pedidos (id, fecha, cantidad, valor_total, id_cliente, id_producto) 
	VALUES ('3','2024-09-30', 5, 25000, '1091354977', '789EF');

	savepoint;

	UPDATE clientes SET nombre = 'Pedro Flores' WHERE identificacion = '1091354977';
	UPDATE clientes SET edad = 40 WHERE identificacion = '60354761';

	UPDATE productos SET valor_unitario = 2400 WHERE codigo = '456CD'; 
	UPDATE productos SET nombre = 'papaya' WHERE codigo = '456CD';

	UPDATE pedidos SET cantidad = 15 WHERE id = '1';
	UPDATE pedidos SET cantidad = 1 WHERE id = '2';

	DELETE FROM pedidos where id= '1';
	
	DELETE FROM clientes where identificacion= '123456789';
	
	DELETE FROM productos where codigo= '123AB';
	
	rollback to savepoint;
	
ROLLBACK;

	select * from clientes;
	select * from productos;
	select * from pedidos;