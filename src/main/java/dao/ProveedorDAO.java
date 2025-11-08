/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import Conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import menuinventarioproducto.Proveedor;
/**
 *
 * @author waldi
 */
public class ProveedorDAO {
    public List<Proveedor> listarProveedores() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT nit, nombre, direccion, contacto FROM proveedor ORDER BY nombre";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setNit(rs.getString("nit"));
                p.setNombre(rs.getString("nombre"));
                p.setDireccion(rs.getString("direccion"));
                p.setContacto(rs.getString("contacto"));
                lista.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar proveedores: " + e.getMessage());
        }

        return lista;
    }
}
