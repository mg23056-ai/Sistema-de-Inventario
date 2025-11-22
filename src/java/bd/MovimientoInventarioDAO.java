/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bd;
import models.MovimientoInventario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.TipoMovimiento;
/**
 *
 * @author waldi
 */
public class MovimientoInventarioDAO {

    // LISTAR MOVIMIENTOS (PAGINADO)
    public List<MovimientoInventario> listarMovimientos(int limit, int offset) {

        List<MovimientoInventario> lista = new ArrayList<>();

        String sql = """
            SELECT m.codigo, m.idtipo, m.afectado, m.cantidad, m.costo_movimiento,
                   m.antigua_ubicacion, m.nueva_ubicacion, m.fecha, m.actor,

                   t.codigo AS tipo_codigo,
                   t.nombre AS tipo_nombre,
                   t.descripcion AS tipo_descripcion
            FROM movimiento_inventario m
            JOIN tipo_movimiento t ON m.idtipo = t.codigo
            ORDER BY m.fecha DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    // Mapear TipoMovimiento
                    TipoMovimiento tipo = new TipoMovimiento(
                        rs.getString("tipo_codigo"),
                        rs.getString("tipo_nombre"),
                        rs.getString("tipo_descripcion")
                    );

                    // Mapear MovimientoInventario incluyendo actor
                    MovimientoInventario mov = new MovimientoInventario(
                        rs.getString("codigo"),
                        tipo,
                        rs.getString("afectado"),
                        rs.getInt("cantidad"),
                        rs.getDouble("costo_movimiento"),
                        rs.getString("antigua_ubicacion"),
                        rs.getString("nueva_ubicacion"),
                        rs.getDate("fecha"),
                        rs.getString("actor")  // ← NUEVO CAMPO
                    );

                    lista.add(mov);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar movimientos: " + e.getMessage());
        }

        return lista;
    }

    // INSERTAR MOVIMIENTO
    public boolean insertarMovimiento(MovimientoInventario m) {

        String sql = """
            INSERT INTO movimiento_inventario
            (codigo, idtipo, afectado, cantidad, costo_movimiento,
             antigua_ubicacion, nueva_ubicacion, fecha, actor)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getCodigo());
            ps.setString(2, m.getTipoMovimiento().getCodigo());
            ps.setString(3, m.getAfectado());
            ps.setInt(4, m.getCantidad());
            ps.setDouble(5, m.getCostoMovimiento());
            ps.setString(6, m.getAntiguaUbicacion());
            ps.setString(7, m.getNuevaUbicacion());
            ps.setDate(8, new java.sql.Date(m.getFecha().getTime()));
            ps.setString(9, m.getActor()); // ← NUEVO CAMPO

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error al insertar movimiento: " + e.getMessage());
            return false;
        }
    }

    // CONTAR MOVIMIENTOS (SIN CAMBIOS)
    public int contarMovimientos() {
        String sql = "SELECT COUNT(*) AS total FROM movimiento_inventario";

        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar movimientos: " + e.getMessage());
        }

        return 0;
    }
}