<%@ page import="java.lang.*"%>
<%
// Pone la sesion en null, y regresa al usuario a la pagina del login
	session.setAttribute("userName",null);
	session.setAttribute("currentPage",null);
	response.sendRedirect("loginHashing.html");

%>