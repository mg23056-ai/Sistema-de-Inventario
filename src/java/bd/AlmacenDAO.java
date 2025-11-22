/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Almacen;
/**
 *
 * @author waldi
 */
public class AlmacenDAO {

    public List<Almacen> listarAlmacenes() {
        List<Almacen> lista = new ArrayList<>();
        String sql = "SELECT * FROM almacen ORDER BY codigo";

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Almacen a = new Almacen(
                    rs.getString("codigo"),
                    rs.getString("nombre"),
                    rs.getString("ubicacion")
                );
                lista.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean insertarAlmacen(Almacen almacen) {
        String sql = "INSERT INTO almacen(codigo, nombre, ubicacion) VALUES (?, ?, ?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, almacen.getCodigo());
            ps.setString(2, almacen.getNombre());
            ps.setString(3, almacen.getUbicacion());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void actualizarAlmacen(Almacen almacen) {
        String sql = "UPDATE almacen SET nombre=?, ubicacion=? WHERE codigo=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, almacen.getNombre());
            ps.setString(2, almacen.getUbicacion());
            ps.setString(3, almacen.getCodigo());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void eliminarAlmacen(String codigo) {
        String sql = "DELETE FROM almacen WHERE codigo=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Almacen obtenerAlmacenPorCodigo(String codigo) {
        Almacen almacen = null;
        String sql = "SELECT * FROM almacen WHERE codigo = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                almacen = new Almacen(
                    rs.getString("codigo"),
                    rs.getString("nombre"),
                    rs.getString("ubicacion")
                );
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener almacen: " + e.getMessage());
        }

        return almacen;
    }
}
