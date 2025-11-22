/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Categoria;
import models.Producto;
import models.Proveedor;
/**
 *
 * @author waldi
 */
public class ProductoDAO {

    public List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();

        String sql = """
            SELECT p.codigo, p.nombre, p.descripcion, p.cantidad_asociada, p.estado,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto
            FROM producto p
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            ORDER BY p.codigo
        """;

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {

                Categoria categoria = new Categoria(
                        rs.getString("cat_codigo"),
                        rs.getString("cat_nombre")
                );

                Proveedor proveedor = new Proveedor(
                        rs.getString("prov_nit"),
                        rs.getString("prov_nombre"),
                        rs.getString("prov_direccion"),
                        rs.getString("prov_contacto")
                );

                Producto p = new Producto(
                        rs.getString("codigo"),
                        rs.getString("nombre"),
                        categoria,
                        rs.getString("descripcion"),
                        rs.getInt("cantidad_asociada"),
                        proveedor,
                        rs.getBoolean("estado")
                );

                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }


    public List<Producto> listarProductosPaginado(int limit, int offset) {
        List<Producto> lista = new ArrayList<>();

        String sql = """
            SELECT p.codigo, p.nombre, p.descripcion, p.cantidad_asociada, p.estado,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto
            FROM producto p
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            ORDER BY p.codigo
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Categoria categoria = new Categoria(
                            rs.getString("cat_codigo"),
                            rs.getString("cat_nombre")
                    );

                    Proveedor proveedor = new Proveedor(
                            rs.getString("prov_nit"),
                            rs.getString("prov_nombre"),
                            rs.getString("prov_direccion"),
                            rs.getString("prov_contacto")
                    );

                    Producto p = new Producto(
                            rs.getString("codigo"),
                            rs.getString("nombre"),
                            categoria,
                            rs.getString("descripcion"),
                            rs.getInt("cantidad_asociada"),
                            proveedor,
                            rs.getBoolean("estado")
                    );

                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar productos paginados: " + e.getMessage());
        }

        return lista;
    }


    public boolean insertarProducto(Producto p) {

        String sql = """
            INSERT INTO producto (codigo, nombre, categoria_codigo, descripcion,
                                  cantidad_asociada, proveedor_nit, estado)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getCodigo());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getCategoria().getCodigo());
            ps.setString(4, p.getDescripcion());
            ps.setInt(5, p.getCantidadAsociada());
            ps.setString(6, p.getProveedor().getNit());
            ps.setBoolean(7, p.isEstado());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al insertar producto: " + e.getMessage());
            return false;
        }
    }


    public boolean actualizarProducto(Producto p) {

        String sql = """
            UPDATE producto
            SET nombre=?, categoria_codigo=?, descripcion=?,
                cantidad_asociada=?, proveedor_nit=?, estado=?
            WHERE codigo=?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getCategoria().getCodigo());
            ps.setString(3, p.getDescripcion());
            ps.setInt(4, p.getCantidadAsociada());
            ps.setString(5, p.getProveedor().getNit());
            ps.setBoolean(6, p.isEstado());
            ps.setString(7, p.getCodigo());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            return false;
        }
    }


    public boolean eliminarProducto(String codigo) {
        String sql = "DELETE FROM producto WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al eliminar producto: " + e.getMessage());
            return false;
        }
    }


    public Producto buscarProductoPorCodigo(String codigo) {

        String sql = """
            SELECT p.codigo, p.nombre, p.descripcion, p.cantidad_asociada, p.estado,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto
            FROM producto p
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            WHERE p.codigo = ?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    Categoria categoria = new Categoria(
                            rs.getString("cat_codigo"),
                            rs.getString("cat_nombre")
                    );

                    Proveedor proveedor = new Proveedor(
                            rs.getString("prov_nit"),
                            rs.getString("prov_nombre"),
                            rs.getString("prov_direccion"),
                            rs.getString("prov_contacto")
                    );

                    return new Producto(
                            rs.getString("codigo"),
                            rs.getString("nombre"),
                            categoria,
                            rs.getString("descripcion"),
                            rs.getInt("cantidad_asociada"),
                            proveedor,
                            rs.getBoolean("estado")
                    );
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar producto: " + e.getMessage());
        }

        return null;
    }


    public boolean existeProducto(String codigo) {
        String sql = "SELECT 1 FROM producto WHERE codigo=?";

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


    public int contarProductos() {
        String sql = "SELECT COUNT(*) AS total FROM producto";

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
}