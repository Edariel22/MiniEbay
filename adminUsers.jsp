<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
	<head>
		<title>Admin Users</title>
	</head>
	<body>

<%
try {

    //Authenticate if the user is logged in, if not redirect the user to login hashing
    if (session.getAttribute("userName") == null) {
   	 	response.sendRedirect("loginHashing.html");
	}else{
		String currentPage = "adminUsers.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();


        //Create dba object
        applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(dba.toString());

        //Create dbm object
        applicationDBManager dbm = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(dbm.toString());


        //Call the verifyUser method to authenticate the user
        ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

        // Verify if the user has been authenticated
        if (rsUser.next()) {
          
			// Add user
			if (request.getParameter("userName") != null && request.getParameter("addUser") != null) {
				String u = request.getParameter("userName");
				String p = request.getParameter("hashing"); // treat as password input
				String n = request.getParameter("name");
				String t = request.getParameter("telephone");
				String r = request.getParameter("roleId");
				
		
				String hashed = dba.getHashedValue(u, p);

				// Add user with hashed password
				boolean res = dbm.addUser(u, hashed, n, t, r);
				boolean resRole = dba.setUserRole(u);

				if (res && resRole) {
					out.println("<p>User added successfully.</p>");
				} else {
					out.println("<p>Failed to add user.</p>");
				}
			}

			// Modify user
			if (request.getParameter("modifyUser") != null) {
				String u = request.getParameter("userName");
				String p = request.getParameter("hashing");
				String n = request.getParameter("name");
				String t = request.getParameter("telephone");
				String r = request.getParameter("roleId");
				
				String hashed = dba.getHashedValue(u, p);

				// Update existing user record
				boolean res = dbm.updateUser(u, hashed, n, t, r);

				if (res) {
					out.println("<p>User modified successfully.</p>");
				} else {
					out.println("<p>Failed to modify user.</p>");
				}
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
		// Close the connection to the database
		dba.close();
		dbm.close();
		}	
	}
	 
}catch(Exception e) {
    //If an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
}finally{
    System.out.println("Finallly");
}
%>
	</table>

		<h3>Add User</h3>
		<form method="POST" action="adminUsers.jsp">
		User: <input type="text" name="userName"><br>
		Hash: <input type="text" name="hashing"><br>
		Name: <input type="text" name="name"><br>
		Tel: <input type="text" name="telephone"><br>
		Role: 
		<select name="roleId">
		<option value="rol1">Admin</option>
		<option value="rol2">User</option>
		</select><br>
		<input type="submit" name="addUser" value="Add">
		</form>

		<h3>Modify User</h3>
		<form method="POST" action="adminUsers.jsp">
		User: <input type="text" name="userName"><br>
		Hash: <input type="text" name="hashing"><br>
		Name: <input type="text" name="name"><br>
		Tel: <input type="text" name="telephone"><br>
		Role: 
		<select name="roleId">
		<option value="rol1">Admin</option>
		<option value="rol2">User</option>
		</select><br>
		<input type="submit" name="modifyUser" value="Modify">
		</form>

		<h3>Remove User</h3>
		<form method="POST" action="adminUsers.jsp">
		User: <input type="text" name="removeName"><br>
		<input type="submit" name="removeUser" value="Remove">
		</form>
		<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
