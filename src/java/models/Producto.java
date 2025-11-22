/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author waldi
 */
public class Producto {

    private String codigo;
    private String nombre;
    private Categoria categoria;
    private String descripcion;
    private int cantidadAsociada;     // cambiado
    private Proveedor proveedor;
    private boolean estado;

    public Producto(String codigo, String nombre, Categoria categoria, String descripcion,
                    int cantidadAsociada, Proveedor proveedor, boolean estado) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.categoria = categoria;
        this.descripcion = descripcion;
        this.cantidadAsociada = cantidadAsociada;
        this.proveedor = proveedor;
        this.estado = estado;
    }

    public Producto(String codigo) {
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getCantidadAsociada() {
        return cantidadAsociada;
    }

    public void setCantidadAsociada(int cantidadAsociada) {
        this.cantidadAsociada = cantidadAsociada;
    }

    public Proveedor getProveedor() {
        return proveedor;
    }

    public void setProveedor(Proveedor proveedor) {
        this.proveedor = proveedor;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return nombre + " (" + codigo + ")";
    }
}
