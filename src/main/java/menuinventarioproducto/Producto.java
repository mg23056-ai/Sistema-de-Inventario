/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuinventarioproducto;
import dao.ProductoDAO;
import java.util.List;
import java.util.Date;
/**
 *
 * @author waldi
 */
public class Producto {
    private String codigoLote;
    private String nombre;
    private int cantidad;
    private String almacenCodigo;
    private String proveedorNit;
    private String categoriaCodigo;
    private Date fechaDeVencimiento;
    private String descripcion;
    private double costo;

    public Producto() {}

    // Getters y setters
    public String getCodigoLote() { return codigoLote; }
    public void setCodigoLote(String codigoLote) { this.codigoLote = codigoLote; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public String getAlmacenCodigo() { return almacenCodigo; }
    public void setAlmacenCodigo(String almacenCodigo) { this.almacenCodigo = almacenCodigo; }

    public String getProveedorNit() { return proveedorNit; }
    public void setProveedorNit(String proveedorNit) { this.proveedorNit = proveedorNit; }

    public String getCategoriaCodigo() { return categoriaCodigo; }
    public void setCategoriaCodigo(String categoriaCodigo) { this.categoriaCodigo = categoriaCodigo; }

    public Date getFechaDeVencimiento() { return fechaDeVencimiento; }
    public void setFechaDeVencimiento(Date fechaDeVencimiento) { this.fechaDeVencimiento = fechaDeVencimiento; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public double getCosto() { return costo; }
    public void setCosto(double costo) { this.costo = costo; }

    // Método auxiliar para obtener lista de productos
    public static List<Producto> obtenerProductos() {
        ProductoDAO dao = new ProductoDAO();
        return dao.listarProductos();
    }
}
