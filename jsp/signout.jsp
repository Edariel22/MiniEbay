<%@ page import="java.lang.*"%>
// Set the User and session to null, and return to login page
<%
	session.setAttribute("userName",null);
	session.setAttribute("currentPage",null);
	response.sendRedirect("../html/loginHashing.html");

%>