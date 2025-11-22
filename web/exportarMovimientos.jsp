<%@ page import="java.util.*, java.text.SimpleDateFormat, models.*"%>
<%@ page contentType="application/vnd.ms-excel; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
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
    // Instanciar DAOs
    MovimientoInventarioDAO movimientoDAO = new MovimientoInventarioDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    LoteDAO loteDAO = new LoteDAO();
    AlmacenDAO almacenDAO = new AlmacenDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    response.setHeader("Content-Disposition", "attachment;filename=movimientos.xls");
    response.setCharacterEncoding("ISO-8859-1");
    out.clear();
    out.flush();
    
    String filtroTipo = request.getParameter("tipo");
    List<MovimientoInventario> movimientos = movimientoDAO.obtenerMovimientos(filtroTipo);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // Encabezado Excel
    out.println("Código\tTipo de movimiento\tAfectado\tCantidad\tCosto movimiento\tAntiguo almacén\tNuevo almacén\tFecha\tActor");

    for (MovimientoInventario m : movimientos) {
        Producto pro = productoDAO.buscarProductoPorCodigo(m.getAfectado());
        Lote lote = (pro == null) ? loteDAO.buscarLotePorCodigo(m.getAfectado()) : null;
        String nombreAfectado = (pro != null) ? pro.getNombre() : (lote != null ? lote.getCodigo() : m.getAfectado());

        Almacen alm1 = almacenDAO.obtenerAlmacenPorCodigo(m.getAntiguaUbicacion());
        Almacen alm2 = almacenDAO.obtenerAlmacenPorCodigo(m.getNuevaUbicacion());
        String nombreAntigua = (alm1 != null ? alm1.getNombre() : m.getAntiguaUbicacion());
        String nombreNueva = (alm2 != null ? alm2.getNombre() : m.getNuevaUbicacion());

        Usuario u = usuarioDAO.buscarUsuarioPorId(m.getActor() != null ? m.getActor().trim() : "");
        String nombreActor = (u != null ? u.getNombre() : "Desconocido");

        out.println(
            m.getCodigo() + "\t" +
            (m.getTipoMovimiento() != null ? m.getTipoMovimiento().getNombre() : "Sin tipo") + "\t" +
            nombreAfectado + "\t" +
            m.getCantidad() + "\t" +
            m.getCostoMovimiento() + "\t" +
            nombreAntigua + "\t" +
            nombreNueva + "\t" +
            (m.getFecha() != null ? sdf.format(m.getFecha()) : "") + "\t" +
            nombreActor
        );
    }
%>