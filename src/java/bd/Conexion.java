/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author waldi
 */
public class Conexion {
   private static Connection con;
    
    private static void conectar(){
        try {          
                Class.forName("org.postgresql.Driver").newInstance();
                con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/gestioninventario2", 
                        "postgres", "tr23014");
            } catch (SQLException | ClassNotFoundException | InstantiationException | IllegalAccessException ex) {
                Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
            }
    }
    
    public static Connection getConexion() {
        try {
            if (con == null || con.isClosed()) {
                conectar();
            }
        } catch (SQLException e) {
            conectar();
        }
        return con;
    }
}
