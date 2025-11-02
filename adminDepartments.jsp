<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.miniebay.*" %>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));

if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));
%>

<html>
<head><title>Admin Departments</title></head>
<body>

<%
applicationDBManager dbm = new applicationDBManager();
%>
<%if (request.getParameter("addDept") != null) {
    String name = request.getParameter("name");
    String building = request.getParameter("building");
    dbm.addDepartment(name, building);
}
%>
<%if (request.getParameter("removeDept") != null) {
   int deptId = Integer.parseInt(request.getParameter("removeDeptId"));
    dbm.removeDepartment(deptId);
}
%>
<%
ResultSet rs = dbm.listAllDepartment();
%>

<h2>Admin - Department Management</h2>

<table border="1">
<tr><td>ID</td><td>Name</td><td>Building</td></tr>
<%
while(rs.next()){
	out.print("<tr>");
	out.print("<td>"+rs.getString(1)+"</td>"); 
	out.print("<td>"+rs.getString(2)+"</td>");
	out.print("<td>"+rs.getString(3)+"</td>");
	out.print("</tr>");
}
rs.close();
dbm.close();
%>
</table>

<h3>Add Department</h3>
<form method="post" action="adminDepartments.jsp">
Name: <input type="text" name="name"><br>
Building: <input type="text" name="building"><br>
<input type="submit" name="addDept" value="Add">
</form>

<h3>Remove Department</h3>
<form method="post" action="adminDepartments.jsp">
ID: <input type="text" name="removeDeptId"><br>
<input type="submit" name="removeDept" value="Remove">
</form>
<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
