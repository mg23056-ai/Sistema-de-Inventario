/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import menuinventarioproducto.Producto;
import Conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author waldi
 */
public class ProductoDAO {
public List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT codigo_lote, nombre, cantidad, almacen_codigo, proveedor_nit, categoria_codigo, fechaDeVencimiento, descripcion, costo FROM producto";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setCodigoLote(rs.getString("codigo_lote"));
                p.setNombre(rs.getString("nombre"));
                p.setCantidad(rs.getInt("cantidad"));
                p.setAlmacenCodigo(rs.getString("almacen_codigo"));
                p.setProveedorNit(rs.getString("proveedor_nit"));
                p.setCategoriaCodigo(rs.getString("categoria_codigo"));
                p.setFechaDeVencimiento(rs.getDate("fechaDeVencimiento"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setCosto(rs.getDouble("costo"));
                lista.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
        }

        return lista;
    }
}
