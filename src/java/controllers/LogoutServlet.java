/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 *
 * @author waldi
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet{
        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sesion = request.getSession(false); // No crear si no existe
        if (sesion != null) {
            sesion.invalidate(); // Elimina la sesión
        }
        response.sendRedirect("index.jsp"); // Regresa al login
    }
}
