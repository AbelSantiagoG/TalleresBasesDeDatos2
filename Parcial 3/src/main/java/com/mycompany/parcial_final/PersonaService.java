/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial_final;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;
import org.neo4j.driver.SessionConfig;
import static org.neo4j.driver.Values.parameters;

/**
 *
 * @author abels
 */
public class PersonaService {
    private static final Driver driver = Neo4jTin.getDriver();
    private Session session;
    
    public PersonaService(){
        session = driver.session(SessionConfig.forDatabase("neo4j"));
    }
    
    public void crearPersona (String id, String nombre, String correo, int edad, String ciudad){
        String cypherQuery = "CREATE (p:Persona {id: $id,nombre: $nombre, correo: $correo, edad: $edad, ciudad: $ciudad})";
        session.run(cypherQuery, parameters("id",id,"nombre",nombre,"correo",correo,"edad",edad, "ciudad", ciudad));
        System.out.println("Persona creada: " + nombre);
    }
    
    public Persona obtenerPersona(String id){
     String cypherQuery = "MATCH (p:Persona {id: $id}) RETURN p.id";
     org.neo4j.driver.Record record = session.run(cypherQuery,parameters("identificacion",id)).single();
     if (record != null){
         return new Persona (
                record.get("id").asString(),
                 record.get("nombre").asString(),
                 record.get("coreo").asString(),
                 record.get("edad").asInt(),
                 record.get("ciudad").asString()
         );
     }
     return null;
    }
    
}
