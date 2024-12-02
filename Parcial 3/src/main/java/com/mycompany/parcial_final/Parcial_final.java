/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.parcial_final;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Aggregates.lookup;
import static com.mongodb.client.model.Aggregates.match;
import static com.mongodb.client.model.Aggregates.unwind;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Updates.set;
import static java.util.Arrays.asList;

/**
 *
 * @author abels
 */
public class Parcial_final {
    public static MongoCollection<Document> collection1 ;
    public static MongoCollection<Document> collection2 ;
    public static MongoCollection<Document> collection3 ;
    public static MongoCollection<Document> collection4 ;
    public static void main(String[] args) {
        String uri= "mongodb://localhost:27017";
        MongoClient mongoClient= MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("pruebas");
        collection1 = database.getCollection("productos");
        collection2 = database.getCollection("pedidos");
        collection3 = database.getCollection("detalles");
        collection4 = database.getCollection("reservas");
        System.out.println("Conexión exitosa");
        
        //SEGUNDO PUNTO
        //Productos con un precio mayor a 20 dólares
        try (MongoCursor<Document> cursor1 = collection1.find(gt("precio", 20)).iterator()) {
            while (cursor1.hasNext()) {
                System.out.println(cursor1.next());
            }
        }
        
        //Pedidos con un mayor total a 100 dólares 
        try (MongoCursor<Document> cursor2 = collection2.find(gt("total", 100)).iterator()) {
            while (cursor2.hasNext()) {
                System.out.println(cursor2.next());
            }
        }
        
        // Pedidos en donde exista un detalle de pedido con el producto010
        try (MongoCursor<Document> cursor = collection2.aggregate(asList(
                lookup("detalles", "_id", "pedido_id", "result"),
                unwind("$result"),
                match(eq("detalles.producto_id", "producto010"))
        )).iterator()) {
            while (cursor.hasNext()) {
                System.out.println(cursor.next());
            }
        }
        
        
        //CUARTO PUNTO
        // Habitaciones reservadas de tipo "Sencilla"
        try (MongoCursor<Document> cursor = collection4.find(eq("habitacion.tipo", "Sencilla")).iterator()) {
            while (cursor.hasNext()) {
                System.out.println(cursor.next());
            }
        }
        
        //Sumatoria total de reservas pagadas
        double total = 0;

        try (MongoCursor<Document> cursor = collection4.find(eq("estado_pago", "Pagado")).iterator()) {
            while (cursor.hasNext()) {
                Document reserva = cursor.next();
                total += reserva.getDouble("total"); 
            }
        }
        System.out.println("Sumatoria total de reservas pagadas: " + total);

        //Reservas de las habitaciones con un precio_noche mayor a 100 dolares
        try (MongoCursor<Document> cursor = collection4.find(gt("habitacion.precio_noche", 100)).iterator()) {
            while (cursor.hasNext()) {
                System.out.println(cursor.next());
            }
        }
        
        
        //QUINTO PUNTO
        Neo4jTin.connect();
        PersonaService personaService = new PersonaService();
        personaService.crearPersona("1", "Abel", "abel@gmail.com", 19, "Ocaña");
        Persona persona = personaService.obtenerPersona("1");
        if (persona != null){
            System.out.println("Persona obtenida: " + persona.getNombre() + "Id: " + persona.getId() + "Correo:"+ persona.getCorreo() +"Edad: " + persona.getNombre() + "Ciudad: " + persona.getCiudad());
        }
        Neo4jTin.close();
    }
    
    //PRIMER PUNTO 
    
    //CREATE
    public void crearProducto(String id, String nombre, String descripcion, double precio, int stock){
        Document crear = new Document("id_", id).append("nombre", nombre).append("descripcion", descripcion).append("precio", precio).append("stock", stock);
        collection1.insertOne(crear);
    }
    public void crearPedido(String id, String cliente, String fecha, String estado, double total){
        Document crear = new Document("id_", id).append("cliente", cliente).append("fecha_pedido", fecha).append("estado", estado).append("total", total);
        collection2.insertOne(crear);
    }
    public void crearDetalle(String id, String pedido_id, String producto_id, double precio_unitario, int cantidad){
        Document crear = new Document("id_", id).append("pedido_id", pedido_id).append("producto_id", producto_id).append("cantidad", cantidad).append("precio_unitario", precio_unitario);
        collection3.insertOne(crear);
    }
    
    //DELETE
    public void eliminarProducto(String id){
        collection1.deleteOne(eq("id_", id));
    }
    public void eliminarPedido(String id){
        collection2.deleteOne(eq("id_", id));
    }
    public void eliminarDetalle(String id){
        collection3.deleteOne(eq("id_", id));
    }
    
    //GET
    public Document obtenerProducto(String id){
        Document buscar = collection1.find(eq("_id", id)).first();
        return buscar;
    }
    public Document obtenerPedido(String id){
        Document buscar = collection2.find(eq("_id", id)).first();
        return buscar;
    }
    public Document obtenerDetalle(String id){
        Document buscar = collection3.find(eq("_id", id)).first();
        return buscar;
    }
    
    //UPDATE
    public void actualizarDetalleNombre1(String id, String nombre){
        collection1.updateOne(eq("_id",id), set("nombre", nombre));
    }
    public void actualizarDetalleEstado2(String id, String estado){
        collection1.updateOne(eq("_id",id), set("estado", estado));
    }
    public void actualizarDetalleCantidad3(String id, int cantidad){
        collection1.updateOne(eq("_id",id), set("cantidad", cantidad));
    }
    
    
    //TERCER PUNTO
    //CREATE
    public void crearReserva(
        String id, String cliente_nombre, String cliente_correo, String cliente_telefono, String cliente_direccion, String habitacion_tipo, int habitacion_numero, double habitacion_precionoche, int habitacion_capacidad, String habitacion_descripcion, String fecha_entrada, String fecha_salida, double total, String estado_pago, String metodo_pago, String fecha_reserva) {
    
        Document cliente = new Document("nombre", cliente_nombre).append("correo", cliente_correo).append("telefono", cliente_telefono).append("direccion", cliente_direccion);

        Document habitacion = new Document("tipo", habitacion_tipo).append("numero", habitacion_numero).append("precio_noche", habitacion_precionoche).append("capacidad", habitacion_capacidad).append("descripcion", habitacion_descripcion);

        Document reserva = new Document("_id", id).append("cliente", cliente).append("habitacion", habitacion).append("fecha_entrada", fecha_entrada).append("fecha_salida", fecha_salida).append("total", total).append("estado_pago", estado_pago).append("metodo_pago", metodo_pago).append("fecha_reserva", fecha_reserva);

        collection4.insertOne(reserva);
    }
    
    //DELETE
    public void eliminarReserva(String id){
        collection4.deleteOne(eq("id_", id));
    }
    
    //UPDATE
    public void actualizarReservaNombre(String id, String nombre) {
    collection4.updateOne(eq("_id", id), set("cliente.nombre", nombre));
    }
    
    //GET
    public Document obtenerReserva(String id){
        Document buscar = collection4.find(eq("_id", id)).first();
        return buscar;
    }

}