/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuinventarioproducto;
import dao.AlmacenDAO;
import java.util.List;

/**
 *
 * @author waldi
 */
public class Almacen {
    private String codigo;
    private String nombre;
    private String ubicacion;

    public Almacen() {}

    // Getters y setters
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    // Método auxiliar para obtener todos los almacenes
    public static List<Almacen> obtenerAlmacenes() {
        AlmacenDAO dao = new AlmacenDAO();
        return dao.listarAlmacenes();
    }

    @Override
    public String toString() {
        return nombre; // Esto permite que el JComboBox muestre el nombre
    }
}
