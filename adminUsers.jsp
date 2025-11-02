<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.miniebay.*" %>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));

if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));
%>

<html>
<head><title>Admin Users</title></head>
<body>

<%
applicationDBManager dbm = new applicationDBManager();

//Add user
if(request.getParameter("userName")!=null){
	String u = request.getParameter("userName");
	String h = request.getParameter("hashing");
	String n = request.getParameter("name");
	String t = request.getParameter("telephone");
	String r = request.getParameter("roleId");
	dbm.addUser(u,h,n,t,r);
	out.println("<p>User added.</p>");
}

//Remove user
if(request.getParameter("removeUser")!=null){
	String ru = request.getParameter("removeName");
	dbm.removeUser(ru);
	out.println("<p>User removed.</p>");
}

//List users
ResultSet rs = dbm.listAllUsers();
%>

<h2>Admin - User List</h2>
<table border="1">
<tr><td>Username</td><td>Name</td><td>Telephone</td><td>Role</td></tr>
<%
while(rs.next()){
	out.print("<tr>");
	out.print("<td>"+rs.getString("userName")+"</td>");
	out.print("<td>"+rs.getString("name")+"</td>");
	out.print("<td>"+rs.getString("telephone")+"</td>");
	out.print("<td>"+rs.getString("roleId")+"</td>");
	out.print("</tr>");
}
rs.close();
dbm.close();
%>
</table>

<h3>Add User</h3>
<form method="post" action="adminUsers.jsp">
User: <input type="text" name="userName"><br>
Hash: <input type="text" name="hashing"><br>
Name: <input type="text" name="name"><br>
Tel: <input type="text" name="telephone"><br>
Role: 
<select name="roleId">
<option value="rol1">Admin</option>
<option value="rol2">User</option>
</select><br>
<input type="submit" value="Add">
</form>

<h3>Remove User</h3>
<form method="post" action="adminUsers.jsp">
User: <input type="text" name="removeName"><br>
<input type="submit" name="removeUser" value="Remove">
</form>
<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
