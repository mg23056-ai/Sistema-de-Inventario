/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author waldi
 */
public class Conexion {
    private static final String URL = "jdbc:postgresql://localhost:5432/gestioninventario"; // <--- nombre de tu BD
    private static final String USER = "tr23014"; // <--- usuario
    private static final String PASSWORD = "tr23014"; // <--- contraseña

    public static Connection getConexion() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.out.println("Error en la conexión a la base de datos");
            e.printStackTrace();
            return null;
        }
    }
}
