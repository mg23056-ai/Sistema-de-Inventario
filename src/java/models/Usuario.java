/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author waldi
 */
public class Usuario {
    private String id;
    private String nombre;
    private int edad;
    private Rol rol;
    private String contrasena;

    public Usuario(String id, String nombre, int edad, Rol rol, String contrasena) {
        this.id = id;
        this.nombre = nombre;
        this.edad = edad;
        this.rol = rol;
        this.contrasena = contrasena;
    }

    public Usuario(String id, String nombre, Rol rol) {
        this.id = id;
        this.nombre = nombre;
        this.rol = rol;
    }

    public Usuario() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    public Rol getRol() { return rol; }
    public void setRol(Rol rol) { this.rol = rol; }

    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }
}
