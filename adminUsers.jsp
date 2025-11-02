<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.miniebay.*" %>

<html>
<head><title>Admin Users</title></head>
<body>

<%
//Create the database manager object
applicationDBManager dbm = new applicationDBManager();

//Call the method to list all users
ResultSet rs = dbm.listAllUsers();
%>

<h2>Admin - User List</h2>

<!-- Simple table to show users -->
<table border="1">
<tr>
<td>Username</td>
<td>Name</td>
<td>Telephone</td>
<td>Role</td>
</tr>

<%
//Read the ResultSet and print all users
while (rs.next()) {
	out.print("<tr>");
	out.print("<td>" + rs.getString("userName") + "</td>");
	out.print("<td>" + rs.getString("name") + "</td>");
	out.print("<td>" + rs.getString("telephone") + "</td>");
	out.print("<td>" + rs.getString("roleId") + "</td>");
	out.print("</tr>");
}
rs.close();
%>

</table>

<!-- Simple form to add a user -->
<h3>Add User</h3>
<form method="post" action="adminUsers.jsp">
Username: <input type="text" name="userName"><br>
Password Hash: <input type="text" name="hashing"><br>
Name: <input type="text" name="name"><br>
Telephone: <input type="text" name="telephone"><br>
Role:
<select name="roleId">
<option value="rol1">Admin</option>
<option value="rol2">User</option>
</select><br>
<input type="submit" value="Add">
</form>

<!-- Simple form to remove a user -->
<h3>Remove User</h3>
<form method="post" action="removeUser.jsp">
Username: <input type="text" name="userName"><br>
<input type="submit" value="Remove">
</form>

<!-- Close the connection -->
<%
dbm.close();
%>

</body>
</html>
