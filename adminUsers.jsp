<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Users</title>
	</head>
	<body>

<%
	session.setAttribute("previousPage", "welcomeMenu.jsp");
	session.setAttribute("currentPage", "adminUsers.jsp");

    // Intenta conectar con la base de datos, si no, manda al usuario al login hashing.
	try{
			//Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // Manda al usuario de vuelta al login.
			}
			else{
				String currentPage="adminUsers.jsp";
				String userName = session.getAttribute("userName").toString();
				String previousPage = session.getAttribute("previousPage").toString();
		
			//Crea el objeto dba, (database authentication) para poder autenticar al usuario.
				applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(dba.toString());

			//Crea el objeto dbm, (database manager) para poder manejar la base de datos.
				applicationDBManager dbm = new applicationDBManager();
				System.out.println("Connecting...");
				System.out.println(dbm.toString());
				
			// Usando ResulSet, intenta verificar al usuario.
				ResultSet rs=dba.verifyUser(userName, currentPage, previousPage);
			
			// Revisa si el usuario fue autenticado bien.
			if (rs.next()){
          
			// Añade al usuario (si no hay error ni nada).
			if (request.getParameter("userName") != null && request.getParameter("addUser") != null) {
				String u = request.getParameter("userName");
				String p = request.getParameter("hashing"); // treat as password input
				String n = request.getParameter("name");
				String t = request.getParameter("telephone");
				String r = request.getParameter("roleId");
				
		
				String hashed = dba.getHashedValue(u, p);

				// Add user with hashed password using admin helper
				boolean res = dbm.addUserAdmin(u, hashed, n, t, r);

				if (res) {
					out.println("<p>User added successfully.</p>");
				} else {
					out.println("<p>Failed to add user.</p>");
				}
			}

			// Modifica a un usuario existente.
			if (request.getParameter("modifyUser") != null) {
				String u = request.getParameter("userName");
				String p = request.getParameter("hashing");
				String n = request.getParameter("name");
				String t = request.getParameter("telephone");
				String r = request.getParameter("roleId");
				
				String hashed = dba.getHashedValue(u, p);

				// Modifica el usuario con un ayudante de administrador.
				boolean res = dbm.updateUserAdmin(u, hashed, n, t, r);

				if (res) {
					out.println("<p>User modified successfully.</p>");
				} else {
					out.println("<p>Failed to modify user.</p>");
				}
			}


			//Remueve al usuario de la base de datos.
				if(request.getParameter("removeUser")!=null){
				String ru = request.getParameter("removeName");
				dbm.removeUserAdmin(ru);
				out.println("<p>User removed.</p>");
			}

			//List users
			ResultSet rs = dbm.listAllUsers();
			%>
				<!-- Para que el admin pueda ver los usuarios existentes -->
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
			}else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				
				// Retorna al usuario a la pagina de login.
				response.sendRedirect("loginHashing.html");
			}

				// Cierra el ResultSet y las conexiones a la base de datos para mantener las cosas limpias.
				rs.close();
				dba.close();
				dbm.close();
			}

		}catch(Exception e){
			%>Nothing to show!<%
		// En caso de que haya un error.
			e.printStackTrace();
			response.sendRedirect("loginHashing.html");

		}finally{
			System.out.println("Finally");
		}
%>
	</table>
	<!-- Opcion para añadir un usuario nuevo -->
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
	<!-- Opcion para modificar un usuario existente -->
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
	<!-- Opcion para remover un usuario -->
		<h3>Remove User</h3>
		<form method="POST" action="adminUsers.jsp">
		User: <input type="text" name="removeName"><br>
		<input type="submit" name="removeUser" value="Remove">
		</form>
		<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
