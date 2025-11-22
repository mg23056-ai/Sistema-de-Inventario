/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import java.sql.Date;
/**
 *
 * @author waldi
 */
public class Lote {

    private String codigo;
    private Producto producto;
    private int cantidad;
    private Date fechaIngreso;
    private Date fechaVencimiento;
    private Almacen ubicacion;
    private double costoUnitario;
    private String observaciones;

    public Lote(String codigo, Producto producto, int cantidad, Date fechaIngreso,
                Date fechaVencimiento, Almacen ubicacion, double costoUnitario,
                String observaciones) {

        this.codigo = codigo;
        this.producto = producto;
        this.cantidad = cantidad;
        this.fechaIngreso = fechaIngreso;
        this.fechaVencimiento = fechaVencimiento;
        this.ubicacion = ubicacion;
        this.costoUnitario = costoUnitario;
        this.observaciones = observaciones;
    }

    // Constructor mínimo (solo código)
    public Lote(String codigo) {
        this.codigo = codigo;
    }

    // Getters y Setters
    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Date getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(Date fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
    }

    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public Almacen getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(Almacen ubicacion) {
        this.ubicacion = ubicacion;
    }

    public double getCostoUnitario() {
        return costoUnitario;
    }

    public void setCostoUnitario(double costoUnitario) {
        this.costoUnitario = costoUnitario;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    @Override
    public String toString() {
        return "Lote " + codigo + " - Producto: " + (producto != null ? producto.getNombre() : "N/A");
    }
}
