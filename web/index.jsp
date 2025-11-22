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
                margin: 0;
                padding: 0;
                background: #f2f2f2;
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                width: 900px;
                height: 520px;
                background: white;
                border-radius: 20px;
                display: flex;
                overflow: hidden;
                box-shadow: 0 6px 25px rgba(0,0,0,0.15);
            }

            /* Panel izquierdo con imagen */
            .left-panel {
                width: 50%;
                background: #eee;
            }

            .left-panel img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* Panel derecho con formulario */
            .right-panel {
                width: 50%;
                padding: 40px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }

            .logo {
                width: 110px;
                margin-bottom: 20px;
            }

            .form-input {
                width: 100%;
                margin-bottom: 15px;
                position: relative;
            }

            .form-input input {
                width: 100%;
                padding: 12px 40px 12px 40px;
                border-radius: 8px;
                border: 1px solid #ccc;
                font-size: 15px;
            }

            .form-input i {
                position: absolute;
                left: 12px;
                top: 13px;
                font-size: 18px;
                color: #555;
            }

            .submit-btn {
                width: 100%;
                padding: 12px;
                background: #34495e;   /* Azul */
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 10px;
            }

            .submit-btn:hover {
                background: #34495e;   /* Azul más oscuro */
            }

            .error-msg {
                margin-top: 15px;
                color: #b30000;
                font-weight: bold;
                text-align: center;
            }

            .force-form {
                margin-top: 15px;
                width: 90%;
                text-align: center;
            }

            .force-form input,
            .force-form button {
                width: 80%;
                padding: 10px;
                border-radius: 8px;
                margin-top: 10px;
            }
            .right-panel form {
                width: 80%;          /* Reduce el ancho para que no se desborde */
                max-width: 330px;    /* Límite máximo para evitar que se abra más */
            }

            .form-input input {
                width: 75%;         /* Mantiene el input ajustado al form */
            }
        </style>

        <!-- Iconos (FontAwesome CDN) -->
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body>

        <div class="container">
            <!-- Panel izquierdo con tu imagen -->
            <div class="left-panel">
                <img src="img/rmt.jpg" alt="Imagen">
            </div>

            <!-- Panel derecho (formulario) -->
            <div class="right-panel">

                <img src="img/rmt.jpg" class="logo" alt="Logo">

                <form action="LoginServlet" method="POST" style="width:100%;">

                    <div class="form-input">
                        <i class="fa fa-user"></i>
                        <input type="text" id="codigo" name="codigo" placeholder="Ingrese su código"
                               required
                               value="<%= request.getParameter("codigo") != null ? request.getParameter("codigo") : "" %>">
                    </div>

                    <div class="form-input">
                        <i class="fa fa-lock"></i>
                        <input type="password" id="contrasena" name="contrasena" placeholder="Contraseña" required>
                    </div>

                    <input type="submit" value="Acceder" class="submit-btn">
                </form>

                <!-- Mensajes de error -->
                <%
                    String error = request.getParameter("error");
                    String codigoIntento = request.getParameter("codigo");

                    if ("1".equals(error)) {
                %>
                    <div class="error-msg">Usuario o contraseña incorrectos.</div>

                <% } else if ("2".equals(error)) { %>

                    <div class="error-msg">No cuenta con permisos para acceder.</div>

                <% } else if ("3".equals(error)) { %>

                    <div class="error-msg">Ya existe una sesión activa. ¿Desea continuar?</div>

                    <form action="LoginServlet" method="POST" class="force-form">
                        <input type="hidden" name="cmd" value="forzar">
                        <input type="hidden" name="codigo" value="<%= codigoIntento %>">

                        <input type="password" name="contrasena" placeholder="Contraseña" required>
                        <button type="submit" style="background:#34495e;color:white;border:none;">Forzar acceso</button>
                    </form>
                <% } %>
            </div>
        </div>
    </body>
</html>
