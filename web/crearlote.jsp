<%-- 
    Document   : crearlote
    Created on : 15 nov 2025, 10:35:34
    Author     : waldi
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="models.Usuario" %>
<%@ page import="models.Rol" %>
<%@ page import="bd.UsuarioDAO" %>
<%@ page import="bd.RolDAO" %>
<%@ page session="true" %>

<%@ page import="models.Producto" %>
<%@ page import="models.Categoria" %>
<%@ page import="models.Proveedor" %>
<%@ page import="models.Almacen" %>
<%@ page import="models.Lote" %>

<%@ page import="bd.ProductoDAO" %>
<%@ page import="bd.CategoriaDAO" %>
<%@ page import="bd.ProveedorDAO" %>
<%@ page import="bd.AlmacenDAO" %>
<%@ page import="bd.LoteDAO" %>

<%
    // Comprueba sesión
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Verificar si el rol es Gestor de Inventario
    if (!"Bodeguero".equals(usuario.getRol().getNombre())) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Instanciar DAOs
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    CategoriaDAO categoriaDAO =new CategoriaDAO();
    ProveedorDAO proveedorDAO = new ProveedorDAO();
    AlmacenDAO almacenDAO = new AlmacenDAO();
    LoteDAO loteDAO = new LoteDAO();
    
    //Revisa que el usuario esté activo
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    if (!sesion.isActivo()) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Mensaje de estado
    String mensaje = "";
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    
    // Guardar Lote
    if ("guardar".equals(request.getParameter("cmd"))) {
        String codigo = request.getParameter("idtxt");
        String productoCodigo = request.getParameter("productotxt");
        String fechaIngresoTxt = request.getParameter("fechaIngresotxt");
        String fechaVencimientoTxt = request.getParameter("fechaVencimientotxt");
        String ubicacionCodigo = request.getParameter("almacenlst");
        String costoTxt = request.getParameter("costotxt");
        String observaciones = request.getParameter("observacionestxt");

        if (codigo != null && productoCodigo != null && fechaIngresoTxt != null
                && ubicacionCodigo != null && costoTxt != null
                && !codigo.isEmpty() && !productoCodigo.isEmpty()
                && !fechaIngresoTxt.isEmpty() && !ubicacionCodigo.isEmpty()
                && !costoTxt.isEmpty()) {

            try {
                int cantidad = 0; // Cantidad inicial
                double costoUnitario = Double.parseDouble(costoTxt);

                Producto producto = productoDAO.buscarProductoPorCodigo(productoCodigo);
                Almacen almacen = almacenDAO.obtenerAlmacenPorCodigo(ubicacionCodigo);

                if (producto == null) {
                    mensaje = "<strong style='color:orange;'>El producto ingresado no existe</strong>";
                } else if (almacen == null) {
                    mensaje = "<strong style='color:orange;'>El almacén seleccionado no existe</strong>";
                } else {
                    java.sql.Date fechaIngreso = java.sql.Date.valueOf(fechaIngresoTxt);
                    java.sql.Date fechaVencimiento = (fechaVencimientoTxt != null && !fechaVencimientoTxt.isEmpty())
                            ? java.sql.Date.valueOf(fechaVencimientoTxt) : null;

                    Lote nuevoLote = new Lote(
                            codigo,
                            producto,
                            cantidad,
                            fechaIngreso,
                            fechaVencimiento,
                            almacen,
                            costoUnitario,
                            observaciones
                    );

                    boolean ok = loteDAO.insertarLote(nuevoLote);

                    if (ok) {
                        mensaje = "<strong style='color:green;'>Lote guardado correctamente</strong>";
                    } else {
                        mensaje = "<strong style='color:red;'>Ocurrió un error al guardar el lote</strong>";
                    }
                }

            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>El costo debe ser un número válido</strong>";
            } catch (IllegalArgumentException iae) {
                mensaje = "<strong style='color:orange;'>Formato de fecha incorrecto</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos obligatorios</strong>";
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
        totalRegistros = productoDAO.contarProductos();
        totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
        if (totalPaginas < 1) totalPaginas = 1;
    } catch (Exception e) {
        mensaje = "<strong style='color:red;'>No se pudo obtener total de productos: " + e.getMessage() + "</strong>";
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Productos | RMT Systems</title>
        <script type="text/javascript">
            function asignarAccion(accion) {
                document.forms['crearLote'].cmd.value = accion;
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
            .tabla-productos { border-collapse: collapse; justify-content: center; align-items: center; width: 100%; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 10px; overflow: hidden; }
            .paginacion { justify-content: center; align-items: center; text-align: center; margin-top: 12px; }
            .formulario { width: 70%; margin: 20px 0; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; margin-left: 275px; }
            .formulario table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
            .formulario td { padding: 10px; font-size: 15px; color: #333; }
            .formulario input[type="text"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="text"]:focus{ border-color: #007bff; }
            .formulario input[type="number"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="number"]:focus{ border-color: #007bff; }
            .formulario input[type="submit"] { background-color: #007bff; color: white; border: none; padding: 8px 18px; border-radius: 5px; cursor: pointer; font-size: 14px; transition: background-color 0.3s; }
            .formulario input[type="submit"]:hover { background-color: #0056b3; }
            .formulario input[type="date"] {
                width: 95%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                outline: none;
                font-size: 14px;
                color: #333;
                background-color: #fff;
                transition: all 0.3s ease;
            }

            .formulario input[type="date"]:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }
            .formulario .mensaje { margin-top: 10px; text-align: center; font-weight: bold; }
            .topbar { background-color: #2c3e50; color: white; display: flex; align-items: center; justify-content: space-between; padding: 10px 30px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .topbar h2 { margin: 0; font-size: 20px; }
            .topbar a { color: white; text-decoration: none; padding: 10px 15px; border-radius: 5px; transition: background 0.3s, transform 0.2s; }
            .topbar a:hover { background-color: #34495e; transform: translateY(-2px); }
            .topbar-links { display: flex; gap: 10px; }
            .content { display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px; flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            .content2 { flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            select[name="almacenlst"] {
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
            select[name="almacenlst"]:focus {
                background-color: #3e5871;
                box-shadow: 0 0 5px #1abc9c;
            }
            select[name="almacenlst"] option {
                background-color: #2c3e50;
                color: white;
            }
        </style>
    </head>
    <body>
        <nav class="topbar">
            <h2><%= user %></h2>
            <div class="topbar-links">
                <a href="crearlote.jsp">Crear Lote</a>
                <a href="lotes.jsp">Ver Lotes</a>
                <a href="LogoutServlet">Cerrar Sesión</a>
            </div>
        </nav>

        <div class="content">
            <div class="formulario">
                <form id="crearLote" name="crearLote" method="post" action="crearlote.jsp">
                    <table>
                        <tbody> 
                            <tr>
                                <td>Codigo Lote:</td>
                                <td><input name="idtxt" type="text" placeholder="Ingrese un código"/></td>
                            </tr>

                            <tr>
                                <td>Producto ID:</td>
                                <td><input name="productotxt" type="text" placeholder="Ingrese ID del producto"/></td>
                            </tr>

                            

                            <tr>
                                <td>Fecha de Creación:</td>
                                <td><input name="fechaIngresotxt" type="date"/></td>
                            </tr>

                            <tr>
                                <td>Fecha de Vencimiento:</td>
                                <td><input name="fechaVencimientotxt" type="date"/></td>
                            </tr>

                            <tr>
                                <td>Ubicación</td>
                                <td>
                                    <select name="almacenlst">
                                        <%
                                            try {
                                                java.util.List<Almacen> almacenes = almacenDAO.listarAlmacenes();
                                                if (almacenes != null) {
                                                    for (Almacen almacen : almacenes) {
                                        %>
                                                        <option value="<%= almacen.getCodigo() %>"><%= almacen.getNombre() %></option>
                                        <%
                                                    }
                                                } else {
                                        %>
                                                    <option value="">No hay almacenes</option>
                                        <%
                                                }
                                            } catch (Exception e) {
                                        %>
                                                <option value="">Error al cargar almacenes</option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td>Costo Unitario:</td>
                                <td><input name="costotxt" type="number" step="0.01" min="0" placeholder="Ingrese costo unitario"/></td>
                            </tr>

                            <tr>
                                <td>Observaciones:</td>
                                <td><input name="observacionestxt" type="text" placeholder="Ingrese observaciones"/></td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="2" style="text-align:right;">
                                    <input type="submit" value="Crear" onclick="asignarAccion('guardar')"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="mensaje"><%= mensaje %></div>
                    <input name="cmd" type="hidden"/>
                </form>
            </div>
            <div class="container">
                <table class="tabla-productos">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Cantidad Asociada</th>
                            <th>Categoría</th>
                            <th>Proveedor</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            try {
                                java.util.List<Producto> productos = productoDAO.listarProductosPaginado(registrosPorPagina, offset);
                                if (productos != null) {
                                    for (Producto p : productos) {

                                        String catNombre = (p.getCategoria() != null ? p.getCategoria().getNombre() : "Sin categoría");
                                        String provNombre = (p.getProveedor() != null ? p.getProveedor().getNombre() : "Sin proveedor");
                        %>
                                        <tr>
                                            <td><%= p.getCodigo() %></td>
                                            <td><%= p.getNombre() %></td>
                                            <td><%= p.getDescripcion() %></td>
                                            <td><%= p.getCantidadAsociada() %></td>
                                            <td><%= catNombre %></td>
                                            <td><%= provNombre %></td>
                                            <td><%= p.isEstado() ? "Activo" : "Inactivo" %></td>

                                            <td>
                                                <button type="button"
                                                    style="background:#28a745; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                                    onclick="document.forms['crearLote'].productotxt.value='<%= p.getCodigo() %>'; document.querySelector('.mensaje').innerHTML='<span style=\'color:black;\'>Se ha seleccionado ' + '<%= p.getNombre() %>' +'</span>';">
                                                Crear Lote
                                            </button>
                                            </td>
                                        </tr>
                        <%
                                    }
                                } else {
                        %>
                                    <tr><td colspan="8">No hay productos para mostrar.</td></tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="8">Error al obtener productos: <%= e.getMessage() %></td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <!-- PAGINACIÓN -->
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
