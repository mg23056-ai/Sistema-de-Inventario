/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import menuinventarioproducto.Almacen;
import Conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author waldi
 */
public class AlmacenDAO {
    public List<Almacen> listarAlmacenes() {
        List<Almacen> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre, ubicacion FROM almacen ORDER BY nombre";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Almacen a = new Almacen();
                a.setCodigo(rs.getString("codigo"));
                a.setNombre(rs.getString("nombre"));
                a.setUbicacion(rs.getString("ubicacion"));
                lista.add(a);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar almacenes: " + e.getMessage());
        }

        return lista;
    }
}
