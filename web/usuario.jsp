<%-- 
    Document   : usuario
    Created on : 7 nov 2025, 17:28:27
    Author     : waldi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Usuario" %>
<%@page import="models.Rol" %>
<jsp:useBean id="usuarioDAO" scope="session" class="bd.UsuarioDAO" />
<jsp:useBean id="rolDAO" scope="session" class="bd.RolDAO" />

<%
String mensaje = ""; // variable para mostrar mensajes
if (request.getParameter("cmd") != null) {
    if (request.getParameter("cmd").equals("guardar")) {
        String id = request.getParameter("idtxt");
        String nombre = request.getParameter("nombretxt");
        String edad = request.getParameter("edadtxt");
        String rolCodigo = request.getParameter("rollst");
        String contrasena = request.getParameter("contrasenatxt");
        
        // Validación de campos requeridos
        if (id != null && nombre != null && edad != null && rolCodigo != null &&
            !id.isEmpty() && !nombre.isEmpty() && !edad.isEmpty() && !rolCodigo.isEmpty() && !contrasena.isEmpty()) {
            
            Rol rol = rolDAO.obtenerRolPorCodigo(rolCodigo);
            
            if (rol != null) {
                Usuario nuevoUsuario = new Usuario(id, nombre, Integer.parseInt(edad), rol, contrasena);
                if (usuarioDAO.insertarUsuario(nuevoUsuario)) {
                    mensaje = "<strong style='color:green;'>Guardado correctamente</strong>";
                } else {
                    mensaje = "<strong style='color:red;'>Ocurrió un error al guardar el usuario</strong>";
                }
            } else {
                mensaje = "<strong style='color:orange;'>El rol seleccionado no existe</strong>";
            }
            
        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }
}
%>


<%
    int pagina = 1;
    int registrosPorPagina = 10;

    if (request.getParameter("pagina") != null) {
        pagina = Integer.parseInt(request.getParameter("pagina"));
    }

    int offset = (pagina - 1) * registrosPorPagina;
    int totalRegistros = usuarioDAO.contarUsuarios();
    int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Crear Usuario | RMT Systems</title>
        <script type="text/javascript">
            function asignarAccion(accion) {
                document.forms['crearUsuario'].cmd.value = accion;
            }
        </script>
            <style>
                body {
                    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f4f6f8;
                    color: #333;
                    display: flex;
                    height: 100vh;
                    /* añadir: */
                    flex-direction: column; /* apila verticalmente (formulario arriba, tabla abajo) */
                    gap: 20px;              /* separación entre bloques */
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

                tr:nth-child(even) {
                    background-color: #f2f2f2;
                }

                tr:hover {
                    background-color: #e9f3ff;
                    transition: 0.3s;
                }
                .container {
                    width: 70%;
                    margin: 0 auto;
                }
                .tabla-usuarios {
                    border-collapse: collapse;
                    justify-content: center;
                    align-items: center;
                    width: 100%;
                    background: #fff;
                    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                    border-radius: 10px;
                    overflow: hidden;
                }
                .paginacion {
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                    margin-top: 12px;
                }
                .formulario {
                    width: 70%;
                    margin: 20px 0;
                    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                    margin-left: 275px; /*mover la mierda hacia la izquierda*/
                }

                .formulario table {
                    width: 100%;
                    border-collapse: collapse;
                    background: #fff;
                    border-radius: 10px;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
                }

                .formulario td {
                    padding: 10px;
                    font-size: 15px;
                    color: #333;
                }

                .formulario input[type="text"]{
                    width: 95%;
                    padding: 7px 10px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                    outline: none;
                    transition: border-color 0.3s;
                }

                .formulario input[type="text"]:focus{
                    border-color: #007bff;
                }
                
                select[name="rollst"] {
                    background-color: #34495e;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 8px 12px;
                    font-size: 14px;
                    width: 180px; /* ajusta según tu diseño */
                    cursor: pointer;
                    transition: all 0.3s ease;
                    outline: none;
                 }

                  /* Cuando el select tiene el foco (al hacer clic) */
                select[name="rollst"]:focus {
                    background-color: #3e5871;
                    box-shadow: 0 0 5px #1abc9c;
                }

                  /* Opcional: para los ítems del desplegable */
                select[name="rollst"] option {
                    background-color: #2c3e50;
                    color: white;
                }
                
                .formulario input[type="submit"] {
                    background-color: #007bff;
                    color: white;
                    border: none;
                    padding: 8px 18px;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 14px;
                    transition: background-color 0.3s;
                }

                .formulario input[type="submit"]:hover {
                    background-color: #0056b3;
                }

                .formulario .mensaje {
                    margin-top: 10px;
                    text-align: center;
                    font-weight: bold;
                }

                /* Panel superior */
                .topbar {
                    background-color: #2c3e50;
                    color: white;
                    display: flex;
                    align-items: center;        /* centra verticalmente los elementos */
                    justify-content: space-between; /* reparte los elementos en línea */
                    padding: 10px 30px;
                    height: 60px;
                    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                }

                .topbar h2 {
                    margin: 0;
                    font-size: 20px;
                }

                .topbar a {
                    color: white;
                    text-decoration: none;
                    padding: 10px 15px;
                    border-radius: 5px;
                    transition: background 0.3s, transform 0.2s;
                }

                .topbar a:hover {
                    background-color: #34495e;
                    transform: translateY(-2px); /* pequeño efecto de elevación */
                }

                  /* Si querés agrupar los enlaces a la derecha */
                .topbar-links {
                    display: flex;
                    gap: 10px;
                }

                /* Contenido principal */
                .content {
                    display: flex;           /* activa el modo flex */
                    flex-direction: row;     /* organiza los hijos en filas */
                    flex-wrap: wrap;         /* permite que los elementos salten a la siguiente fila si no caben */
                    gap: 20px;               /* separación entre elementos */
                    flex: 1;
                    padding: 20px;
                    background-color: #f4f4f4;
                    overflow-y: auto;
                  }
                .content2 {
                    flex: 1;
                    padding: 20px;
                    background-color: #f4f4f4;
                    overflow-y: auto;
                }
            </style>
        </head>
    <body>
        <nav class="topbar">
            <h2>Usuarios</h2>
            <a href="#">Alison</a>
            <a href="#">Carlos</a>
            <a href="#">Emerson</a>
            <a href="#">Pennis</a>
            <a href="index.html">Cerrar Sesion</a>
        </nav>

        <div class="content">
            <div class="formulario">
                <form id="crearUsuario" method="post" action="usuario.jsp">
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
                                    <td><select name="rollst"> 
                                            <%for (Rol rol : rolDAO.listarRoles()) {%>
                                            <option value="<%=rol.getCodigo()%>"><%=rol.getNombre()%>
                                            </option>
                                            <%}%>
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
                                    <input type="submit" value="Guardar" onclick="asignarAccion('guardar')"/>
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
            <div>
                <td>Mensaje de Prueba</td>
            </div>
            <div class="container">
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
                        <%
                    for (Usuario usuario : usuarioDAO.listarUsuariosPaginado(registrosPorPagina, offset)) {
                    %>
                    <tr>
                        <td><%=usuario.getId()%></td>
                        <td><%=usuario.getNombre()%></td>
                        <td><%=usuario.getEdad()%></td>
                        <td><%=usuario.getRol()%></td>
                        <td><%=usuario.getContrasena()%></td>
                    </tr>
                        <%
                         }
                        %>
                    </tbody>
                </table>
                <div class="paginacion">
                    <!-- Números de página -->
                    <div style="margin-bottom:10px;">
                        <%
                            for (int i = 1; i <= totalPaginas; i++) {
                                if (i == pagina) {
                        %>
                            <span style="margin:0 5px; font-weight:bold; color:#007bff;"><%=i%></span>
                        <%
                                } else {
                        %>
                            <a href="?pagina=<%=i%>" style="margin:0 5px; color:#007bff; text-decoration:none;"><%=i%></a>
                        <%
                                }
                            }
                        %>
                    </div>

                    <!-- Botones Anterior / Siguiente -->
                    <div>
                        <%
                            if (pagina > 1) {
                        %>
                            <a href="?pagina=<%=pagina - 1%>" 
                               style="padding:5px 10px; background:#007bff; color:white; text-decoration:none; border-radius:5px; margin-right:10px;">
                               Anterior
                            </a>
                        <%
                            }
                            if (pagina < totalPaginas) {
                        %>
                            <a href="?pagina=<%=pagina + 1%>" 
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
