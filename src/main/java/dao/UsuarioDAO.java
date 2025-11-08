/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import Conexion.Conexion;
import login.Usuario;
import java.sql.*;
/**
 *
 * @author waldi
 */
public class UsuarioDAO {
    public Usuario login(String id, String contrasenia) {
        Usuario user = null;
        String sql = "SELECT * FROM usuario WHERE id = ? AND contraseña = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, contrasenia);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new Usuario(
                    rs.getString("id"),
                    rs.getString("nombre"),
                    rs.getInt("edad"),
                    rs.getString("rol"),
                    rs.getString("contraseña")
                );
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("Error al iniciar sesión: " + e.getMessage());
        }

        return user;
    }
}
