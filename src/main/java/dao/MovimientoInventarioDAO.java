/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import menuAdmin.MovimientoInventario;
import Conexion.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author waldi
 */
public class MovimientoInventarioDAO {
    public List<MovimientoInventario> listarMovimientos() {
        List<MovimientoInventario> lista = new ArrayList<>();
        String sql = "SELECT codigo, idtipo, codigo_lote, cantidad, costo, fecha FROM movimiento_inventario ORDER BY fecha DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MovimientoInventario m = new MovimientoInventario();
                m.setCodigo(rs.getString("codigo"));
                m.setIdTipo(rs.getString("idtipo"));
                m.setCodigoLote(rs.getString("codigo_lote"));
                m.setCantidad(rs.getInt("cantidad"));
                m.setCosto(rs.getDouble("costo"));
                m.setFecha(rs.getDate("fecha"));
                lista.add(m);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar movimientos: " + e.getMessage());
        }

        return lista;
    }
}
