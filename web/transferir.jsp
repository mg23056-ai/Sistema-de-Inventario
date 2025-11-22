<%-- 
    Document   : transferir
    Created on : 14 nov 2025, 18:36:53
    Author     : waldi
--%>

<%@page import="java.util.UUID"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<%@ page import="models.MovimientoInventario" %>
<%@ page import="models.TipoMovimiento" %>

<%@ page import="bd.ProductoDAO" %>
<%@ page import="bd.CategoriaDAO" %>
<%@ page import="bd.ProveedorDAO" %>
<%@ page import="bd.AlmacenDAO" %>
<%@ page import="bd.LoteDAO" %>
<%@ page import="bd.MovimientoInventarioDAO" %>
<%@ page import="bd.TipoMovimientoDAO" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Verificar si el rol es Gestor de Inventario
    if (!"Gestor de Inventario".equals(usuario.getRol().getNombre())) {
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
    MovimientoInventarioDAO movimientoDAO = new MovimientoInventarioDAO();
    
    //Revisa que el usuario esté activo
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    if (!sesion.isActivo()) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }

    //Mensajes
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    String mensaje = "";
    String cantidadtitulo = "";
    String producto = "No seleccinoado";
    
    //Trasladar producto
    if("trasladar".equals(request.getParameter("cmd"))){
        String codigo = request.getParameter("idtxt");
        String productoId = request.getParameter("productotxt");
        String almacenCodigo = request.getParameter("almacenlst");
        String nuevoAlmacenCodigo = request.getParameter("nuevoalmacenlst");
        String costo = request.getParameter("trasladotxt");
        
        if(codigo != null && almacenCodigo != null && nuevoAlmacenCodigo != null && costo != null &&
        !codigo.isEmpty() && !almacenCodigo.isEmpty() && !nuevoAlmacenCodigo.isEmpty() && !costo.isEmpty()){
            mensaje = "<strong style='color:red;'>Eureka</strong>";
            try {
                if (loteDAO.existeLote(codigo)) {
                    // Obtener objetos relacionados
                    Producto prodSelect = productoDAO.buscarProductoPorCodigo(productoId);
                    Lote lote = loteDAO.buscarLotePorCodigo(codigo);
                    Almacen almacenActual = almacenDAO.obtenerAlmacenPorCodigo(lote.getUbicacion().getCodigo()); 
                    Almacen almacenNuevo = almacenDAO.obtenerAlmacenPorCodigo(nuevoAlmacenCodigo);
                    if (prodSelect == null) {
                        mensaje = "<strong style='color:orange;'>El lote no posee producto</strong>";
                    } else if (almacenNuevo == null) {
                        mensaje = "<strong style='color:orange;'>El lote no ha sido asignado a un almacen</strong>";
                    } else if (almacenActual.getCodigo().equals(almacenNuevo.getCodigo())) {
                        mensaje = "<strong style='color:red;'>No debe ser el mismo almacen</strong>";
                    } else if (Double.parseDouble(costo) <= 0) {
                        mensaje = "<strong style='color:red;'>El costo no es un valor aceptable</strong>";
                    } else {
                        boolean actualizado = loteDAO.actualizarUbicacionLote(codigo, almacenNuevo.getCodigo());
                        
                        if (actualizado) {
                            //Crear Movimiento
                            String codigoMovimiento = "MV" + UUID.randomUUID()
                                    .toString()
                                    .replace("-", "")
                                    .substring(0, 8);

                            TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM03");
                            // Crear el movimiento usando el constructor COMPLETO
                            MovimientoInventario mov = new MovimientoInventario(
                                    codigoMovimiento,     // codigo
                                    tipo,                   // tipoMovimiento
                                    codigo,                // afectado (código del lote)
                                    lote.getCantidad(),// cantidad
                                    Double.parseDouble(costo),                   // costoMovimiento
                                    almacenCodigo,                 // antiguaUbicacion → se aplica N/A
                                    almacenNuevo.getCodigo(),                 // nuevaUbicacion   → se aplica N/A
                                    new java.util.Date(),   // fecha
                                    usuario.getId()     //Usuario
                            );

                            movimientoDAO.insertarMovimiento(mov);
                            mensaje = "<strong style='color:green;'>Lote actualizado correctamente.</strong>";
                        } else {
                            mensaje = "<strong style='color:red;'>No se pudo actualizar el lote</strong>";
                        }
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El código de lote no existe</strong>";
                }
            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>El costo debe ser un número válido</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }
        }else{
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
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
        totalRegistros = loteDAO.contarLotes();
        totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
        if (totalPaginas < 1) totalPaginas = 1;
    } catch (Exception e) {
        mensaje = "<strong style='color:red;'>No se pudo obtener total de productos: " + e.getMessage() + "</strong>";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trasladar Lotes | RMT Systems</title>
        <script>
            function asignarAccion(accion) {
                document.forms['Lote'].cmd.value = accion;
            }
            
            function seleccionarLote(codigo, productoId, ubicacion, uNombre, cantidad) {
                const form = document.forms['Lote'];

                form.idtxt.value = codigo;
                form.productotxt.value = productoId;
                document.getElementById("productoVisible").textContent = productoId;
                
                form.almacenlst.value = ubicacion;
                document.getElementById("almacenVisible").textContent = uNombre;


                const mensajeDiv = document.querySelector('.mensaje');
                const mensajeDiv2 = document.querySelector('.cantidadtitulo');

                if (mensajeDiv) {
                    mensajeDiv.innerHTML =
                        "<strong style='color:green;'>Se cargó el lote para traslado.</strong>";
                }
                if (mensajeDiv2) {
                    mensajeDiv2.innerHTML =
                        "<span style='color:black;'>El lote contiene: " + cantidad + " productos</span>";
                }
            }
            
            function limpiarPantalla() {
                const form = document.forms['Lote'];

                form.idtxt.value = "";
                form.productotxt.value = "";
                document.getElementById("productoVisible").textContent = "No seleccionado";

                const mensajeDiv = document.querySelector('.mensaje');
                const mensajeDiv2 = document.querySelector('.cantidadtitulo');

                if (mensajeDiv) {
                    mensajeDiv.innerHTML =
                        "<strong style='color:green;'>Se limpiaron los campos.</strong>";
                }
                if (mensajeDiv2) {
                    mensajeDiv2.innerHTML = "";
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
            .topbar { background-color: #2c3e50; color: white; display: flex; align-items: center; justify-content: space-between; padding: 10px 30px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .topbar h2 { margin: 0; font-size: 20px; }
            .topbar a { color: white; text-decoration: none; padding: 10px 15px; border-radius: 5px; transition: background 0.3s, transform 0.2s; }
            .topbar a:hover { background-color: #34495e; transform: translateY(-2px); }
            .topbar-links { display: flex; gap: 10px; }
            
            /* Contenedor principal */
            .content {
                display: flex;
                gap: 20px;
                width: 100%;
            }

            /* Panel del formulario */
            .formulario {
                background: #ffffff;
                width: 380px;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            .formulario table {
                width: 100%;
            }

            .formulario td {
                padding: 10px 0;
                font-weight: 600;
                color: #333;
            }

            .formulario input[type="text"],
            .formulario input[type="number"],
            .formulario select {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #ccd4dd;
                background: #f8fafc;
                font-size: 14px;
                transition: 0.2s;
            }

            .formulario input:focus,
            .formulario select:focus {
                border-color: #007bff;
                background: #ffffff;
                outline: none;
            }

            /* Botones */
            .formulario input[type="submit"],
            .formulario input[type="button"] {
                padding: 10px 18px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: 0.2s;
            }

            .formulario input[type="submit"] {
                background: #007bff;
                color: white;
            }

            .formulario input[type="submit"]:hover {
                background: #005fcc;
            }

            .formulario input[type="button"] {
                background: #6c757d;
                color: white;
            }

            .formulario input[type="button"]:hover {
                background: #555;
            }

            .mensaje, .cantidadtitulo {
                margin-top: 12px;
                font-weight: bold;
                color: #444;
            }


            /* TABLA DE LOTES */
            .container {
                flex: 1;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            .tabla-lotes {
                width: 100%;
                border-collapse: collapse;
            }

            .tabla-lotes th {
                background: #007bff;
                color: white;
                padding: 12px;
                text-align: left;
                font-size: 14px;
            }

            .tabla-lotes td {
                padding: 10px;
                border-bottom: 1px solid #e6e9ed;
            }

            /* Hover moderno */
            .tabla-lotes tbody tr:hover {
                background: #f1f5ff;
            }

            /* Botón de seleccionar lote */
            .tabla-lotes button {
                background: #28a745;
                color: white;
                padding: 8px 12px;
                border: none;
                border-radius: 8px;
                font-size: 13px;
                cursor: pointer;
                transition: 0.2s;
            }

            .tabla-lotes button:hover {
                background: #1f7e36;
            }

            /* Paginación */
            .paginacion {
                margin-top: 20px;
                text-align: center;
            }

            .paginacion a {
                padding: 7px 12px;
                background: #007bff;
                color: white;
                border-radius: 6px;
                text-decoration: none;
                margin: 0 3px;
                transition: 0.2s;
            }

            .paginacion a:hover {
                background: #005fcc;
            }

            .paginacion span {
                padding: 7px 12px;
                border-radius: 6px;
                background: #dbe7ff;
                color: #005fcc;
                margin: 0 3px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <nav class="topbar">
            <h2><%= user %></h2>
            <div class="topbar-links">
                <a href="producto.jsp">Productos</a>
                <a href="transferir.jsp">Trasladar Lotes</a>
                <a href="LogoutServlet">Cerrar Sesión</a>
            </div>
        </nav>
        <div class="content">
            <div class="formulario">
                <form id="Lote" name="Lote" method="post" action="transferir.jsp">
                    <table>
                        <tbody> 
                            <tr>
                                <td>Codigo Lote:</td>
                                <td><input name="idtxt" type="text" placeholder="Ingrese un código"/></td>
                            </tr>
                            <tr>
                                <td>Producto:</td>
                                <td>
                                    <span id="productoVisible">No seleccionado</span>
                                    <input type="hidden" name="productotxt" id="productotxt">
                                </td>
                            </tr>
                            <tr>
                                <td>Ubicación</td>
                                <td>
                                    <span id="almacenVisible">No seleccionado</span>
                                    <input type="hidden" name="almacenlst" id="almacenlst">
                                </td>
                            </tr>
                            <tr>
                                <td>Nueva Ubicación</td>
                                <td>
                                    <select name="nuevoalmacenlst">
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
                                <td>Costo de Traslado:</td>
                                <td><input name="trasladotxt" type="number" step="0.01" min="0" placeholder="Ingrese costo de traslado"/></td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2" style="text-align:right;">
                                    <input type="submit" value="Trasladar" onclick="asignarAccion('trasladar')"/>
                                </td>
                                <td colspan="2" style="text-align:right;">
                                    <input type="button" value="Limpiar" onclick="limpiarPantalla()"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    <div class="mensaje"><%= mensaje %></div>
                    <div class="cantidadtitulo"><%= cantidadtitulo %></div>
                    <input name="cmd" type="hidden"/>
                </form>
                
            </div>
            <div class="container">
                <table class="tabla-lotes">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Producto</th>
                            <th>Cantidad</th>
                            <th>Fecha de Ingreso</th>
                            <th>Fecha de Vencimiento</th>
                            <th>Almacen</th>
                            <th>Costo</th>
                            <th>Observaciones</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            try {
                                java.util.List<Lote> lotes = loteDAO.listarLotesPaginado(registrosPorPagina, offset);
                                if (lotes != null) {
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    for (Lote l : lotes) {
                                        
                                        String proNombre = (l.getProducto() != null ? l.getProducto().getNombre() : "Sin producto");
                                        String ubiNombre = (l.getUbicacion() != null ? l.getUbicacion().getNombre() : "Sin ubicación");

                                        // ---- Fecha de ingreso ----
                                        String fechaIngreso;
                                        if (l.getFechaIngreso() == null) {
                                            fechaIngreso = "No aplica";
                                        } else {
                                            fechaIngreso = sdf.format(l.getFechaIngreso());
                                        }

                                        // ---- Fecha de vencimiento ----
                                        String fechaVenc;
                                        if (l.getFechaVencimiento() == null) {
                                            fechaVenc = "No aplica";
                                        } else {
                                            fechaVenc = sdf.format(l.getFechaVencimiento());
                                        }
                                        
                                %>

                                <tr>
                                    <td><%= l.getCodigo() %></td>
                                    <td><%= proNombre %></td>
                                    <td><%= l.getCantidad() %></td>
                                    <td><%= fechaIngreso %></td>
                                    <td><%= fechaVenc %></td>
                                    <td><%= ubiNombre %></td>
                                    <td><%= l.getCostoUnitario() %></td>
                                    <td><%= l.getObservaciones() %></td>

                                    <td>
                                        <button type="button"
                                        style="background:#28a745; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                        onclick="seleccionarLote(
                                            '<%= l.getCodigo() %>',
                                            '<%= l.getProducto().getCodigo() %>',
                                            '<%= l.getUbicacion().getCodigo() %>',
                                            '<%= l.getUbicacion().getNombre() %>',
                                            '<%= l.getCantidad() %>',
                                        )">
                                        Seleccionar Lote
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
