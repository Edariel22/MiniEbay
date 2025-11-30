<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Modify Departments as an Admin.</title>
	</head>
	<body>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));

if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));
%>

<html>
	<head>
		<title>Admin Departments</title>
	</head>
<body>

<%
	applicationDBManager dbm = new applicationDBManager();
	if (request.getParameter("addDept") != null) {
		String name = request.getParameter("name");
		String building = request.getParameter("building");
		dbm.addDepartment(name, building);
	}
	if (request.getParameter("modifyDept") != null) {
		int dept_id = Integer.parseInt(request.getParameter("dept_id"));
		int newDeptId = Integer.parseInt(request.getParameter("newDeptId"));
		String newName = request.getParameter("name");
		String newBuilding = request.getParameter("building");
		dbm.addDepartment(dept_id, newDeptId, newName, newBuilding);
	}
	if (request.getParameter("removeDept") != null) {
		int dept_id = Integer.parseInt(request.getParameter("removedept_id"));
		dbm.removeDepartment(dept_id);
	}

	ResultSet rs = dbm.listAllDepartment();
	%>

	<h2>Admin - Department Management</h2>

	<table border="1">
	<tr>
		<td>ID</td>
		<td>Name</td>
		<td>Building</td>
	</tr>
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

	<h3>Modify Department</h3>
	<form method="post" action="adminDepartments.jsp">
	Old ID: <input type="text" name="dept_id"><br>
	New ID: <input type="text" name="newDeptId"><br>
	New Name: <input type="text" name="name"><br>
	New Building Name: <input type="text" name="building"><br>
	<input type="submit" name="addDept" value="Add">
	</form>

	<h3>Remove Department</h3>
	<form method="post" action="adminDepartments.jsp">
	ID: <input type="text" name="removedept_id"><br>
	<input type="submit" name="removeDept" value="Remove">
	</form>
	<a href="welcomeMenu.jsp">Return to Main Menu</a>

	</body>
</html>
