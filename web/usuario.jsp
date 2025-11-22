<%-- 
    Document   : usuario
    Created on : 7 nov 2025, 17:28:27
    Author     : waldi (modificado)
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="models.Usuario" %>
<%@ page import="models.Rol" %>
<%@ page import="bd.UsuarioDAO" %>
<%@ page import="bd.RolDAO" %>
<%@ page session="true" %>

<%
    // Comprueba sesión
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Verificar si el rol es Administrador
    if (!"Administrador".equals(usuario.getRol().getNombre())) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Instanciar DAOs
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    RolDAO rolDAO = new RolDAO();
    
    //Revisa que el usuario esté activo
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    if (!sesion.isActivo()) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Mensaje de estado
    String mensaje = "";
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    // Guardar usuario
    if ("guardar".equals(request.getParameter("cmd"))) {
        String id = request.getParameter("idtxt");
        String nombre = request.getParameter("nombretxt");
        String edad = request.getParameter("edadtxt");
        String rolCodigo = request.getParameter("rollst");
        String contrasena = request.getParameter("contrasenatxt");
        String activoParam = request.getParameter("activolst"); // viene del select

        boolean activo = "true".equalsIgnoreCase(activoParam); // convierte texto a boolean

        if (id != null && nombre != null && edad != null && rolCodigo != null && contrasena != null && activoParam != null
                && !id.isEmpty() && !nombre.isEmpty() && !edad.isEmpty() && !rolCodigo.isEmpty() && !contrasena.isEmpty()) {
            try {
                Rol rol = rolDAO.obtenerRolPorCodigo(rolCodigo);
                if (!usuarioDAO.buscarUsuario(id)) {
                    if (rol != null) {
                        Usuario nuevoUsuario = new Usuario(id, nombre, Integer.parseInt(edad), rol, contrasena, activo);
                        boolean ok = usuarioDAO.insertarUsuario(nuevoUsuario);
                        if (ok) {
                            mensaje = "<strong style='color:green;'>Guardado correctamente</strong>";
                        } else {
                            mensaje = "<strong style='color:red;'>Ocurrió un error al guardar el usuario</strong>";
                        }
                    } else {
                        mensaje = "<strong style='color:orange;'>El rol seleccionado no existe</strong>";
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El ID de usuario ya existe</strong>";
                }
            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>La edad debe ser un número válido</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }

    // Editar usaurio
    if ("editar".equals(request.getParameter("cmd"))) {
        String id = request.getParameter("idtxt");
        String nombre = request.getParameter("nombretxt");
        String edad = request.getParameter("edadtxt");
        String rolCodigo = request.getParameter("rollst");
        String contrasena = request.getParameter("contrasenatxt");
        String activoParam = request.getParameter("activolst");

        boolean activo = "true".equalsIgnoreCase(activoParam);

        if (id != null && nombre != null && edad != null && rolCodigo != null && contrasena != null && activoParam != null
                && !id.isEmpty() && !nombre.isEmpty() && !edad.isEmpty() && !rolCodigo.isEmpty() && !contrasena.isEmpty()) {
            try {
                Rol rol = rolDAO.obtenerRolPorCodigo(rolCodigo);
                if (usuarioDAO.buscarUsuario(id)) {
                    if (rol != null) {
                        Usuario editarUsuario = new Usuario(id, nombre, Integer.parseInt(edad), rol, contrasena, activo);
                        boolean ok = usuarioDAO.actualizarUsuario(editarUsuario);
                        if (ok) {
                            mensaje = "<strong style='color:green;'>Usuario actualizado correctamente</strong>";
                        } else {
                            mensaje = "<strong style='color:red;'>Ocurrió un error al actualizar el usuario</strong>";
                        }
                    } else {
                        mensaje = "<strong style='color:orange;'>El rol seleccionado no existe</strong>";
                    }
                    if (usuario != null && usuario.getId().equals(id)) {
                        response.sendRedirect("LogoutServlet");
                        return;
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El ID de usuario no existe</strong>";
                }
            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>La edad debe ser un número válido</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }
        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }

    //Eliminar usuario
    if ("eliminar".equals(request.getParameter("cmd"))) {
        String id = request.getParameter("idtxt");
        if (usuarioDAO.eliminarUsuario(id)) {
            mensaje = "<strong style='color:green;'>Usuario eliminado correctamente</strong>";
        } else {
            mensaje = "<strong style='color:red;'>Ocurrió un error al eliminar el usuario</strong>";
        }
    }

    //Paginacion
    int pagina = 1;
    int registrosPorPagina = 10;
    if (request.getParameter("pagina") != null) {
        try {
            pagina = Integer.parseInt(request.getParameter("pagina"));
            if (pagina < 1) pagina = 1;
        } catch (NumberFormatException e) {
            pagina = 1;
        }
    }

    int offset = (pagina - 1) * registrosPorPagina;
    int totalRegistros = 0;
    int totalPaginas = 1;

    try {
        totalRegistros = usuarioDAO.contarUsuarios();
        totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
        if (totalPaginas < 1) totalPaginas = 1;
    } catch (Exception e) {
        mensaje = "<strong style='color:red;'>No se pudo obtener total de usuarios: " + e.getMessage() + "</strong>";
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuarios | RMT Systems</title>
        <script type="text/javascript">
            function asignarAccion(accion) {
                document.forms['crearUsuario'].cmd.value = accion;
            }
            
            const usuarioId = "<%= usuario.getId() %>";
            
            function editarUsuario(id, nombre, edad, rol, contrasena, activo) {
                const form = document.forms['crearUsuario'];
                const mensajeDiv = document.querySelector('.mensaje');
                document.forms['crearUsuario'].idtxt.value = id;
                document.forms['crearUsuario'].nombretxt.value = nombre;
                document.forms['crearUsuario'].edadtxt.value = edad;
                document.forms['crearUsuario'].rollst.value = rol;
                document.forms['crearUsuario'].contrasenatxt.value = contrasena;
                document.forms['crearUsuario'].activolst.value = activo === "true" ? "true" : "false";
                document.forms['crearUsuario'].cmd.value = "editar";
                
                if (usuarioId === id) {
                    mensajeDiv.innerHTML = "<strong style='color:orange;'>ADVERTENCIA: se cerrará sesión al editar este usuario.</strong>";
                } else {
                    if (mensajeDiv && mensajeDiv.textContent.trim().includes("se cerrará sesión al editar este usuario")) {
                        mensajeDiv.innerHTML = "<strong style='color:green;'>ADVERTENCIA: ahora está editando otro usuario. No se cerrará sesión.</strong>";
                    }
                }
            }

            function eliminarUsuario(id) {
                if (confirm("¿Seguro que deseas eliminar este usuario?")) {
                    const form = document.createElement("form");
                    form.method = "post";
                    form.action = "usuario.jsp";

                    const inputId = document.createElement("input");
                    inputId.type = "hidden";
                    inputId.name = "idtxt";
                    inputId.value = id;
                    form.appendChild(inputId);

                    const cmd = document.createElement("input");
                    cmd.type = "hidden";
                    cmd.name = "cmd";
                    cmd.value = "eliminar";
                    form.appendChild(cmd);

                    document.body.appendChild(form);
                    form.submit();
                }
            }
        </script>
        <style>
            body {
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f6f8;
                color: #333;
                display: flex;
                height: 100vh;
                flex-direction: column;
                gap: 20px;
                overflow: hidden;
            }
            th {
                background-color: #007bff;
                color: white;
                text-transform: uppercase;
                padding: 12px;
                font-size: 15px;
                letter-spacing: 0.5px;
            }
            td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }
            tr:nth-child(even) { background-color: #f2f2f2; }
            tr:hover { background-color: #e9f3ff; transition: 0.3s; }
            .container { width: 70%; margin: 0 auto; }
            .tabla-usuarios { border-collapse: collapse; justify-content: center; align-items: center; width: 100%; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 10px; overflow: hidden; }
            .paginacion { justify-content: center; align-items: center; text-align: center; margin-top: 12px; }
            .formulario { width: 70%; margin: 20px 0; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; margin-left: 275px; }
            .formulario table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
            .formulario td { padding: 10px; font-size: 15px; color: #333; }
            .formulario input[type="text"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="text"]:focus{ border-color: #007bff; }
            select[name="rollst"] { background-color: #34495e; color: white; border: none; border-radius: 8px; padding: 8px 12px; font-size: 14px; width: 180px; cursor: pointer; transition: all 0.3s ease; outline: none; }
            select[name="rollst"]:focus { background-color: #3e5871; box-shadow: 0 0 5px #1abc9c; }
            select[name="rollst"] option { background-color: #2c3e50; color: white; }
            .formulario input[type="submit"] { background-color: #007bff; color: white; border: none; padding: 8px 18px; border-radius: 5px; cursor: pointer; font-size: 14px; transition: background-color 0.3s; }
            .formulario input[type="submit"]:hover { background-color: #0056b3; }
            .formulario .mensaje { margin-top: 10px; text-align: center; font-weight: bold; }
            .topbar { background-color: #2c3e50; color: white; display: flex; align-items: center; justify-content: space-between; padding: 10px 30px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .topbar h2 { margin: 0; font-size: 20px; }
            .topbar a { color: white; text-decoration: none; padding: 10px 15px; border-radius: 5px; transition: background 0.3s, transform 0.2s; }
            .topbar a:hover { background-color: #34495e; transform: translateY(-2px); }
            .topbar-links { display: flex; gap: 10px; }
            .content { display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px; flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            .content2 { flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            
            select[name="activolst"] {
                background-color: #34495e;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 8px 12px;
                font-size: 14px;
                width: 180px;
                cursor: pointer;
                transition: all 0.3s ease;
                outline: none;
            }
            select[name="activolst"]:focus {
                background-color: #3e5871;
                box-shadow: 0 0 5px #1abc9c;
            }
            select[name="activolst"] option {
                background-color: #2c3e50;
                color: white;
            }
        </style>
    </head>
    <body>
        <nav class="topbar">
            <h2><%= user %></h2>
            <div class="topbar-links">
                <a href="usuario.jsp">Usuarios</a>
                <a href="kardex.jsp">Kardex</a>
                <a href="LogoutServlet">Cerrar Sesión</a>
            </div>
        </nav>

        <div class="content">
            <div class="formulario">
                <form id="crearUsuario" name="crearUsuario" method="post" action="usuario.jsp">
                    <table>
                        <tbody> 
                            <tr>
                                <td>Codigo:</td>
                                <td><input name="idtxt" type="text" placeholder="Ingrese un codigo"/></td>
                            </tr>
                            <tr>
                                <td>Nombre:</td>
                                <td><input name="nombretxt" type="text" placeholder="Ingrese un nombre y un apellido"/></td>
                            </tr>
                            <tr>
                                <td>Edad:</td>
                                <td><input name="edadtxt" type="text" placeholder="Ingrese la edad"/></td>
                            </tr>
                            <tr>
                                <td>Rol:</td>
                                <td>
                                    <select name="rollst">
                                        <%
                                            try {
                                                java.util.List<Rol> roles = rolDAO.listarRoles();
                                                if (roles != null) {
                                                    for (Rol rol : roles) {
                                        %>
                                                        <option value="<%= rol.getCodigo() %>"><%= rol.getNombre() %></option>
                                        <%
                                                    }
                                                } else {
                                        %>
                                                    <option value="">No hay roles</option>
                                        <%
                                                }
                                            } catch (Exception e) {
                                        %>
                                                <option value="">Error al cargar roles</option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Estado</td>
                                <td>
                                    <select name="activolst">
                                        <option value="true">Activo</option>
                                        <option value="false">Inactivo</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Contraseña:</td>
                                <td><input name="contrasenatxt" type="text" placeholder="Ingrese una contraseña"/></td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2" style="text-align:right;">
                                    <input type="submit" value="Crear" onclick="asignarAccion('guardar')"/>
                                    <input type="submit" value="Editar" onclick="asignarAccion('editar')"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="mensaje">
                        <%= mensaje %>
                    </div>

                    <input name="cmd" type="hidden"/>
                </form>
            </div>

            <div class="container">
                <table class="tabla-usuarios">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Edad</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th>Contraseña</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                java.util.List<Usuario> usuarios = usuarioDAO.listarUsuariosPaginado(registrosPorPagina, offset);
                                if (usuarios != null) {
                                    for (Usuario u : usuarios) {
                                        String rolNombre = (u.getRol() != null ? u.getRol().getNombre() : "Sin rol");
                                        String rolCodigo = (u.getRol() != null ? u.getRol().getCodigo() : "");
                        %>
                                        <tr>
                                            <td><%= u.getId() %></td>
                                            <td><%= u.getNombre() %></td>
                                            <td><%= u.getEdad() %></td>
                                            <td><%= rolNombre %></td>
                                            <td><%= u.isActivo() ? "Activo" : "Inactivo" %></td>
                                            <td><%= u.getContrasena() %></td>
                                            <td>
                                                <button type="button"
                                                        style="background:#28a745; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                                        onclick="editarUsuario('<%= u.getId() %>', '<%= u.getNombre() %>', '<%= u.getEdad() %>', '<%= rolCodigo %>', '<%= u.getContrasena() %>', '<%= u.isActivo() %>')">
                                                    Editar
                                                </button>
                                                <button type="button"
                                                        style="background:#dc3545; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                                        onclick="eliminarUsuario('<%= u.getId() %>')">
                                                    Eliminar
                                                </button>
                                            </td>
                                        </tr>
                        <%
                                    }
                                } else {
                        %>
                                    <tr><td colspan="7">No hay usuarios para mostrar.</td></tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="7">Error al obtener usuarios: <%= e.getMessage() %></td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <!-- Paginación -->
                <div class="paginacion">
                    <div style="margin-bottom:10px;">
                        <%
                            for (int i = 1; i <= totalPaginas; i++) {
                                if (i == pagina) {
                        %>
                                    <span style="margin:0 5px; font-weight:bold; color:#007bff;"><%= i %></span>
                        <%
                                } else {
                        %>
                                    <a href="?pagina=<%= i %>" style="margin:0 5px; color:#007bff; text-decoration:none;"><%= i %></a>
                        <%
                                }
                            }
                        %>
                    </div>

                    <div>
                        <%
                            if (pagina > 1) {
                        %>
                                <a href="?pagina=<%= pagina - 1 %>" 
                                   style="padding:5px 10px; background:#007bff; color:white; text-decoration:none; border-radius:5px; margin-right:10px;">
                                   Anterior
                                </a>
                        <%
                            }
                            if (pagina < totalPaginas) {
                        %>
                                <a href="?pagina=<%= pagina + 1 %>" 
                                   style="padding:5px 10px; background:#007bff; color:white; text-decoration:none; border-radius:5px; margin-left:10px;">
                                   Siguiente
                                </a>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
