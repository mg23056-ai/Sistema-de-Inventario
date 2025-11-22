<%-- 
    Document   : kardex
    Created on : 12 nov 2025, 18:38:56
    Author     : waldi
--%>

<%@page import="java.util.List"%>
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

    // Verificar si el rol es Administrador
    if (!"Administrador".equals(usuario.getRol().getNombre())) {
        if (!"Auditor".equals(usuario.getRol().getNombre())) {
            response.sendRedirect("accesodenegado.jsp");
            return;
        }
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
    
    //Variables
    String mensaje = "";
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    
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
        totalRegistros = movimientoDAO.contarMovimientos();
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
        <title>Kardex | RMT Systems</title>
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
            .topbar { background-color: #2c3e50; color: white; display: flex; align-items: center; justify-content: space-between; padding: 10px 30px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .topbar h2 { margin: 0; font-size: 20px; }
            .topbar a { color: white; text-decoration: none; padding: 10px 15px; border-radius: 5px; transition: background 0.3s, transform 0.2s; }
            .topbar a:hover { background-color: #34495e; transform: translateY(-2px); }
            .topbar-links { display: flex; gap: 10px; }
        </style>
    </head>
    <body>
        <nav class="topbar">
            <h2><%= user %></h2>
            <div class="topbar-links">
                <% 
                    if("Administrador".equals(usuario.getRol().getNombre())){
                %>
                <a href="usuario.jsp">Usuarios</a>
                <%
                    }
                %>
                <a href="kardex.jsp">Kardex</a>
                <a href="LogoutServlet">Cerrar Sesión</a>
            </div>
        </nav>
        <div>
            <div class="container">
                <table class="tabla-mov">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Tipo de movimiento</th>
                            <th>Afectado</th>
                            <th>Cantidad</th>
                            <th>Costo movimiento</th>
                            <th>Antiguo almacén</th>
                            <th>Nuevo almacén</th>
                            <th>Fecha</th>
                            <th>Actor</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            try {
                                List<MovimientoInventario> movimientos = movimientoDAO.listarMovimientos(registrosPorPagina, offset);

                                if (movimientos != null && !movimientos.isEmpty()) {

                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                                    for (MovimientoInventario m : movimientos) {
                                    
                                        // ---- Afectado ----
                                        Producto pro = productoDAO.buscarProductoPorCodigo(m.getAfectado());
                                        Lote lote   = (pro == null) ? loteDAO.buscarLotePorCodigo(m.getAfectado()) : null;

                                        String nombreAfectado =
                                                (pro != null)  ? pro.getNombre() :
                                                (lote != null) ? lote.getCodigo() :
                                                                 m.getAfectado();


                                        // ---- Antigua ubicación ----
                                        Almacen alm1 = almacenDAO.obtenerAlmacenPorCodigo(m.getAntiguaUbicacion());
                                        String nombreAntigua = (alm1 != null ? alm1.getNombre() : m.getAntiguaUbicacion());


                                        // ---- Nueva ubicación ----
                                        Almacen alm2 = almacenDAO.obtenerAlmacenPorCodigo(m.getNuevaUbicacion());
                                        String nombreNueva = (alm2 != null ? alm2.getNombre() : m.getNuevaUbicacion());


                                        // ---- Actor (usuario) ----
                                        String actorCrudo = m.getActor();
                                        String id = (actorCrudo != null ? actorCrudo.trim() : "");   // <-- AQUÍ EL TRIM

                                        Usuario u = usuarioDAO.buscarUsuarioPorId(id);
                                        String nombreActor = (u != null ? u.getNombre() : "Desconocido");

                        %>

                        <tr>
                            <td><%= m.getCodigo() %></td>

                            <td>
                                <%= (m.getTipoMovimiento() != null 
                                        ? m.getTipoMovimiento().getNombre() 
                                        : "Sin tipo") %>
                            </td>

                            <td><%= nombreAfectado %></td>

                            <td><%= m.getCantidad() %></td>

                            <td><%= m.getCostoMovimiento() %></td>

                            <td><%= (nombreAntigua != null ? nombreAntigua : "N/A") %></td>

                            <td><%= (nombreNueva != null ? nombreNueva : "N/A") %></td>

                            <td><%= (m.getFecha() != null ? sdf.format(m.getFecha()) : "Sin fecha") %></td>

                            <td><%= nombreActor %></td>
                        </tr>

                        <%
                                    }
                                } else {
                        %>

                        <tr>
                            <td colspan="9">No hay movimientos para mostrar.</td>
                        </tr>

                        <%
                                }
                            } catch (Exception e) {
                        %>

                        <tr>
                            <td colspan="9">Error al obtener movimientos: <%= e.getMessage() %></td>
                        </tr>

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
