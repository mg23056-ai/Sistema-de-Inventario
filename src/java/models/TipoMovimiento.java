/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import bd.TipoMovimientoDAO;
import java.util.List;
/**
 *
 * @author waldi
 */
public class TipoMovimiento {
    private String codigo;
    private String nombre;
    private String descripcion;

    public TipoMovimiento() {}

    public TipoMovimiento(String codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
    }

    public TipoMovimiento(String codigo, String nombre, String descripcion) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    // Getters y Setters
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    @Override
    public String toString() {
        return nombre; // útil para mostrar en JComboBox
    }

    // Método auxiliar para obtener todos los tipos de movimiento
    public static List<TipoMovimiento> obtenerTipos() {
        return new TipoMovimientoDAO().listarTipos();
    }
}