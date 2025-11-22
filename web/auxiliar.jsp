<%-- 
    Document   : auxiliar
    Created on : 8 nov 2025, 22:16:50
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Auxiliar</title>

        <style>
            body {
                background-color: #ffffff; /* Fondo blanco */
                font-family: Arial, Helvetica, sans-serif;
                text-align: center;
                padding-top: 60px;
            }

            h1 {
                color: #d9534f; /* Rojo suave de alerta */
                font-size: 32px;
                margin-bottom: 20px;
            }

            img {
                margin: 20px 0;
                border-radius: 10px;
                box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
            }

            a {
                display: inline-block;
                margin-top: 25px;
                padding: 10px 20px;
                background-color: #0275d8;
                color: #fff;
                text-decoration: none;
                font-weight: bold;
                border-radius: 6px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: background 0.2s ease;
            }

            a:hover {
                background-color: #025aa5;
            }
        </style>
    </head>

    <body>
        <h1>¡Ocurrió un Error!</h1>
        <img src="img/sick.jpg" alt="Imagen de error" width="250" />
        <br>
        <%
            String error = request.getParameter("error");

            if ("1".equals(error)) {
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> Usted no existe.
            </div>
        <% 
            }else if ("2".equals(error)) {
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> Usted no está activo.
            </div>
        <%
            }else if ("3".equals(error)){
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> Sesion activa en otro navegador.
            </div>
        <%
            }else if ("4".equals(error)){
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> Usted no tiene permisos para acceder a algún sitio.
            </div>
        <%
            }else{
        %>
            <div style="color: red; text-align: center;">
                <strong>Error:</strong> Error desconocido.
            </div>
        <%
            }
        %>
        <a href="LogoutServlet">Cerrar Sesión</a>
    </body>
</html>

