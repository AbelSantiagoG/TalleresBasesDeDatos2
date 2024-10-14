create table envios(
	id varchar primary key,
	fecha_envio date,
	destino varchar,
	observacion varchar,
	estado varchar CHECK (estado IN ('pendiente', 'en_ruta', 'entregado'))
);

CREATE OR REPLACE PROCEDURE fill_db()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    estado_array TEXT[] := ARRAY['pendiente', 'en_ruta', 'entregado'];
    destino_array TEXT[] := ARRAY['a', 'b', 'c'];
    observacion_array TEXT[] := ARRAY['obs1', 'obs2', 'obs3'];
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO taller12.envios (id, fecha_envio, destino, observacion, estado)
        VALUES (
            'env_' || LPAD(i::TEXT, 3, '0'), 
            CURRENT_DATE - (i * (RANDOM() * 10)::INT), 
            destino_array[1 + (RANDOM() * 2)::INT],
            observacion_array[1 + (RANDOM() * 2)::INT],
            estado_array[1 + (RANDOM() * 2)::INT] 
        );
    END LOOP;
END $$;

CREATE OR REPLACE PROCEDURE primera_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
    c_envios_pendientes CURSOR FOR
        SELECT id, fecha_envio
        FROM envios
        WHERE estado = 'pendiente';

    v_id_envio VARCHAR;
BEGIN
    FOR v_id_envio IN c_envios_pendientes LOOP
        UPDATE taller12.envios
        SET 
            observacion = 'Primera etapa del envío',
            estado = 'en_ruta'
        WHERE id = v_id_envio.id;
    END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE ultima_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
     c_envios_en_ruta CURSOR FOR
        SELECT id, fecha_envio
        FROM taller12.envios
        WHERE estado = 'en_ruta' 
        AND CURRENT_DATE - fecha_envio > 5;

    v_id_envio VARCHAR;
    v_fecha_envio DATE;
BEGIN
    OPEN c_envios_en_ruta;

    LOOP
        FETCH c_envios_en_ruta INTO v_id_envio, v_fecha_envio;
        
        EXIT WHEN NOT FOUND;

        UPDATE taller12.envios
        SET 
            estado = 'entregado',
            observacion = 'Envío realizado satisfactoriamente'
        WHERE id = v_id_envio;
    END LOOP;

    CLOSE c_envios_en_ruta;
END 
$$;

call fill_db();
call primera_fase_envio();
call ultima_fase_envio();







