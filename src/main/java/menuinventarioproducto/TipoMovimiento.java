/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuinventarioproducto;
import dao.TipoMovimientoDAO;
import java.util.List;
/**
 *
 * @author waldi
 */
public class TipoMovimiento {
    private String idTipo;
    private String nombre;
    private String descripcion;

    public TipoMovimiento() {}

    public TipoMovimiento(String idTipo, String nombre) {
        this.idTipo = idTipo;
        this.nombre = nombre;
    }

    // Getters y setters
    public String getIdTipo() { return idTipo; }
    public void setIdTipo(String idTipo) { this.idTipo = idTipo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    @Override
    public String toString() {
        return nombre; // Para que el JComboBox muestre el nombre
    }

    // Método auxiliar para obtener todos los tipos de movimiento
    public static List<TipoMovimiento> obtenerTipos() {
        return new TipoMovimientoDAO().listarTipos();
    }
}
