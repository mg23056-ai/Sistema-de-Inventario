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
    private String nombre;

    public Almacen() {}

    public Almacen(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    // Método auxiliar para obtener lista de nombres
    public static List<String> obtenerNombres() {
        return new AlmacenDAO().listarNombres();
    }
}
