<%-- 
    Document   : kardex
    Created on : 12 nov 2025, 18:38:56
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kardex | RMT Systems</title>
    </head>
    <body>
        <table class="tabla-usuarios"> 
            <thead> 
                <tr> 
                    <th>Código</th> 
                    <th>Nombre</th> 
                    <th>Edad</th> 
                    <th>Rol</th> 
                    <th>Contraseña</th> 
                </tr> 
            </thead> 
            <tbody> 
                <% try { java.util.List<Usuario> usuarios = usuarioDAO.listarUsuariosPaginado(registrosPorPagina, offset);
                if (usuarios != null) { 
                    for (Usuario u : usuarios) { 
                        %> <tr>
                            <td><%= u.getId() %></td> 
                            <td><%= u.getNombre() %></td> 
                            <td><%= u.getEdad() %></td> 
                            <td><%= (u.getRol() != null ? u.getRol().getNombre() : "Sin rol") %></td>
                            <td><%= u.getContrasena() %></td> </tr> <% 
                                } 
                } else { 
                    %> <tr>
                        <td colspan="5">No hay usuarios para mostrar.</td>
                        </tr> <% } } catch (Exception e) { %> <tr>
                            <td colspan="5">Error al obtener usuarios: <%= e.getMessage() %></td>
                        </tr> <% } %> 
            </tbody> 
        </table>
    </body>
</html>
