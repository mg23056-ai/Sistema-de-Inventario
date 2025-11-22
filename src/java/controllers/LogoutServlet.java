/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import models.Usuario;
/**
 *
 * @author waldi
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        if (sesion != null) {
            Usuario usuario = (Usuario) sesion.getAttribute("usuario");
            if (usuario != null) {
                SessionManager.eliminarSesion(usuario.getId());
            }
            sesion.invalidate();
        }

        response.sendRedirect("index.jsp");
    }
}
