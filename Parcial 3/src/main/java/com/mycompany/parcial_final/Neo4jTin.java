/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial_final;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;
/**
 *
 * @author abels
 */
public class Neo4jTin {
    private static Driver driver;
    
    public static void connect(){
        driver = GraphDatabase.driver("bolt://localhost:7687",AuthTokens.basic("neo4j","12345678"));
    }
    
    public static void close(){
        if(driver!=null){
            driver.close();
        }
    }
    
    public static Driver getDriver(){
        return driver;
    }
}
