/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuinventarioproducto;
import dao.ProveedorDAO;
import java.util.List;
/**
 *
 * @author waldi
 */
public class Proveedor {
    private String nit;
    private String nombre;
    private String direccion;
    private String contacto;

    public Proveedor() {}

    public Proveedor(String nit, String nombre) {
        this.nit = nit;
        this.nombre = nombre;
    }

    public String getNit() { return nit; }
    public void setNit(String nit) { this.nit = nit; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getContacto() { return contacto; }
    public void setContacto(String contacto) { this.contacto = contacto; }

    @Override
    public String toString() {
        return nombre; // Para que el JComboBox muestre el nombre
    }

    // Método auxiliar para obtener todos los proveedores
    public static List<Proveedor> obtenerProveedores() {
        return new ProveedorDAO().listarProveedores();
    }
}
