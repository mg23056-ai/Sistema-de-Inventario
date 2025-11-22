/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import models.MovimientoInventario;
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
        String sql = "SELECT codigo, idtipo, afectado, cantidad, costo_movimiento, fecha, usuario FROM movimiento_inventario ORDER BY fecha DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MovimientoInventario m = new MovimientoInventario();
                m.setCodigo(rs.getString("codigo"));
                m.setIdTipo(rs.getString("idtipo"));
                m.setAfectado(rs.getString("afectado"));
                m.setCantidad(rs.getInt("cantidad"));
                m.setCostoMovimiento(rs.getDouble("costo_movimiento"));
                m.setFecha(rs.getDate("fecha"));
                m.setUsuario(rs.getString("usuario"));
                lista.add(m);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar movimientos: " + e.getMessage());
        }

        return lista;
    }
}