/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import bd.UsuarioDAO;
import models.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 *
 * @author waldi
 */


@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet{
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String codigo = request.getParameter("codigo");
        String contrasena = request.getParameter("contrasena");
        String cmd = request.getParameter("cmd");  // Para detectar “forzar”

        UsuarioDAO dao = new UsuarioDAO();

        // Buscar usuario para validar si está activo
        Usuario e = dao.buscarUsuarioPorId(codigo);
        if (e == null) {
            response.sendRedirect("index.jsp?error=1");
            return;
        }

        if (!e.isActivo()) {
            response.sendRedirect("index.jsp?error=2");
            return;
        }

        //forzar cerrar sesion
        if ("forzar".equals(cmd)) {

            // Cerrar y eliminar la sesión que ya exista
            HttpSession sesionVieja = SessionManager.getSesion(codigo);
            if (sesionVieja != null) {
                try {
                    sesionVieja.invalidate();
                } catch (Exception ignored) {}
                SessionManager.eliminarSesion(codigo);
            }

            // Validar login después de forzar cierre
            Usuario u = dao.login(codigo, contrasena);

            if (u == null) {
                // Contraseña incorrecta en el forzado
                response.sendRedirect("index.jsp?error=1");
                return;
            }

            // Crear sesión nueva
            HttpSession nuevaSesion = request.getSession(true);
            nuevaSesion.setAttribute("usuario", u);

            SessionManager.registrarSesion(u.getId(), nuevaSesion);

            // Redirigir según rol
            redirigirPorRol(u, response);
            return;
        }

        // Login
        Usuario u = dao.login(codigo, contrasena);

        if (u != null) {
            if (SessionManager.isUsuarioConectado(u.getId())) {
                // Enviar también el código para reutilizarlo en el index.jsp
                response.sendRedirect("index.jsp?error=3&codigo=" + codigo);
                return;
            }

            // Crear sesión
            HttpSession sesion = request.getSession(true);
            sesion.setAttribute("usuario", u);

            // Registrar sesión
            SessionManager.registrarSesion(u.getId(), sesion);

            // Redirigir
            redirigirPorRol(u, response);
        } else {
            response.sendRedirect("index.jsp?error=1");
        }
    }

    private void redirigirPorRol(Usuario u, HttpServletResponse response) throws IOException {

        String rol = u.getRol().getNombre();
        if ("Administrador".equalsIgnoreCase(rol)) {
            response.sendRedirect("usuario.jsp");
        }else{
            if ("Gestor de Inventario".equalsIgnoreCase(rol)) {
                response.sendRedirect("producto.jsp");
            }else{
                if ("Bodeguero".equalsIgnoreCase(rol)) {
                    response.sendRedirect("crearlote.jsp");
                }else{
                    response.sendRedirect("auxiliar.jsp");
                }
            }
        }
    }
}
