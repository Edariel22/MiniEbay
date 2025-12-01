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
				
			// Usando ResulSet, intenta verificar al usuario.
				ResultSet rs=dba.verifyUser(userName, currentPage, previousPage);
			
			// Revisa si el usuario fue autenticado bien.
			if (rs.next()){
          
			// Añade al usuario (si no hay error ni nada).
			if (request.getParameter("userName") != null && request.getParameter("addUser") != null) {
				String userN = request.getParameter("userName"); // Nombre para el usuario nuevo
				String pass = request.getParameter("hashing"); // Password para el usuario
				String rN = request.getParameter("name"); // Nuevo nombre "real"
				String tele = request.getParameter("telephone"); // Numero de telefono del nuevo usuario
				String userRI = request.getParameter("roleId"); // Rol para el usuario
				
				// Añade al nuevo usuario.
				boolean rsUser = dba.addUser(userN, rN, pass, tele);
				boolean rsRole = dba.setUserRole(userN,userRI);

				// Revisa si el usuario fue autenticado bien.
				if (rsUser && rsRole){
					out.println("<p>User added successfully.</p>");
				} else {
					out.println("<p>Failed to add user.</p>");
				}
			}

			// Modifica a un usuario existente.
			if (request.getParameter("modifyUser") != null) {
				String userN = request.getParameter("userName"); // Nombre para poder encontrar al usuario
				String newPass = request.getParameter("hashing"); // Password nuevo para el usuario
				String newRN = request.getParameter("name"); // Nuevo nombre "real"
				String newTele = request.getParameter("telephone"); // Nuevo numero de telefono del usuario
				String newUserRI = request.getParameter("roleId"); // Nuevo rol para el usuario
				

				// Modifica el usuario existente.
				boolean rsUser = dba.updateUser(userN, newPass, newRN, newTele);
				boolean rsRole = dba.updateUserRole(userN,newUserRI);

				if (rsUser && rsRole){
					out.println("<p>User modified successfully.</p>");
				} else {
					out.println("<p>Failed to modify user.</p>");
				}
			}


			//Remueve al usuario de la base de datos.
				if(request.getParameter("removeUser")!=null){
				String rU = request.getParameter("removeName");
				dba.removeUser(rU);
				out.println("<p>User removed.</p>");
			}

			//Crea un ResultSet para enseñar los usuarios y otro para enseñar sus roles.
			ResultSet rsListU = dba.listUsers();
			%>
				<!-- Para que el admin pueda ver los usuarios existentes -->
					<h2>Admin - User List</h2>
					<table border="1">
					<tr>
					<td>Username</td>
					<td>Name</td>
					<td>Telephone</td>
					<%
					while(rsListU.next()){
						out.print("<tr>");
						out.print("<td>"+rsListU.getString("userName")+"</td>");
						out.print("<td>"+rsListU.getString("name")+"</td>");
						out.print("<td>"+rsListU.getString("telephone")+"</td>");
						out.print("</tr>");
					}
				%>
					<td>Role per User</td></tr>
				<%
				ResultSet rsListR = dba.listRoles();
					while(rsListR.next()){
						out.print("<tr>");
						out.print("<td>"+rsListR.getString("userName")+"</td>");
						out.print("<td>"+rsListR.getString("roleId")+"</td>");
						out.print("</tr>");
					}
			}else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				
				// Retorna al usuario a la pagina de login.
				response.sendRedirect("loginHashing.html");
			}

				// Cierra la conexion a la base de datos para mantener las cosas limpias.
				dba.close();
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
		Hash: <input type="password" name="hashing"><br>
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
		Hash: <input type="password" name="hashing"><br>
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
