<%-- 
    Document   : lotes
    Created on : 21 nov 2025, 11:54:25
    Author     : waldi
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="models.Usuario" %>
<%@ page import="models.Rol" %>
<%@ page import="bd.UsuarioDAO" %>
<%@ page import="bd.RolDAO" %>
<%@ page import="java.util.UUID" %>
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
    MovimientoInventarioDAO movimientoDAO = new MovimientoInventarioDAO();
    
    //Revisa que el usuario esté activo
    Usuario sesion = usuarioDAO.buscarUsuarioPorId(usuario.getId());
    if (!sesion.isActivo()) {
        response.sendRedirect("accesodenegado.jsp");
        return;
    }
    
    // Mensaje de estado
    String mensaje = "";
    String cantidadtitulo = "<span style=\'color:black;\'>Controlar Cantidad de Producto:</span>";
    String user = usuario.getRol().getNombre() + " " + usuario.getNombre();
    
    //Editar
    if ("editar".equals(request.getParameter("cmd"))) {
        String codigo = request.getParameter("idtxt");
        String productoId = request.getParameter("productotxt");
        String fechaIngreso = request.getParameter("fechaIngresotxt");
        String fechaVencimiento = request.getParameter("fechaVencimientotxt");
        String almacenCodigo = request.getParameter("almacenlst");
        String costoStr = request.getParameter("costotxt");
        String observaciones = request.getParameter("observacionestxt");

        if (codigo != null && productoId != null && fechaIngreso != null &&
            almacenCodigo != null && costoStr != null && observaciones != null &&
            !codigo.isEmpty() && !productoId.isEmpty() && !fechaIngreso.isEmpty() &&
            !almacenCodigo.isEmpty() && !costoStr.isEmpty() && !observaciones.isEmpty()) {


            try {
                // Validación de existencia
                if (loteDAO.existeLote(codigo)) {

                    double costoUnitario = Double.parseDouble(costoStr);

                    // Obtener objetos relacionados
                    Producto producto = productoDAO.buscarProductoPorCodigo(productoId);
                    Almacen almacen = almacenDAO.obtenerAlmacenPorCodigo(almacenCodigo);
                    Lote lote = loteDAO.buscarLotePorCodigo(codigo);

                    if (producto == null) {
                        mensaje = "<strong style='color:orange;'>El producto indicado no existe</strong>";
                    } else if (almacen == null) {
                        mensaje = "<strong style='color:orange;'>El almacén seleccionado no existe</strong>";
                    } else if (producto.isEstado()){
                        
                        Lote loteEditado = new Lote(
                            codigo,
                            producto,
                            lote.getCantidad(),
                            java.sql.Date.valueOf(fechaIngreso),
                            java.sql.Date.valueOf(fechaVencimiento),
                            almacen,
                            costoUnitario,
                            observaciones
                        );

                        boolean actualizado = loteDAO.actualizarLote(loteEditado);

                        if (actualizado) {
                            String codigoMovimientoR = "MV" + UUID.randomUUID()
                                    .toString()
                                    .replace("-", "")
                                    .substring(0, 8);

                            TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM06");
                            // Crear el movimiento usando el constructor COMPLETO
                            MovimientoInventario movRetiro = new MovimientoInventario(
                                    codigoMovimientoR,     // codigo
                                    tipo,                   // tipoMovimiento
                                    codigo,                // afectado (código del lote)
                                    lote.getCantidad(),    // cantidad (negativa)
                                    0.0,                   // costoMovimiento
                                    "N/A",                 // antiguaUbicacion → se aplica N/A
                                    "N/A",                 // nuevaUbicacion   → se aplica N/A
                                    new java.util.Date(),   // fecha
                                    usuario.getId()     //Usuario
                            );

                            movimientoDAO.insertarMovimiento(movRetiro);
                            mensaje = "<strong style='color:green;'>Lote actualizado correctamente</strong>";
                        } else {
                            mensaje = "<strong style='color:red;'>No se pudo actualizar el lote</strong>";
                        }
                    }else{
                        mensaje = "<strong style='color:orange;'>El producto no está activo para su uso</strong>";
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El código de lote no existe</strong>";
                }

            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>El costo debe ser un número válido</strong>";
            } catch (IllegalArgumentException iae) {
                mensaje = "<strong style='color:orange;'>Las fechas no son válidas</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }
    
    if ("guardar".equals(request.getParameter("cmd"))) {
        String codigo = request.getParameter("idtxt");
        String cantidad = request.getParameter("cantidadtxt");
        String productoId = request.getParameter("productotxt");
        String almacenCodigo = request.getParameter("almacenlst");
        String accion = request.getParameter("accionlst");
        
        if (codigo != null && productoId != null && cantidad != null && almacenCodigo != null && accion != null
                && !codigo.isEmpty() && !productoId.isEmpty() && !cantidad.isEmpty() && !almacenCodigo.isEmpty() && !accion.isEmpty()) {

            try {
                // Validación de existencia
                if (loteDAO.existeLote(codigo)) {
                    // Obtener objetos relacionados
                    Producto producto = productoDAO.buscarProductoPorCodigo(productoId);
                    Almacen almacen = almacenDAO.obtenerAlmacenPorCodigo(almacenCodigo);
                    Lote lote = loteDAO.buscarLotePorCodigo(codigo);
                    //Cambiar cantidad
                    int controlador = 0;
                    // Método auxiliar para crear y registrar un movimiento
                    String tMov = "";
                    switch (accion) {
                        case "retiro":
                            //Definir movimiento
                            tMov = "TM05";
                            //Asignar cantidad
                            controlador = -Integer.parseInt(cantidad);
                            break;
                        case "retiroerror":
                            //Definir movimiento
                            tMov = "TM07";
                            //Asignar cantidad
                            controlador = -Integer.parseInt(cantidad);
                            break;

                        case "ingreso":
                            //Definir movimiento
                            tMov = "TM01";
                            //Asignar cantidad
                            controlador = Integer.parseInt(cantidad);
                            break;
                        case "ingresoerror":
                            //Definir movimiento
                            tMov = "TM08";
                            //Asignar cantidad
                            controlador = Integer.parseInt(cantidad);
                            break;
                    }
                    int cantidadNueva = lote.getCantidad() + controlador;
                    
                    if (producto == null) {
                        mensaje = "<strong style='color:orange;'>El lote no posee producto</strong>";
                    } else if (almacen == null) {
                        mensaje = "<strong style='color:orange;'>El lote no ha sido asignado a un almacen</strong>";
                    } else if (producto.isEstado()){
                        Lote loteEditado = new Lote(
                            codigo,
                            producto,
                            cantidadNueva,
                            lote.getFechaIngreso(),
                            lote.getFechaVencimiento(),
                            almacen,
                            lote.getCostoUnitario(),
                            lote.getObservaciones()
                        );

                        boolean actualizado = loteDAO.actualizarLote(loteEditado);
                        
                        if (actualizado) {
                            //Crear Movimiento
                            String codigoMovimiento = "MV" + UUID.randomUUID()
                                    .toString()
                                    .replace("-", "")
                                    .substring(0, 8);

                            TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo(tMov);
                            // Crear el movimiento usando el constructor COMPLETO
                            MovimientoInventario mov = new MovimientoInventario(
                                    codigoMovimiento,     // codigo
                                    tipo,                   // tipoMovimiento
                                    codigo,                // afectado (código del lote)
                                    Integer.parseInt(cantidad),// cantidad
                                    0.0,                   // costoMovimiento
                                    "N/A",                 // antiguaUbicacion → se aplica N/A
                                    "N/A",                 // nuevaUbicacion   → se aplica N/A
                                    new java.util.Date(),   // fecha
                                    usuario.getId()     //Usuario
                            );

                            movimientoDAO.insertarMovimiento(mov);
                            
                            //Editar cantidad de producto
                            int nuevaCantidad = producto.getCantidadAsociada()+ controlador;
                            boolean productoCargado = productoDAO.actualizarCantidadAsociada(producto.getCodigo(), nuevaCantidad);
                            if (productoCargado){
                                mensaje = "<strong style='color:green;'>Lote actualizado correctamente.</strong>";
                            }
                            else{
                                mensaje = "<strong style='color:red;'>El Lote se actualizó, pero ocurrió un error en la bd de producto, informele al Gestor de Inventario</strong>";
                            }
                        } else {
                            mensaje = "<strong style='color:red;'>No se pudo actualizar el lote</strong>";
                        }
                    } else {
                        mensaje = "<strong style='color:orange;'>El producto no está activo para su uso</strong>";
                    }
                } else {
                    mensaje = "<strong style='color:red;'>El código de lote no existe</strong>";
                }

            } catch (NumberFormatException nfe) {
                mensaje = "<strong style='color:orange;'>El costo debe ser un número válido</strong>";
            } catch (IllegalArgumentException iae) {
                mensaje = "<strong style='color:orange;'>Las fechas no son válidas</strong>";
            } catch (Exception ex) {
                mensaje = "<strong style='color:red;'>Error interno: " + ex.getMessage() + "</strong>";
            }

        } else {
            mensaje = "<strong style='color:orange;'>Debe ingresar todos los campos solicitados</strong>";
        }
    }
    
    if ("eliminar".equals(request.getParameter("cmd"))) {
        String id = request.getParameter("idtxt");
            Lote lote = loteDAO.buscarLotePorCodigo(id);
        if (loteDAO.eliminarLote(id)) {
            //Restar productos del lote
            int nuevaCantidad = lote.getProducto().getCantidadAsociada() - lote.getCantidad();
            boolean productoCargado = productoDAO.actualizarCantidadAsociada(lote.getProducto().getCodigo(), nuevaCantidad);
            //Crear Movimiento
            String codigoMovimientoEliminar = "MV" + UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 8);

                TipoMovimiento tipo = TipoMovimientoDAO.buscarPorCodigo("TM11");
                // Crear el movimiento usando el constructor COMPLETO
                MovimientoInventario movIngresoEliminar = new MovimientoInventario(
                    codigoMovimientoEliminar,     // codigo
                    tipo,                   // tipoMovimiento
                    lote.getCodigo(),                // afectado (código del lote)
                    lote.getCantidad(),           // cantidad (negativa)
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
        <title>Lotes | RMT Systems</title>
        <script type="text/javascript">
            function asignarAccion(accion) {
                document.forms['Lote'].cmd.value = accion;
            }
            
            function editarLote(codigo, productoId, cantidad, fechaIngreso, fechaVenc, ubicacionId, costoUnitario, observaciones) {
                const form = document.forms['Lote'];

                // Asignación directa de los valores al formulario
                form.idtxt.value = codigo;
                form.productotxt.value = productoId;
                form.fechaIngresotxt.value = fechaIngreso;
                form.fechaVencimientotxt.value = fechaVenc;
                form.almacenlst.value = ubicacionId;
                form.costotxt.value = costoUnitario;
                form.observacionestxt.value = observaciones;

                // Asignar acción editar
                form.cmd.value = "editar";

                // Manejo del mensaje
                const mensajeDiv = document.querySelector('.mensaje');
                const mensajeDiv2 = document.querySelector('.cantidadtitulo');

                if (mensajeDiv) {
                    mensajeDiv.innerHTML =
                        "<strong style='color:green;'>Se cargó el lote para edición.</strong>";
                }
                if (mensajeDiv2) {
                    mensajeDiv2.innerHTML =
                        "<span style=\'color:black;\'>El lote contiene: "+ cantidad +" productos</span>";
                }
            }
        
        function eliminarLote(codigo, producto) {
               if (confirm(
                    "¿Seguro que deseas eliminar este lote?\n" +
                    "Producto Asociado: " + producto
                )) {

                    const form = document.createElement("form");
                    form.method = "post";
                    form.action = "lotes.jsp";

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
            .tabla-lotes { border-collapse: collapse; justify-content: center; align-items: center; width: 100%; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 10px; overflow: hidden; }
            .paginacion { justify-content: center; align-items: center; text-align: center; margin-top: 12px; }
            .formulario { width: 70%; margin: 20px 0; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; margin-left: 275px; }
            .formulario table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
            .formulario td { padding: 10px; font-size: 15px; color: #333; }
            .formulario input[type="text"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="text"]:focus{ border-color: #007bff; }
            .formulario input[type="number"]{ width: 95%; padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; transition: border-color 0.3s; }
            .formulario input[type="number"]:focus{ border-color: #007bff; }
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
            
            select[name="accionlst"] {
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
            select[name="accionlst"]:focus {
                background-color: #3e5871;
                box-shadow: 0 0 5px #1abc9c;
            }
            select[name="accionlst"] option {
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
                <form id="Lote" name="Lote" method="post" action="lotes.jsp">
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
                                    <input type="submit" value="Editar" onclick="asignarAccion('editar')"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                        <h2></h2>
                    <table>
                        <tbody>
                            <tr>
                                <td class="cantidadtitulo"><%= cantidadtitulo %></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Valor:</td>
                                <td><input name="cantidadtxt" type="number" placeholder="Ingrese una cantidad"/></td>
                            </tr>
                            <tr>
                                <td>Acción: </td>
                                <td>
                                    <select name="accionlst">
                                         <option value="retiro">Retirar</option>
                                         <option value="ingreso">Ingresar</option>
                                         <option value="retiroerror">Retiro por edición</option>
                                         <option value="ingresoerror">Ingreso por edición</option>
                                    </select>
                                </td>
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
                    <div class="mensaje"><%= mensaje %></div>
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
                                        onclick="editarLote(
                                            '<%= l.getCodigo() %>',
                                            '<%= l.getProducto().getCodigo() %>',
                                            '<%= l.getCantidad() %>',
                                            '<%= fechaIngreso %>',
                                            '<%= fechaVenc %>',
                                            '<%= l.getUbicacion().getCodigo() %>',
                                            '<%= l.getCostoUnitario() %>',
                                            '<%= l.getObservaciones() %>'
                                        )">
                                        Seleccionar Lote
                                    </button>
                                    <button type="button"
                                            style="background:#dc3545; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;"
                                            onclick="eliminarLote(
                                                '<%= l.getCodigo() %>',
                                                '<%= l.getProducto().getNombre()%>'
                                                )">
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
