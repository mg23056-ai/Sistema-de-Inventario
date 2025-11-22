/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import models.TipoMovimiento;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author waldi
 */
public class TipoMovimientoDAO {

    public List<TipoMovimiento> listarTipos() {
        List<TipoMovimiento> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre, descripcion FROM tipo_movimiento ORDER BY nombre";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TipoMovimiento t = new TipoMovimiento();
                t.setCodigo(rs.getString("codigo"));
                t.setNombre(rs.getString("nombre"));
                t.setDescripcion(rs.getString("descripcion"));
                lista.add(t);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar tipos de movimiento: " + e.getMessage());
        }

        return lista;
    }

    // Método para insertar un nuevo tipo de movimiento
    public boolean insertar(TipoMovimiento tipo) {
        String sql = "INSERT INTO tipo_movimiento (codigo, nombre, descripcion) VALUES (?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tipo.getCodigo());
            ps.setString(2, tipo.getNombre());
            ps.setString(3, tipo.getDescripcion());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar tipo de movimiento: " + e.getMessage());
            return false;
        }
    }

    // Método para actualizar un tipo de movimiento
    public boolean actualizar(TipoMovimiento tipo) {
        String sql = "UPDATE tipo_movimiento SET nombre = ?, descripcion = ? WHERE codigo = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tipo.getNombre());
            ps.setString(2, tipo.getDescripcion());
            ps.setString(3, tipo.getCodigo());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar tipo de movimiento: " + e.getMessage());
            return false;
        }
    }

    // Método para eliminar un tipo de movimiento
    public boolean eliminar(String codigo) {
        String sql = "DELETE FROM tipo_movimiento WHERE codigo = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codigo);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar tipo de movimiento: " + e.getMessage());
            return false;
        }
    }

    // Método para buscar un tipo de movimiento por su código
    public static TipoMovimiento buscarPorCodigo(String codigo) {
        TipoMovimiento tipo = null;
        String sql = "SELECT codigo, nombre, descripcion FROM tipo_movimiento WHERE codigo = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                tipo = new TipoMovimiento();
                tipo.setCodigo(rs.getString("codigo"));
                tipo.setNombre(rs.getString("nombre"));
                tipo.setDescripcion(rs.getString("descripcion"));
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar tipo de movimiento: " + e.getMessage());
        }

        return tipo;
    }
}