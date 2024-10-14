CREATE TABLE libros (
    isbn VARCHAR PRIMARY KEY,
    descripcion XML
);

CREATE OR REPLACE PROCEDURE guardar_libro(
    p_isbn VARCHAR,
    p_descripcion XML
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_titulo VARCHAR;
BEGIN
    SELECT xpath('//libro/titulo/text()', p_descripcion) INTO v_titulo;

    IF EXISTS (SELECT 1 FROM taller15. libros WHERE isbn = p_isbn) THEN
        RAISE EXCEPTION 'El ISBN ya existe en la base de datos.';
    END IF;

    IF EXISTS (SELECT 1 FROM taller15.libros WHERE xpath('//libro/titulo/text()', descripcion) = ARRAY[v_titulo]) THEN
        RAISE EXCEPTION 'El título ya existe en la base de datos.';
    END IF;

    INSERT INTO taller15.libros (isbn, descripcion)
    VALUES (p_isbn, p_descripcion);
END 
$$;

CREATE OR REPLACE PROCEDURE actualizar_libro(
    p_isbn VARCHAR,
    p_descripcion XML
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_titulo VARCHAR;
BEGIN
    SELECT xpath('//libro/titulo/text()', p_descripcion) INTO v_titulo;

    IF NOT EXISTS (SELECT 1 FROM taller15.libros WHERE isbn = p_isbn) THEN
        RAISE EXCEPTION 'El libro con ISBN % no existe.', p_isbn;
    END IF;

    UPDATE taller15.libros
    SET descripcion = p_descripcion
    WHERE isbn = p_isbn;
    
END 
$$;

CREATE OR REPLACE FUNCTION obtener_autor_libro_por_isbn(
    p_isbn VARCHAR
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_autor VARCHAR;
BEGIN
    SELECT xpath('//libro/autor/text()', descripcion) INTO v_autor
    FROM taller15.libros
    WHERE isbn = p_isbn;

    IF v_autor IS NULL THEN
        RETURN 'Autor no encontrado';
    ELSE
        RETURN v_autor[1];  
    END IF;
END 
$$;

CREATE OR REPLACE FUNCTION obtener_autor_libro_por_titulo(
    p_titulo VARCHAR
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_autor VARCHAR;
BEGIN
    SELECT xpath('//libro[titulo/text() = $1]/autor/text()', descripcion)
    INTO v_autor
    FROM taller15.libros
    WHERE xpath('//libro/titulo/text()', descripcion) = ARRAY[p_titulo];

    IF v_autor IS NULL THEN
        RETURN 'Autor no encontrado';
    ELSE
        RETURN v_autor[1];  
    END IF;
END 
$$;

CREATE OR REPLACE FUNCTION obtener_libros_por_anio(
    p_anio INT
)
RETURNS TABLE(isbn VARCHAR, descripcion XML)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT isbn, descripcion
    FROM taller15.libros
    WHERE xpath('//libro/anio/text()', descripcion) = ARRAY[p_anio::text];
END 
$$;


CALL guardar_libro('123456789', '<libro><titulo>El Gran Libro</titulo><autor>Juan Pérez</autor></libro>');
CALL actualizar_libro('123456789', '<libro><titulo>El Gran Libro</titulo><autor>Juan Pérez</autor><anio>2023</anio></libro>');
SELECT obtener_autor_libro_por_isbn('123456789');
SELECT obtener_autor_libro_por_titulo('El Gran Libro');
SELECT * FROM obtener_libros_por_anio(2023);