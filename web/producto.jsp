<%-- 
    Document   : producto
    Created on : 14 nov 2025, 17:19:55
    Author     : waldi
--%>

<%@page import="java.util.UUID"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="models.Usuario" %>
<%@ page import="models.Rol" %>
<%@ page import="bd.UsuarioDAO" %>
<%@ page import="bd.RolDAO" %>
<%@ page session="true" %>

<%@ page import="models.Producto" %>
<%@ page import="models.Categoria" %>
<%@ page import="models.Proveedor" %>
<%@ page import="models.Lote" %>
<%@ page import="models.MovimientoInventario" %>
<%@ page import="models.TipoMovimiento" %>

<%@ page import="bd.ProductoDAO" %>
<%@ page import="bd.CategoriaDAO" %>
<%@ page import="bd.ProveedorDAO" %>
<%@ page import="bd.LoteDAO" %>
<%@ page import="bd.MovimientoInventarioDAO" %>
<%@ page import="bd.TipoMovimientoDAO" %>

<%
    // Comprueba sesión
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
    LoteDAO loteDAO = new LoteDAO();
    MovimientoInventarioDAO movimientoDAO = new MovimientoInventarioDAO();
        
    //Revisa que el usuario esté activo
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    if (!sesion.isActivo()) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Mensaje de estado
    String mensaje = "";
    String anuncio = "";
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    
    //Guardar Producto
    if ("guardar".equals(request.getParameter("cmd"))) {
        String codigo = request.getParameter("idtxt");
        String nombre = request.getParameter("nombretxt");
        String descripcion = request.getParameter("descripciontxt");
        String cantidadTxt = request.getParameter("cantidadtxt");
        String categoriaCodigo = request.getParameter("categorialst");
        String proveedorNit = request.getParameter("proveedorlst");
        String estadoParam = request.getParameter("activolst");

        boolean estado = "true".equalsIgnoreCase(estadoParam);

        if (codigo != null && nombre != null && descripcion != null
                && categoriaCodigo != null && proveedorNit != null && estadoParam != null
                && !codigo.isEmpty() && !nombre.isEmpty() && !descripcion.isEmpty()
                && !categoriaCodigo.isEmpty() && !proveedorNit.isEmpty()) {

            try {
                int cantidad = 0;
                int validar = Integer.parseInt(cantidadTxt);
                Categoria categoria = categoriaDAO.obtenerCategoriaPorCodigo(categoriaCodigo);
                Proveedor proveedor = proveedorDAO.obtenerProveedorPorNit(proveedorNit);

                if (!productoDAO.existeProducto(codigo)) {

                    if (categoria == null) {
                        mensaje = "<strong style='color:orange;'>La categoría seleccionada no existe</strong>";

                    } else if (proveedor == null) {
                        mensaje = "<strong style='color:orange;'>El proveedor seleccionado no existe</strong>";

                    } else {
                        Producto nuevoProducto = new Producto(
                            codigo,
                            nombre,
                            categoria,
                            descripcion,
                            cantidad,
                            proveedor,
                            estado
                        );

                        boolean ok = productoDAO.insertarProducto(nuevoProducto);

                        if (ok) {
                            String codigoMovimiento = "MV" + UUID.randomUUID()
                                .toString()
                                .replace("-", "")
                                .substring(0, 8);

                                TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM04");
                                // Crear el movimiento usando el constructor COMPLETO
                                MovimientoInventario movEditar = new MovimientoInventario(
                                    codigoMovimiento,     // codigo
                                    tipo,                   // tipoMovimiento
                                    nuevoProducto.getCodigo(),                // afectado (código del producto)
                                    nuevoProducto.getCantidadAsociada(),           // cantidad (negativa)
                                    0.0,                   // costoMovimiento
                                    "N/A",                 // antiguaUbicacion → se aplica N/A
                                    "N/A",                 // nuevaUbicacion   → se aplica N/A
                                    new java.util.Date(),   // fecha
                                    usuario.getId()     //Usuario
                                );
                            movimientoDAO.insertarMovimiento(movEditar);
                            mensaje = "<strong style='color:green;'>Guardado correctamente</strong>";
                            if (validar > 0){
                                anuncio = "<strong style='color:orange;'>La cantidad se ha definido a cero</strong>";
                            }
                        } else {
                            mensaje = "<strong style='color:red;'>Ocurrió un error al guardar el producto</strong>";
                        }
                    }

                } else {
                    mensaje = "<strong style='color:red;'>El código del producto ya existe</strong>";
                }

            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>La cantidad debe ser un número entero válido</strong>";

            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }

    //Editar producto
    if ("editar".equals(request.getParameter("cmd"))) {
        String codigo = request.getParameter("idtxt");
        String nombre = request.getParameter("nombretxt");
        String descripcion = request.getParameter("descripciontxt");
        String cantidadTxt = request.getParameter("cantidadtxt");
        String categoriaCodigo = request.getParameter("categorialst");
        String proveedorNit = request.getParameter("proveedorlst");
        String estadoParam = request.getParameter("activolst");

        boolean estado = "true".equalsIgnoreCase(estadoParam);

        if (codigo != null && nombre != null && categoriaCodigo != null && descripcion != null
                && cantidadTxt != null && proveedorNit != null && estadoParam != null
                && !codigo.isEmpty() && !nombre.isEmpty() && !categoriaCodigo.isEmpty()
                && !cantidadTxt.isEmpty() && !proveedorNit.isEmpty()) {

            try {
                // convertir cantidad
                int cantidad = Integer.parseInt(cantidadTxt);

                // obtener categoria y proveedor
                Categoria categoria = categoriaDAO.obtenerCategoriaPorCodigo(categoriaCodigo);
                Proveedor proveedor = proveedorDAO.obtenerProveedorPorNit(proveedorNit);

                if (productoDAO.existeProducto(codigo)) {

                    if (categoria == null) {
                        mensaje = "<strong style='color:orange;'>La categoría seleccionada no existe</strong>";
                    } else if (proveedor == null) {
                        mensaje = "<strong style='color:orange;'>El proveedor seleccionado no existe</strong>";
                    } else {
                        List<Lote> lotes = loteDAO.listarLotePorProductoID(codigo);
                        int cantidadLote = 0;
                        if (!lotes.isEmpty()) {
                            for (Lote l : lotes) {
                                cantidadLote += l.getCantidad();
                            }
                            if (cantidadLote != cantidad) {
                                anuncio = "<strong style='color:orange;'>Hay " + cantidadLote +
                                          " productos en sus lotes; se ajustó automáticamente</strong>";
                                cantidad = cantidadLote;
                            }
                        }

                        //Editar producto
                        Producto editarProducto = new Producto(
                            codigo,
                            nombre,
                            categoria,
                            descripcion,
                            cantidad,
                            proveedor,
                            estado
                        );

                        // Actualizar
                        boolean ok = productoDAO.actualizarProducto(editarProducto);

                        if (ok) {
                                String codigoMovimiento = "MV" + UUID.randomUUID()
                                .toString()
                                .replace("-", "")
                                .substring(0, 8);

                                TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM06");
                                // Crear el movimiento usando el constructor COMPLETO
                                MovimientoInventario movEditar = new MovimientoInventario(
                                    codigoMovimiento,     // codigo
                                    tipo,                   // tipoMovimiento
                                    editarProducto.getCodigo(),                // afectado (código del producto)
                                    editarProducto.getCantidadAsociada(),           // cantidad (negativa)
                                    0.0,                   // costoMovimiento
                                    "N/A",                 // antiguaUbicacion → se aplica N/A
                                    "N/A",                 // nuevaUbicacion   → se aplica N/A
                                    new java.util.Date(),   // fecha
                                    usuario.getId()     //Usuario
                                );
                            movimientoDAO.insertarMovimiento(movEditar);
                            mensaje = "<strong style='color:green;'>Producto actualizado correctamente</strong>";
                        } else {
                            mensaje = "<strong style='color:red;'>Ocurrió un error al actualizar el producto</strong>";
                        }
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El código del producto no existe</strong>";
                }
            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>La cantidad debe ser un número entero válido</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }
    
    //Eliminar Producto
    if ("eliminar".equals(request.getParameter("cmd"))) {
        String id = request.getParameter("idtxt");
        List<Lote> lotes = loteDAO.listarLotePorProductoID(id);
      
        if(lotes.isEmpty()){
            Producto producto = productoDAO.buscarProductoPorCodigo(id);
            if (productoDAO.eliminarProducto(id)) {
                String codigoMovimientoEliminar = "MV" + UUID.randomUUID()
                    .toString()
                    .replace("-", "")
                    .substring(0, 8);

                    TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM11");
                    // Crear el movimiento usando el constructor COMPLETO
                    MovimientoInventario movIngresoEliminar = new MovimientoInventario(
                        codigoMovimientoEliminar,     // codigo
                        tipo,                   // tipoMovimiento
                        producto.getCodigo(),                // afectado (código del producto)
                        producto.getCantidadAsociada(),           // cantidad (negativa)
                        0.0,                   // costoMovimiento
                        "N/A",                 // antiguaUbicacion → se aplica N/A
                        "N/A",                 // nuevaUbicacion   → se aplica N/A
                        new java.util.Date(),   // fecha
                        usuario.getId()     //Usuario
                    );
                movimientoDAO.insertarMovimiento(movIngresoEliminar);
                mensaje = "<strong style='color:green;'>Producto eliminado correctamente</strong>";
            } else {
                mensaje = "<strong style='color:red;'>Ocurrió un error al eliminar el producto</strong>";
            }
        }else{
            mensaje = "<strong style='color:orange;'>No se pudo eliminar, hay lotes que contienen este producto</strong>";
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
                document.forms['crearProducto'].cmd.value = accion;
            }

            function editarProducto(codigo, nombre, descripcion, cantidad, categoria, proveedor, estado) {
                const form = document.forms['crearProducto'];
                const mensajeDiv = document.querySelector('.mensaje');
                const anuncioDiv = document.querySelector('.anuncio');

                form.idtxt.value = codigo;
                form.nombretxt.value = nombre;
                form.descripciontxt.value = descripcion;
                form.cantidadtxt.value = cantidad;

                form.categorialst.value = categoria;
                form.proveedorlst.value = proveedor;

                form.activolst.value = (estado === "true") ? "true" : "false";

                form.cmd.value = "editar";

                mensajeDiv.innerHTML = "<strong style='color:green;'>Cambie datos para editar</strong>";
                anuncioDiv.innerHTML = "<strong style='color:green;'></strong>";
            }

            function eliminarProducto(codigo) {
                if (confirm("¿Seguro que deseas eliminar este producto?")) {

                    const form = document.createElement("form");
                    form.method = "post";
                    form.action = "producto.jsp";

                    const inputId = document.createElement("input");
                    inputId.type = "hidden";
                    inputId.name = "idtxt";
                    inputId.value = codigo;
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
            .formulario input[type="number"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="number"]:focus{ border-color: #007bff; }
            select[name="rollst"] { background-color: #34495e; color: white; border: none; border-radius: 8px; padding: 8px 12px; font-size: 14px; width: 180px; cursor: pointer; transition: all 0.3s ease; outline: none; }
            select[name="rollst"]:focus { background-color: #3e5871; box-shadow: 0 0 5px #1abc9c; }
            select[name="rollst"] option { background-color: #2c3e50; color: white; }
            .formulario input[type="submit"] { background-color: #007bff; color: white; border: none; padding: 8px 18px; border-radius: 5px; cursor: pointer; font-size: 14px; transition: background-color 0.3s; }
            .formulario input[type="submit"]:hover { background-color: #0056b3; }
            .formulario .mensaje { margin-top: 10px; text-align: center; font-weight: bold; }
            .formulario .anuncio { margin-top: 10px; text-align: center; font-weight: bold; }
            .topbar { background-color: #2c3e50; color: white; display: flex; align-items: center; justify-content: space-between; padding: 10px 30px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .topbar h2 { margin: 0; font-size: 20px; }
            .topbar a { color: white; text-decoration: none; padding: 10px 15px; border-radius: 5px; transition: background 0.3s, transform 0.2s; }
            .topbar a:hover { background-color: #34495e; transform: translateY(-2px); }
            .topbar-links { display: flex; gap: 10px; }
            .content { display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px; flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            .content2 { flex: 1; padding: 20px; background-color: #f4f4f4; overflow-y: auto; }
            
            select[name="categorialst"] {
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
            select[name="categorialst"]:focus {
                background-color: #3e5871;
                box-shadow: 0 0 5px #1abc9c;
            }
            select[name="categorialst"] option {
                background-color: #2c3e50;
                color: white;
            }
            
            select[name="proveedorlst"] {
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
            select[name="proveedorlst"]:focus {
                background-color: #3e5871;
                box-shadow: 0 0 5px #1abc9c;
            }
            select[name="proveedorlst"] option {
                background-color: #2c3e50;
                color: white;
            }
            
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
                <a href="producto.jsp">Productos</a>
                <a href="transferir.jsp">Trasladar Lotes</a>
                <a href="LogoutServlet">Cerrar Sesión</a>
            </div>
        </nav>

        <div class="content">
            <div class="formulario">

                <form id="crearProducto" name="crearProducto" method="post" action="producto.jsp">
                    <table>
                        <tbody> 
                            <tr>
                                <td>Codigo:</td>
                                <td><input name="idtxt" type="text" placeholder="Ingrese un código"/></td>
                            </tr>
                            <tr>
                                <td>Nombre:</td>
                                <td><input name="nombretxt" type="text" placeholder="Ingrese un nombre"/></td>
                            </tr>

                            <tr>
                                <td>Categoría</td>
                                <td>
                                    <select name="categorialst">
                                        <%
                                            try {
                                                java.util.List<Categoria> categorias = categoriaDAO.listarCategorias();
                                                if (categorias != null) {
                                                    for (Categoria categoria : categorias) {
                                        %>
                                                        <option value="<%= categoria.getCodigo() %>"><%= categoria.getNombre() %></option>
                                        <%
                                                    }
                                                } else {
                                        %>
                                                    <option value="">No hay categorías</option>
                                        <%
                                                }
                                            } catch (Exception e) {
                                        %>
                                                <option value="">Error al cargar categorías</option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td>Descripción</td>
                                <td><input name="descripciontxt" type="text" placeholder="Ingrese una descripción"/></td>
                            </tr>

                            <tr>
                                <td>Cantidad Asociada</td>
                                <td><input name="cantidadtxt" type="number" min="0" placeholder="Ingrese cantidad"/></td>
                            </tr>

                            <tr>
                                <td>Proveedor</td>
                                <td>
                                    <select name="proveedorlst">
                                        <%
                                            try {
                                                java.util.List<Proveedor> proveedores = proveedorDAO.listarProveedores();
                                                if (proveedores != null) {
                                                    for (Proveedor proveedor : proveedores) {
                                        %>
                                                        <option value="<%= proveedor.getNit() %>"><%= proveedor.getNombre() %></option>
                                        <%
                                                    }
                                                } else {
                                        %>
                                                    <option value="">No hay proveedores</option>
                                        <%
                                                }
                                            } catch (Exception e) {
                                        %>
                                                <option value="">Error al cargar proveedores</option>
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

                    <div class="mensaje"><%= mensaje %></div>
                    <div class="anuncio"><%= anuncio %></div>
                    <input name="cmd" type="hidden"/>
                </form>
            </div>
                    
            <div class="container">

                <table class="tabla-usuarios">
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
                                        String catCodigo = (p.getCategoria() != null ? p.getCategoria().getCodigo() : "");

                                        String provNombre = (p.getProveedor() != null ? p.getProveedor().getNombre() : "Sin proveedor");
                                        String provNit = (p.getProveedor() != null ? p.getProveedor().getNit() : "");
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
                                                        onclick="editarProducto(
                                                                '<%= p.getCodigo() %>',
                                                                '<%= p.getNombre() %>',
                                                                '<%= p.getDescripcion() %>',
                                                                '<%= p.getCantidadAsociada() %>',
                                                                '<%= catCodigo %>',
                                                                '<%= provNit %>',
                                                                '<%= p.isEstado() %>'
                                                        )">
                                                    Editar
                                                </button>

                                                <button type="button"
                                                        style="background:#dc3545; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                                        onclick="eliminarProducto('<%= p.getCodigo() %>')">
                                                    Eliminar
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