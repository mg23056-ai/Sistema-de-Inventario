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
    private TipoMovimiento tipoMovimiento;  // Objeto relacionado
    private String afectado;
    private int cantidad;
    private double costoMovimiento;
    private String antiguaUbicacion;
    private String nuevaUbicacion;
    private Date fecha;
    private String actor;   // ← NUEVO CAMPO

    public MovimientoInventario() {}

    public MovimientoInventario(
            String codigo,
            TipoMovimiento tipoMovimiento,
            String afectado,
            int cantidad,
            double costoMovimiento,
            String antiguaUbicacion,
            String nuevaUbicacion,
            Date fecha,
            String actor   // ← NUEVO PARÁMETRO
    ) {
        this.codigo = codigo;
        this.tipoMovimiento = tipoMovimiento;
        this.afectado = afectado;
        this.cantidad = cantidad;
        this.costoMovimiento = costoMovimiento;
        this.antiguaUbicacion = antiguaUbicacion;
        this.nuevaUbicacion = nuevaUbicacion;
        this.fecha = fecha;
        this.actor = actor;
    }

    // Getters y Setters
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public TipoMovimiento getTipoMovimiento() { return tipoMovimiento; }
    public void setTipoMovimiento(TipoMovimiento tipoMovimiento) { this.tipoMovimiento = tipoMovimiento; }

    public String getAfectado() { return afectado; }
    public void setAfectado(String afectado) { this.afectado = afectado; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getCostoMovimiento() { return costoMovimiento; }
    public void setCostoMovimiento(double costoMovimiento) { this.costoMovimiento = costoMovimiento; }

    public String getAntiguaUbicacion() { return antiguaUbicacion; }
    public void setAntiguaUbicacion(String antiguaUbicacion) { this.antiguaUbicacion = antiguaUbicacion; }

    public String getNuevaUbicacion() { return nuevaUbicacion; }
    public void setNuevaUbicacion(String nuevaUbicacion) { this.nuevaUbicacion = nuevaUbicacion; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public String getActor() { return actor; }
    public void setActor(String actor) { this.actor = actor; }
}
