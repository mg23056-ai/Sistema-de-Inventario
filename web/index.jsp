<%-- 
    Document   : index
    Created on : 8 nov 2025, 21:24:43
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<!DOCTYPE html>

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
                response.sendRedirect("auxiliar.jsp");
                return;
            }
        }
    }
%>


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
        </style>
    </head>
    <body>
        <form action="LoginServlet" method="POST">
            <h2>Iniciar Sesión</h2>
            <label for="codigo">Código de Usuario:</label>
            <input type="text" id="codigo" name="codigo" required>

            <label for="contrasena">Contraseña:</label>
            <input type="password" id="contrasena" name="contrasena" required>

            <input type="submit" value="Ingresar">
        </form>
        <%
            String error = request.getParameter("error");
            if (error != null && error.equals("1")) {
        %>
            <br/>
            <br/>
            <div style="color: red; text-align: center; margin-bottom: 10px;">
                <strong>Error al iniciar sesión:</strong> usuario o contraseña incorrectos.
            </div>
        <%
            }else {
                if (error != null && error.equals("2")) {
                %>
                    <br/>
                    <br/>
                    <div style="color: red; text-align: center; margin-bottom: 10px;">
                        <strong>Error al iniciar sesión:</strong> usted ya no cuenta con permisos para acceder.
                    </div>
                <%
                }else{
                    if ("3".equals(error)) {
                    %>
                        <br/><br/>
                        <div style="color: red; text-align: center;">
                            <strong>Error:</strong> Este usuario ya tiene una sesión activa en otro navegador.
                        </div>
                    <%
                    }
                }
            }
        %>
    </body>
</html>
