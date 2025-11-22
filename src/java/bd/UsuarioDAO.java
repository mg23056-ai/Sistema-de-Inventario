/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Usuario;
import models.Rol;

/**
 *
 * @author waldi
 */
public class UsuarioDAO {

    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        String sql = """
            SELECT u.id, u.nombre, u.edad, u.contrasena, u.activo,
                   r.codigo AS rol_codigo, r.nombre AS rol_nombre, r.descripcion AS rol_descripcion
            FROM usuario u
            INNER JOIN rol r ON u.rol_codigo = r.codigo
            ORDER BY u.id
        """;

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Rol rol = new Rol(
                    rs.getString("rol_codigo"),
                    rs.getString("rol_nombre"),
                    rs.getString("rol_descripcion")
                );

                Usuario u = new Usuario(
                    rs.getString("id"),
                    rs.getString("nombre"),
                    rs.getInt("edad"),
                    rol,
                    rs.getString("contrasena"),
                    rs.getBoolean("activo")
                );
                lista.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Usuario> listarUsuariosPaginado(int limit, int offset) {
        List<Usuario> lista = new ArrayList<>();
        String sql = """
            SELECT u.id, u.nombre, u.edad, u.contrasena, u.activo,
                   r.codigo AS rol_codigo, r.nombre AS rol_nombre, r.descripcion AS rol_descripcion
            FROM usuario u
            JOIN rol r ON u.rol_codigo = r.codigo
            ORDER BY u.id LIMIT ? OFFSET ?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Rol rol = new Rol(
                        rs.getString("rol_codigo"),
                        rs.getString("rol_nombre"),
                        rs.getString("rol_descripcion")
                    );

                    Usuario u = new Usuario(
                        rs.getString("id"),
                        rs.getString("nombre"),
                        rs.getInt("edad"),
                        rol,
                        rs.getString("contrasena"),
                        rs.getBoolean("activo")
                    );

                    lista.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios paginados: " + e.getMessage());
        }

        return lista;
    }

    public boolean insertarUsuario(Usuario u) {
        String sql = "INSERT INTO usuario(id, nombre, edad, rol_codigo, contrasena, activo) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getId());
            ps.setString(2, u.getNombre());
            ps.setInt(3, u.getEdad());
            ps.setString(4, u.getRol().getCodigo());
            ps.setString(5, u.getContrasena());
            ps.setBoolean(6, u.isActivo());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarUsuario(Usuario u) {
        String sql = "UPDATE usuario SET nombre=?, edad=?, rol_codigo=?, contrasena=?, activo=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getNombre());
            ps.setInt(2, u.getEdad());
            ps.setString(3, u.getRol().getCodigo());
            ps.setString(4, u.getContrasena());
            ps.setBoolean(5, u.isActivo());
            ps.setString(6, u.getId());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarUsuario(String id) {
        String sql = "DELETE FROM usuario WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Usuario buscarUsuarioPorId(String id) {
        String sql = """
            SELECT u.id, u.nombre, u.edad, u.contrasena, u.activo,
                   r.codigo AS rol_codigo, r.nombre AS rol_nombre, r.descripcion AS rol_descripcion
            FROM usuario u
            INNER JOIN rol r ON u.rol_codigo = r.codigo
            WHERE u.id = ?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Rol rol = new Rol(
                        rs.getString("rol_codigo"),
                        rs.getString("rol_nombre"),
                        rs.getString("rol_descripcion")
                    );

                    return new Usuario(
                        rs.getString("id"),
                        rs.getString("nombre"),
                        rs.getInt("edad"),
                        rol,
                        rs.getString("contrasena"),
                        rs.getBoolean("activo")
                    );
                }
                System.out.println("ID recibido: [" + id + "] largo=" + id.length());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Usuario login(String id, String contrasenia) {
        Usuario user = null;
        String sql = """
            SELECT u.id, u.nombre, u.edad, u.contrasena, u.activo,
                   r.codigo AS rol_codigo, r.nombre AS rol_nombre, r.descripcion AS rol_descripcion
            FROM usuario u
            JOIN rol r ON u.rol_codigo = r.codigo
            WHERE u.id = ? AND u.contrasena = ? AND u.activo = TRUE
        """; // ← Solo permite login si está activo

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.setString(2, contrasenia);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Rol rol = new Rol(
                    rs.getString("rol_codigo"),
                    rs.getString("rol_nombre"),
                    rs.getString("rol_descripcion")
                );

                user = new Usuario(
                    rs.getString("id"),
                    rs.getString("nombre"),
                    rs.getInt("edad"),
                    rol,
                    rs.getString("contrasena"),
                    rs.getBoolean("activo")
                );
            }

            rs.close();

        } catch (SQLException e) {
            System.err.println("Error al iniciar sesión: " + e.getMessage());
        }

        return user;
    }

    public int contarUsuarios() {
        String sql = "SELECT COUNT(*) AS total FROM usuario";
        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean buscarUsuario(String id) {
        String sql = "SELECT 1 FROM usuario WHERE id = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
