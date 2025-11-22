/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.http.HttpSession;
/**
 *
 * @author waldi
 */
public class SessionManager {
    // Guarda usuario -> sesión
    private static final ConcurrentHashMap<String, HttpSession> sesionesActivas = new ConcurrentHashMap<>();

    public static boolean isUsuarioConectado(String userId) {
        return sesionesActivas.containsKey(userId);
    }

    public static void registrarSesion(String userId, HttpSession session) {
        sesionesActivas.put(userId, session);
    }

    public static void eliminarSesion(String userId) {
        sesionesActivas.remove(userId);
    }

    public static HttpSession getSesion(String userId) {
        return sesionesActivas.get(userId);
    }
}
