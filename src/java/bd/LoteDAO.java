/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Categoria;
import models.Proveedor;
import models.Almacen;
import models.Producto;
import models.Lote;
/**
 *
 * @author waldi
 */
public class LoteDAO {

    public List<Lote> listarLotes() {
        List<Lote> lista = new ArrayList<>();

        String sql = """
            SELECT l.codigo, l.cantidad, l.fecha_ingreso, l.fecha_vencimiento, l.costo_unitario, l.observaciones,
                   p.codigo AS prod_codigo, p.nombre AS prod_nombre, p.descripcion AS prod_descripcion, p.cantidad_asociada AS prod_cantidad,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto,
                   a.codigo AS alm_codigo, a.nombre AS alm_nombre, a.ubicacion AS alm_ubicacion
            FROM lote l
            INNER JOIN producto p ON l.producto_codigo = p.codigo
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            INNER JOIN almacen a ON l.ubicacion_codigo = a.codigo
            ORDER BY l.codigo
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

                Producto producto = new Producto(
                        rs.getString("prod_codigo"),
                        rs.getString("prod_nombre"),
                        categoria,
                        rs.getString("prod_descripcion"),
                        rs.getInt("prod_cantidad"),
                        proveedor,
                        rs.getBoolean("estado")
                );

                Almacen almacen = new Almacen(
                        rs.getString("alm_codigo"),
                        rs.getString("alm_nombre"),
                        rs.getString("alm_ubicacion")
                );

                Lote lote = new Lote(
                        rs.getString("codigo"),
                        producto,
                        rs.getInt("cantidad"),
                        rs.getDate("fecha_ingreso"),
                        rs.getDate("fecha_vencimiento"),
                        almacen,
                        rs.getDouble("costo_unitario"),
                        rs.getString("observaciones")
                );

                lista.add(lote);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public List<Lote> listarLotesPaginado(int limit, int offset) {
        List<Lote> lista = new ArrayList<>();

        String sql = """
            SELECT l.codigo, l.cantidad, l.fecha_ingreso, l.fecha_vencimiento, l.costo_unitario, l.observaciones,
                   p.codigo AS prod_codigo, p.nombre AS prod_nombre, p.descripcion AS prod_descripcion, p.cantidad_asociada AS prod_cantidad,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto,
                   a.codigo AS alm_codigo, a.nombre AS alm_nombre, a.ubicacion AS alm_ubicacion
            FROM lote l
            INNER JOIN producto p ON l.producto_codigo = p.codigo
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            INNER JOIN almacen a ON l.ubicacion_codigo = a.codigo
            ORDER BY l.codigo
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

                    Producto producto = new Producto(
                            rs.getString("prod_codigo"),
                            rs.getString("prod_nombre"),
                            categoria,
                            rs.getString("prod_descripcion"),
                            rs.getInt("prod_cantidad"),
                            proveedor,
                            rs.getBoolean("estado")
                    );

                    Almacen almacen = new Almacen(
                            rs.getString("alm_codigo"),
                            rs.getString("alm_nombre"),
                            rs.getString("alm_ubicacion")
                    );

                    Lote lote = new Lote(
                            rs.getString("codigo"),
                            producto,
                            rs.getInt("cantidad"),
                            rs.getDate("fecha_ingreso"),
                            rs.getDate("fecha_vencimiento"),
                            almacen,
                            rs.getDouble("costo_unitario"),
                            rs.getString("observaciones")
                    );

                    lista.add(lote);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar lotes paginados: " + e.getMessage());
        }

        return lista;
    }

    
    public List<Lote> listarLotePorProductoID(String productoID) {
        List<Lote> lista = new ArrayList<>();

        String sql = """
            SELECT l.codigo, l.cantidad, l.fecha_ingreso, l.fecha_vencimiento, 
                   l.costo_unitario, l.observaciones,

                   p.codigo AS prod_codigo, p.nombre AS prod_nombre, p.descripcion AS prod_descripcion, 
                   p.cantidad_asociada AS prod_cantidad, p.estado AS prod_estado,

                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,

                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, 
                   pr.contacto AS prov_contacto,

                   a.codigo AS alm_codigo, a.nombre AS alm_nombre, a.ubicacion AS alm_ubicacion
            FROM lote l
            INNER JOIN producto p ON l.producto_codigo = p.codigo
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            INNER JOIN almacen a ON l.ubicacion_codigo = a.codigo
            WHERE p.codigo = ?
            ORDER BY l.codigo
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, productoID);

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

                    Producto producto = new Producto(
                        rs.getString("prod_codigo"),
                        rs.getString("prod_nombre"),
                        categoria,
                        rs.getString("prod_descripcion"),
                        rs.getInt("prod_cantidad"),
                        proveedor,
                        rs.getBoolean("prod_estado")
                    );

                    Almacen almacen = new Almacen(
                        rs.getString("alm_codigo"),
                        rs.getString("alm_nombre"),
                        rs.getString("alm_ubicacion")
                    );

                    Lote lote = new Lote(
                        rs.getString("codigo"),
                        producto,
                        rs.getInt("cantidad"),
                        rs.getDate("fecha_ingreso"),
                        rs.getDate("fecha_vencimiento"),
                        almacen,
                        rs.getDouble("costo_unitario"),
                        rs.getString("observaciones")
                    );

                    lista.add(lote);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
    
    public boolean insertarLote(Lote l) {
        String sql = """
            INSERT INTO lote (codigo, producto_codigo, cantidad, fecha_ingreso, fecha_vencimiento,
                              ubicacion_codigo, costo_unitario, observaciones)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, l.getCodigo());
            ps.setString(2, l.getProducto().getCodigo());
            ps.setInt(3, l.getCantidad());
            ps.setDate(4, l.getFechaIngreso());
            ps.setDate(5, l.getFechaVencimiento());
            ps.setString(6, l.getUbicacion().getCodigo());
            ps.setDouble(7, l.getCostoUnitario());
            ps.setString(8, l.getObservaciones());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al insertar lote: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarLote(Lote l) {
        String sql = """
            UPDATE lote
            SET producto_codigo=?, cantidad=?, fecha_ingreso=?, fecha_vencimiento=?,
                ubicacion_codigo=?, costo_unitario=?, observaciones=?
            WHERE codigo=?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, l.getProducto().getCodigo());
            ps.setInt(2, l.getCantidad());
            ps.setDate(3, l.getFechaIngreso());
            ps.setDate(4, l.getFechaVencimiento());
            ps.setString(5, l.getUbicacion().getCodigo());
            ps.setDouble(6, l.getCostoUnitario());
            ps.setString(7, l.getObservaciones());
            ps.setString(8, l.getCodigo());

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al actualizar lote: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarLote(String codigo) {
        String sql = "DELETE FROM lote WHERE codigo=?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al eliminar lote: " + e.getMessage());
            return false;
        }
    }

    public Lote buscarLotePorCodigo(String codigo) {
        String sql = """
            SELECT l.codigo, l.cantidad, l.fecha_ingreso, l.fecha_vencimiento, l.costo_unitario, l.observaciones,
                   p.codigo AS prod_codigo, p.nombre AS prod_nombre, p.descripcion AS prod_descripcion, p.cantidad_asociada AS prod_cantidad,
                   c.codigo AS cat_codigo, c.nombre AS cat_nombre,
                   pr.nit AS prov_nit, pr.nombre AS prov_nombre, pr.direccion AS prov_direccion, pr.contacto AS prov_contacto,
                   a.codigo AS alm_codigo, a.nombre AS alm_nombre, a.ubicacion AS alm_ubicacion
            FROM lote l
            INNER JOIN producto p ON l.producto_codigo = p.codigo
            INNER JOIN categoria c ON p.categoria_codigo = c.codigo
            INNER JOIN proveedor pr ON p.proveedor_nit = pr.nit
            INNER JOIN almacen a ON l.ubicacion_codigo = a.codigo
            WHERE l.codigo = ?
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

                    Producto producto = new Producto(
                            rs.getString("prod_codigo"),
                            rs.getString("prod_nombre"),
                            categoria,
                            rs.getString("prod_descripcion"),
                            rs.getInt("prod_cantidad"),
                            proveedor,
                            rs.getBoolean("estado")
                    );

                    Almacen almacen = new Almacen(
                            rs.getString("alm_codigo"),
                            rs.getString("alm_nombre"),
                            rs.getString("alm_ubicacion")
                    );

                    return new Lote(
                            rs.getString("codigo"),
                            producto,
                            rs.getInt("cantidad"),
                            rs.getDate("fecha_ingreso"),
                            rs.getDate("fecha_vencimiento"),
                            almacen,
                            rs.getDouble("costo_unitario"),
                            rs.getString("observaciones")
                    );
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar lote: " + e.getMessage());
        }

        return null;
    }

    public boolean existeLote(String codigo) {
        String sql = "SELECT 1 FROM lote WHERE codigo=?";

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

    public int contarLotes() {
        String sql = "SELECT COUNT(*) AS total FROM lote";

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
