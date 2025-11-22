/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import bd.MovimientoInventarioDAO;
import java.util.List;
import java.util.Date;
/**
 *
 * @author waldi
 */
public class MovimientoInventario {
    private String codigo;
    private String idTipo;
    private String afectado;
    private int cantidad;
    private double costoMovimiento;
    private Date fecha;
    private String usuario;

    public MovimientoInventario() {}

    public MovimientoInventario(String codigo, String idTipo, String afectado, int cantidad, double costoMovimiento, Date fecha, String usuario) {
        this.codigo = codigo;
        this.idTipo = idTipo;
        this.afectado = afectado;
        this.cantidad = cantidad;
        this.costoMovimiento = costoMovimiento;
        this.fecha = fecha;
        this.usuario = usuario;
    }

    // Getters y Setters
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getIdTipo() { return idTipo; }
    public void setIdTipo(String idTipo) { this.idTipo = idTipo; }

    public String getAfectado() { return afectado; }
    public void setAfectado(String afectado) { this.afectado = afectado; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getCostoMovimiento() { return costoMovimiento; }
    public void setCostoMovimiento(double costoMovimiento) { this.costoMovimiento = costoMovimiento; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }

    // Método para obtener todos los movimientos
    public static List<MovimientoInventario> obtenerMovimientos() {
        return new MovimientoInventarioDAO().listarMovimientos();
    }
}