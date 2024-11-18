/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.taller19;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;

/**
 *
 * @author Usuario
 */
public class Taller19 {

    public static void main(String[] args) {
        String uri= "mongodb://localhost:27017";
        MongoClient mongoClient= MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("pruebas");
        MongoCollection<Document> collection = database.getCollection("usuarios");
        System.out.println("Conexion exitosa");
        
        //Insertar un documento
        //Document documento = new Document("nombre", "PENE").append("edad", 19).append("ciudad", "Ocaña");
        //collection.insertOne(documento);
        
        //Insertando múltiples documentos
        //Document documento1= new Document("nombre", "Luisa").append("edad", 29).append("ciudad", "Valencia");
        //Document documento2= new Document("nombre", "Geovanny").append("edad", 15).append("ciudad", "Yobani");
        //collection.insertMany(Array.asList(documento1, documento2));
        
        //Consultar documentos
//        MongoCursor<Document> cursor = collection.find().iterator();
//        while(cursor.hasNext()){
//            System.out.println(cursor.next().toJson());
//        }
        
        //Eliminar un documento
        collection.deleteOne(eq("nombre", "PENE"));

        //Traer un solo documento
        //Document resultado = collection.find(eq("nombre", "PENE")).first();

        //Consulta de documentos con filtros
        //MongoCursor<Document> cursor = collection.find(and(eq("ciudad", "Ocaña"), gt("edad", 19), lt("edad", 10))).limit(5).iterator();
        //while(cursor.hasNext()){
        //    System.out.println(cursor.next().toJson());
        //}
        
        //Actualizar un documento
        collection.updateOne(eq("nombre","PENE"), set("edad", 45));
        
        
        
     
    }
}
