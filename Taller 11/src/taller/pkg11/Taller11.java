/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller.pkg11;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 *
 * @author Usuario
 */
public class Taller11 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","elpepe1234");

            CallableStatement ejecucion1 = conexion.prepareCall("SELECT * FROM taller9.obtener_nomina_empleado(?, ?, ?)");
            ejecucion1.setString(1, "E1"); 
            ejecucion1.setInt(2, 2);  
            ejecucion1.setInt(3, 2023); 
            ResultSet rs1 = ejecucion1.executeQuery();

            while (rs1.next()) {
                System.out.printf("Nombre: %s, Devengado: %.2f, Deducciones: %.2f, Total: %.2f%n",
                        rs1.getString("nombre_empleado"),
                        rs1.getDouble("total_devengado"),
                        rs1.getDouble("total_deducciones"),
                        rs1.getDouble("total_nomina"));
            }

            CallableStatement ejecucion2 = conexion.prepareCall("SELECT * FROM taller9.total_por_contrato(?)");
            ejecucion2.setString(1, "C1"); 
            ResultSet rs2 = ejecucion2.executeQuery();

            while (rs2.next()) {
                System.out.printf("Nombre: %s, Fecha Pago: %s, Año: %d, Mes: %d, Devengado: %.2f, Deducciones: %.2f, Total: %.2f%n",
                        rs2.getString("nombre_empleado"),
                        rs2.getDate("fecha_pago"),
                        rs2.getInt("ano"),
                        rs2.getInt("mes"),
                        rs2.getDouble("total_devengado"),
                        rs2.getDouble("total_deducciones"),
                        rs2.getDouble("total_nomina"));
            }

            rs1.close();
            rs2.close();
            ejecucion1.close();
            ejecucion2.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
