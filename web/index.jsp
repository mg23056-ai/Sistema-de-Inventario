<%-- 
    Document   : index
    Created on : 8 nov 2025, 21:24:43
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%@ page session="true" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario != null) {
        if ("Administrador".equals(usuario.getRol().getNombre())) {
            response.sendRedirect("usuario.jsp");
            return;
        }else{
            if ("Gestor de Inventario".equals(usuario.getRol().getNombre())) {
                response.sendRedirect("producto.jsp");
                return;
            }else{
                if ("Bodeguero".equals(usuario.getRol().getNombre())) {
                    response.sendRedirect("crearlote.jsp");
                    return;
                }else{
                    if("Auditor".equals(usuario.getRol().getNombre())){
                        response.sendRedirect("kardex.jsp");
                        return;
                    }else{
                        response.sendRedirect("auxiliar.jsp");
                        return;
                    }
                }
            }
        }
    }
%>

<!DOCTYPE html>

<html>
    <head>
        <title>Entrar al sitio | RMT Systems</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                flex-direction: column;
            }
            form {
                background-color: white;
                padding: 20px 40px;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                width: 320px;
            }
            h2 {
                text-align: center;
                margin-bottom: 20px;
            }
            input {
                width: 100%;
                padding: 10px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }
            input[type="submit"] {
                background-color: #007bff;
                color: white;
                border: none;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #0056b3;
            }
            button {
                width: 100%;
                padding: 10px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                background-color: #007bff;
                color: white;
                cursor: pointer;
                border: none;
            }

            button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>

        <form action="LoginServlet" method="POST">
            <h2>Iniciar Sesión</h2>

            <label for="codigo">Código de Usuario:</label>
            <input type="text" id="codigo" name="codigo" required
                   value="<%= request.getParameter("codigo") != null ? request.getParameter("codigo") : "" %>">

            <label for="contrasena">Contraseña:</label>
            <input type="password" id="contrasena" name="contrasena" required>

            <input type="submit" value="Ingresar">
        </form>

        <%
            String error = request.getParameter("error");
            String codigoIntento = request.getParameter("codigo");

            if ("1".equals(error)) {
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> usuario o contraseña incorrectos.
            </div>

        <% } else if ("2".equals(error)) { %>

            <div style="color: red; text-align: center;">
                <strong>Error:</strong> usted ya no cuenta con permisos para acceder.
            </div>

        <% } else if ("3".equals(error)) { %>

            <div style="color: red; text-align: center; margin-top: 20px;">
                <strong>Error:</strong> Este usuario ya tiene una sesión activa en otro navegador.<br>
                ¿Desea cerrar esa sesión y continuar?
            </div>

            <form action="LoginServlet" method="POST" style="text-align:center; margin-top: 10px;">
                <input type="hidden" name="cmd" value="forzar">
                <input type="hidden" name="codigo" value="<%= codigoIntento %>">

                <label>Contraseña:</label>
                <input type="password" name="contrasena" required>

                <button type="submit">Cerrar otra sesión e ingresar</button>
            </form>

        <% } %>

    </body>
</html>
