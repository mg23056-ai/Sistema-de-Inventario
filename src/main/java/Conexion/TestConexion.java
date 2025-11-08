/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Conexion;

import java.sql.Connection;

/**
 *
 * @author waldi
 */
public class TestConexion {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        Connection conn = Conexion.getConexion();
        if (conn != null) {
            System.out.println("Conexion exitosa!");
        } else {
            System.out.println("No se pudo conectar.");
        }
    }
    
}
