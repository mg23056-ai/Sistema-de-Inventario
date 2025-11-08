/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import menuinventarioproducto.TipoMovimiento;
import Conexion.Conexion;
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
        String sql = "SELECT idtipo, nombre, descripcion FROM tipo_movimiento ORDER BY nombre";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TipoMovimiento t = new TipoMovimiento();
                t.setIdTipo(rs.getString("idtipo"));
                t.setNombre(rs.getString("nombre"));
                t.setDescripcion(rs.getString("descripcion"));
                lista.add(t);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar tipos de movimiento: " + e.getMessage());
        }

        return lista;
    }
}
