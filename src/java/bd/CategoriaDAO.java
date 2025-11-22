/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Categoria;

/**
 *
 * @author waldi
 */
public class CategoriaDAO {

    public List<Categoria> listarCategorias() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre FROM categoria ORDER BY codigo";

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Categoria c = new Categoria(
                    rs.getString("codigo"),
                    rs.getString("nombre")
                );
                lista.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Categoria> listarCategoriasPaginado(int limit, int offset) {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre FROM categoria ORDER BY codigo LIMIT ? OFFSET ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Categoria c = new Categoria(
                        rs.getString("codigo"),
                        rs.getString("nombre")
                    );
                    lista.add(c);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar categorías paginadas: " + e.getMessage());
        }

        return lista;
    }

    public boolean insertarCategoria(Categoria c) {
        String sql = "INSERT INTO categoria(codigo, nombre) VALUES (?, ?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getCodigo());
            ps.setString(2, c.getNombre());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarCategoria(Categoria c) {
        String sql = "UPDATE categoria SET nombre=? WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getNombre());
            ps.setString(2, c.getCodigo());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarCategoria(String codigo) {
        String sql = "DELETE FROM categoria WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Categoria buscarCategoriaPorCodigo(String codigo) {
        String sql = "SELECT codigo, nombre FROM categoria WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Categoria(
                        rs.getString("codigo"),
                        rs.getString("nombre")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean existeCategoria(String codigo) {
        String sql = "SELECT 1 FROM categoria WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int contarCategorias() {
        String sql = "SELECT COUNT(*) AS total FROM categoria";

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
    
    public Categoria obtenerCategoriaPorCodigo(String codigo) {
        Categoria categoria = null;
        String sql = "SELECT * FROM categoria WHERE codigo = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                categoria = new Categoria(
                    rs.getString("codigo"),
                    rs.getString("nombre")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener categoría: " + e.getMessage());
        }
        return categoria;
    }
}