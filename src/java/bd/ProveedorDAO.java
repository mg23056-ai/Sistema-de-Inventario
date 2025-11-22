/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Proveedor;
/**
 *
 * @author waldi
 */
public class ProveedorDAO {

    public List<Proveedor> listarProveedores() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT nit, nombre, direccion, contacto FROM proveedor ORDER BY nit";

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Proveedor p = new Proveedor(
                    rs.getString("nit"),
                    rs.getString("nombre"),
                    rs.getString("direccion"),
                    rs.getString("contacto")
                );
                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public List<Proveedor> listarProveedoresPaginado(int limit, int offset) {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT nit, nombre, direccion, contacto FROM proveedor ORDER BY nit LIMIT ? OFFSET ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Proveedor p = new Proveedor(
                        rs.getString("nit"),
                        rs.getString("nombre"),
                        rs.getString("direccion"),
                        rs.getString("contacto")
                    );
                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar proveedores paginados: " + e.getMessage());
        }

        return lista;
    }

    public boolean insertarProveedor(Proveedor p) {
        String sql = "INSERT INTO proveedor(nit, nombre, direccion, contacto) VALUES (?, ?, ?, ?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNit());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDireccion());
            ps.setString(4, p.getContacto());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarProveedor(Proveedor p) {
        String sql = "UPDATE proveedor SET nombre=?, direccion=?, contacto=? WHERE nit=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDireccion());
            ps.setString(3, p.getContacto());
            ps.setString(4, p.getNit());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarProveedor(String nit) {
        String sql = "DELETE FROM proveedor WHERE nit=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nit);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Proveedor buscarProveedorPorNit(String nit) {
        String sql = "SELECT nit, nombre, direccion, contacto FROM proveedor WHERE nit=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nit);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Proveedor(
                        rs.getString("nit"),
                        rs.getString("nombre"),
                        rs.getString("direccion"),
                        rs.getString("contacto")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean existeProveedor(String nit) {
        String sql = "SELECT 1 FROM proveedor WHERE nit=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nit);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int contarProveedores() {
        String sql = "SELECT COUNT(*) AS total FROM proveedor";

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
    
    public Proveedor obtenerProveedorPorNit(String nit) {
        Proveedor proveedor = null;
        String sql = "SELECT * FROM proveedor WHERE nit = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nit);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                proveedor = new Proveedor(
                    rs.getString("nit"),
                    rs.getString("nombre"),
                    rs.getString("direccion"),
                    rs.getString("contacto")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener proveedor: " + e.getMessage());
        }
        return proveedor;
    }
}
