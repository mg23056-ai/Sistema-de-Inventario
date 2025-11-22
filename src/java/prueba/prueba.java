/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package prueba;
import bd.AlmacenDAO;
import bd.LoteDAO;
import bd.MovimientoInventarioDAO;
import bd.ProductoDAO;
import bd.UsuarioDAO;
import java.text.SimpleDateFormat;
import java.util.List;
import models.Almacen;
import models.Lote;
import models.Producto;
import models.Usuario;
/**
 *
 * @author waldi
 */
public class prueba {

    public static void main(String[] args) {

        // Simulación del objeto MovimientoInventario
        MovimientoInventario m = new MovimientoInventario();
        m.setActor("HC2025   ");  // Aquí podés poner lo que estás viendo

        probarActor(m);
    }

    public static void probarActor(MovimientoInventario m) {

        System.out.println("=== PRUEBA DE ACTOR ===");

        String actor = m.getActor();

        System.out.println("Actor ORIGINAL     : [" + actor + "]");
        System.out.println("Largo original     : " + (actor != null ? actor.length() : 0));

        if (actor != null) actor = actor.trim();

        System.out.println("Actor con trim()   : [" + actor + "]");
        System.out.println("Largo con trim     : " + actor.length());

        // Aquí simulamos "buscar en BD"
        if ("HC2025".equals(actor)) {
            System.out.println("✔ Coincide con usuario HC2025");
        } else {
            System.out.println("❌ No coincide con usuario HC2025");
        }
    }
}


// Clase mínima para que compile
class MovimientoInventario {
    private String actor;

    public String getActor() { return actor; }
    public void setActor(String a) { this.actor = a; }
}