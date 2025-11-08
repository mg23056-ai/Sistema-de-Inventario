/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuinventarioproducto;
import dao.CategoriaDAO;
import java.util.List;
/**
 *
 * @author waldi
 */
public class Categoria {
    private String codigo;
    private String nombre;

    public Categoria() {}

    public Categoria(String codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
    }
    
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    @Override
    public String toString() {
        return nombre; // Esto permite que el JComboBox muestre el nombre
    }

    // Método auxiliar para obtener todas las categorías
    public static List<Categoria> obtenerCategorias() {
        return new CategoriaDAO().listarCategorias();
    }
}
