/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package basesdedatos2;

import java.math.BigDecimal;
import java.sql.*;

/**
 *
 * @author abels
 */
public class BasesDeDatos2 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","elpepe1234");
            CallableStatement ejecucion1 = conexion.prepareCall("call taller5.generar_auditoria(?,?)");
            CallableStatement ejecucion2 = conexion.prepareCall("call taller5.simular_ventas_mes()");
            CallableStatement ejecucion3 = conexion.prepareCall("select * from taller6.transacciones_total_mes(?,?)");
            //CallableStatement ejecucion4 = conexion.prepareCall("select taller6.simular_ventas_mes()");
            
            //Taller 5
            java.sql.Date fechaInicio = java.sql.Date.valueOf("2024-12-01");
            java.sql.Date fechaFinal = java.sql.Date.valueOf("2024-12-31");
            ejecucion1.setDate(1, fechaInicio);
            ejecucion1.setDate(2, fechaFinal);
            
            //Taller 6
            java.sql.Date fecha = java.sql.Date.valueOf("2024-02-27");
            ejecucion3.setDate(1, fecha);
            ejecucion3.setInt(2,1);
            
            //Meterle
            ejecucion1.execute();
            ejecucion2.execute();
            ResultSet rs = ejecucion3.executeQuery();
            //ejecucion4.executeQuery();
            
            //Mostrar resultados de las funciones:
            while (rs.next()) {
                System.out.println(rs.getString(1)); 
            }
            
            
            //Cerrando conexiones
            ejecucion1.close();
            ejecucion2.close();
            ejecucion3.close();
            //ejecucion4.close();
            
            conexion.close();
            
        } catch (Exception e) {
            System.out.println( e.getMessage());
        }
    }
    
}
