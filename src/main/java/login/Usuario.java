/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package login;

/**
 *
 * @author waldi
 */
public class Usuario {
    private String id;
    private String nombre;
    private int edad;
    private String rol;
    private String contrasenia;

    // Constructor vacío
    public Usuario() {}

    // Constructor completo
    public Usuario(String id, String nombre, int edad, String rol, String contrasenia) {
        this.id = id;
        this.nombre = nombre;
        this.edad = edad;
        this.rol = rol;
        this.contrasenia = contrasenia;
    }

    // Getters y Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public String getContrasenia() { return contrasenia; }
    public void setContrasenia(String contrasenia) { this.contrasenia = contrasenia; }
}
