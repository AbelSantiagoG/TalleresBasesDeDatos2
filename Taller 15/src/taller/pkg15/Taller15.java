/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller.pkg15;

import java.math.BigDecimal;
import java.sql.*;
/**
 *
 * @author abels
 */
public class Taller15 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","elpepe1234");

            // Llamar a guardar_libro
            CallableStatement guardarLibroStmt = conexion.prepareCall("CALL taller15.guardar_libro(?, ?::xml)");
            guardarLibroStmt.setString(1, "123456789");
            guardarLibroStmt.setString(2, "<libro><titulo>El Gran Libro</titulo><autor>Juan Pérez</autor></libro>");

            // Llamar a obtener_autor_libro_por_isbn
            CallableStatement obtenerAutorPorIsbnStmt = conexion.prepareCall("SELECT taller15.obtener_autor_libro_por_isbn(?)");
            obtenerAutorPorIsbnStmt.setString(1, "123456789");

            // Llamar a obtener_autor_libro_por_titulo
            CallableStatement obtenerAutorPorTituloStmt = conexion.prepareCall("SELECT taller15.obtener_autor_libro_por_titulo(?)");
            obtenerAutorPorTituloStmt.setString(1, "El Gran Libro");

            // Llamar a obtener_libros_por_anio
            CallableStatement obtenerLibrosPorAnioStmt = conexion.prepareCall("SELECT * FROM taller15.obtener_libros_por_anio(?)");
            obtenerLibrosPorAnioStmt.setInt(1, 2024);

            // Ejecutar las consultas
            guardarLibroStmt.execute();

            ResultSet rsAutorPorIsbn = obtenerAutorPorIsbnStmt.executeQuery();
            ResultSet rsAutorPorTitulo = obtenerAutorPorTituloStmt.executeQuery();
            ResultSet rsLibrosPorAnio = obtenerLibrosPorAnioStmt.executeQuery();

            // Mostrar resultados de obtener_autor_libro_por_isbn
            while (rsAutorPorIsbn.next()) {
                System.out.println("Autor por ISBN: " + rsAutorPorIsbn.getString(1));
            }

            // Mostrar resultados de obtener_autor_libro_por_titulo
            while (rsAutorPorTitulo.next()) {
                System.out.println("Autor por título: " + rsAutorPorTitulo.getString(1));
            }

            // Mostrar resultados de obtener_libros_por_anio
            while (rsLibrosPorAnio.next()) {
                System.out.println("Libro ISBN: " + rsLibrosPorAnio.getString("isbn") + ", Descripción: " + rsLibrosPorAnio.getString("descripcion"));
            }

            // Cerrar conexiones
            guardarLibroStmt.close();
            obtenerAutorPorIsbnStmt.close();
            obtenerAutorPorTituloStmt.close();
            obtenerLibrosPorAnioStmt.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
