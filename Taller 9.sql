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
	foreign key(nomina_id) references nominas(id)
);


CREATE OR REPLACE PROCEDURE poblar_base()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    salario_total NUMERIC;
    porcentaje INT;
    valor_detalle NUMERIC;
    meses INT[] := ARRAY[1, 2, 3, 4, 5]; 
    ano INT := 2023;  
BEGIN
    FOR i IN 1..10 
	LOOP
        salario_total := round((random() * 4000 + 1000) * 100) / 100; 
        INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) 
        VALUES ('C' || i, 'Contrato ' || i, 'Cargo ' || i, salario_total);
    END LOOP;

    FOR i IN 1..10 
	LOOP
        INSERT INTO empleados (identificacion, nombre, tipo_contrato_id) 
        VALUES ('E' || i, 'Empleado ' || i, 'C' || i);
    END LOOP;

	FOR i IN 1..5 
	LOOP
    	INSERT INTO conceptos (codigo, nombre, porcentaje) VALUES(''||i, 'salario', 100);
 	END LOOP;

    FOR i IN 1..5 
	LOOP
        INSERT INTO nominas (id, mes, ano, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
        VALUES (
            'N' || i, 
            meses[(i % 5) + 1], 
            ano, 
            NOW() + (i || ' days')::INTERVAL, 
            round((random() * 5000 + 2000) * 100) / 100,  
            round((random() * 1000 + 500) * 100) / 100,  
            round((random() * 6000 + 1000) * 100) / 100,  
            'E' || i
        );
    END LOOP;

    FOR i IN 1..15 LOOP
        valor_detalle := round((random() * 1000 + 100) * 100) / 100; 
        INSERT INTO detalles_nomina (id, concepto_id, valor, nomina_id) 
        VALUES ('D' || i, '' || ((i % 5) + 1), valor_detalle, 'N' || ((i % 5) + 1));
    END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION obtener_nomina_empleado(
    p_identificacion VARCHAR,
    p_mes INT,
    p_ano INT
)
RETURNS TABLE (
    nombre_empleado VARCHAR,
    total_devengado NUMERIC,
    total_deducciones NUMERIC,
    total_nomina NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.total_devengado, n.total_deducciones, n.total FROM empleados e
    INNER JOIN nominas n ON e.identificacion = n.cliente_id
    WHERE e.identificacion = p_identificacion AND n.mes = p_mes AND n.ano = p_ano;
END;
$$;


CREATE OR REPLACE FUNCTION total_por_contrato(
    p_tipo_contrato_id VARCHAR
)
RETURNS TABLE (
    nombre_empleado VARCHAR,
    fecha_pago DATE,
    ano INT,
    mes INT,
    total_devengado NUMERIC,
    total_deducciones NUMERIC,
    total_nomina NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.fecha_pago, n.ano, n.mes, n.total_devengado, n.total_deducciones, n.total
    FROM empleados e
    INNER JOIN nominas n ON e.identificacion = n.cliente_id
    WHERE e.tipo_contrato_id = p_tipo_contrato_id;
END;
$$;

call poblar_base();
select obtener_nomina_empleado('E1', 2, 2023);
select total_por_contrato('C1');





