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

        UsuarioDAO dao = new UsuarioDAO();
        Usuario e = dao.buscarUsuarioPorId(codigo);
        if (!e.isActivo()) {
            response.sendRedirect("index.jsp?error=2");
            return;
        }

        Usuario u = dao.login(codigo, contrasena);

        if (u != null) {
            //Comprobar si ya tiene sesión activa
            if (SessionManager.isUsuarioConectado(u.getId())) {
                response.sendRedirect("index.jsp?error=3"); // Error: sesión ya activa
                return;
            }

            // Crear sesión
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", u);

            // Registrar en el SessionManager
            SessionManager.registrarSesion(u.getId(), sesion);

            // Redirigir según rol
            if ("Administrador".equalsIgnoreCase(u.getRol().getNombre())) {
                response.sendRedirect("usuario.jsp");
            } else {
                response.sendRedirect("usuario.jsp");
            }
        } else {
            response.sendRedirect("index.jsp?error=1");
        }
    }
}
