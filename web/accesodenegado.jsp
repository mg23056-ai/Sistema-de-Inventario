<%-- 
    Document   : accesodenegado
    Created on : 8 nov 2025, 21:59:25
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%@ page import="bd.UsuarioDAO" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    String mensaje ="";
    if (!sesion.isActivo()) {
        mensaje = "<strong style='color:red;'>Usted ha sido inhabilitado</strong>";
    }
%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
        <title>Acceso Denegado</title>
        <style>
            body {
                background-color: #f8d7da;
                color: #721c24;
                font-family: Arial, sans-serif;
                text-align: center;
                padding-top: 100px;
            }
            a {
                background-color: #721c24;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
            }
            a:hover {
                background-color: #501217;
            }
        </style>
    </head>
    <body>
    <h2>Acceso denegado</h2>
        <p>No tienes permisos para acceder a esta sección.</p>
        <div class="mensaje">
            <%= mensaje %>
        </div>
        <p>Comunicate con el administrador.</p>
        <a href="index.jsp">Volver al inicio</a>
        <a href="LogoutServlet">Cerrar Sesion</a>
    </body>
</html>
