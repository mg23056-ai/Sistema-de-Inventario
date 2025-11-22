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
        Usuario u = dao.login(codigo, contrasena); // Buscar usuario en BD

        if (u != null) {
            // Crear sesión
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", u);

            // Redirigir según rol
            if (u.getRol().getNombre().equalsIgnoreCase("administrador")) {
                response.sendRedirect("usuario.jsp");
            } else {
                response.sendRedirect("usuario.jsp");
            }
        } else {
            response.sendRedirect("index.jsp?error=1");
        }
    }
}
