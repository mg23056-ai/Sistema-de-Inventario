/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package menuAdmin;
import dao.MovimientoInventarioDAO;
import java.util.List;
import java.util.Date;
/**
 *
 * @author waldi
 */
public class MovimientoInventario {
    private String codigo;
    private String idTipo;        // id del tipo de movimiento
    private String codigoLote;    // producto relacionado
    private int cantidad;
    private double costo;
    private Date fecha;

    public MovimientoInventario() {}

    public MovimientoInventario(String codigo, String idTipo, String codigoLote, int cantidad, double costo, Date fecha) {
        this.codigo = codigo;
        this.idTipo = idTipo;
        this.codigoLote = codigoLote;
        this.cantidad = cantidad;
        this.costo = costo;
        this.fecha = fecha;
    }

    // Getters y setters
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getIdTipo() { return idTipo; }
    public void setIdTipo(String idTipo) { this.idTipo = idTipo; }

    public String getCodigoLote() { return codigoLote; }
    public void setCodigoLote(String codigoLote) { this.codigoLote = codigoLote; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getCosto() { return costo; }
    public void setCosto(double costo) { this.costo = costo; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    // Método para obtener todos los movimientos
    public static List<MovimientoInventario> obtenerMovimientos() {
        return new MovimientoInventarioDAO().listarMovimientos();
    }
}
