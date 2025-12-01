<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Departments</title>
	</head>
	<body>

<%
	session.setAttribute("previousPage", "welcomeMenu.jsp");
	session.setAttribute("currentPage", "adminDepartments.jsp");

    // Intenta conectar con la base de datos, si no, manda al usuario al login hashing.
	try{
			//Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // Manda al usuario de vuelta al login.
			}
			else{
				String currentPage="adminDepartments.jsp";
				String userName = session.getAttribute("userName").toString();
				String previousPage = session.getAttribute("previousPage").toString();
		
			//Crea el objeto dba, (database authentication) para poder autenticar al usuario.
				applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(dba.toString());

			// Crea el objeto dbm, (database manager) para poder manejar la base de datos.
				applicationDBManager dbm = new applicationDBManager();
				System.out.println("Connecting...");
				System.out.println(dbm.toString());
				
			// Usando ResulSet, intenta verificar al usuario.
				ResultSet rs=dba.verifyUser(userName, currentPage, previousPage);
			
			// Revisa si el usuario fue autenticado bien.
			if (rs.next()){
          
			// Añade el departamento (si no hay error ni nada).
			if (request.getParameter("addDept") != null) {
				String deptName = request.getParameter("name"); // Nombre del departamento
				String deptBuild = request.getParameter("building"); // Edificio
				
				// Añade el nuevo departamento.
				boolean rsDept = dbm.addDepartment(deptName, deptBuild);

				// Revisa si se pudo añadir el departamento.
				if (rsDept){
					out.println("<p>Department added successfully.</p>");
				} else {
					out.println("<p>Failed to add department.</p>");
				}
			}

			// Modifica a un usuario existente.
			if (request.getParameter("modifyDept") != null) {
				String deptId = request.getParameter("dept_id"); // id del departamento
				String newDeptName = request.getParameter("newName"); // Nuevo nombre del departamento
				String newDeptBuild = request.getParameter("newBuilding"); // Edificio Nuevo
				

				// Modifica el usuario existente.
				boolean rsUser = dbm.updateDepartment(Integer.parseInt(deptId), newDeptName, newDeptBuild);

				if (rsUser){
					out.println("<p>Department modified successfully.</p>");
				} else {
					out.println("<p>Failed to modify department.</p>");
				}
			}


			//Remueve al usuario de la base de datos.
				if(request.getParameter("removeDept")!=null){
				String rD = request.getParameter("removeName");
				dbm.removeDepartment(Integer.parseInt(rD));
				out.println("<p>Department removed.</p>");
			}

			//Crea un ResultSet para enseñar los departamentos.
			ResultSet rsListD = dbm.listAllDepartments();
			%>
				<!-- Para que el admin pueda ver los usuarios existentes -->
					<h2>Admin - Department List</h2>
					<table border="1">
					<tr>
					<td>Department ID</td>
					<td>Deparment Name</td>
					<td>Building</td>
					<%
					while(rsListD.next()){
						out.print("<tr>");
						out.print("<td>"+rsListD.getString("dept_id")+"</td>");
						out.print("<td>"+rsListD.getString("name")+"</td>");
						out.print("<td>"+rsListD.getString("building")+"</td>");
						out.print("</tr>");
					}
			}else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				
				// Retorna al usuario a la pagina de login.
				response.sendRedirect("loginHashing.html");
			}

				// Cierra las conexiones a la base de datos para mantener las cosas limpias.
				dbm.close();
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
	<!-- Opcion para añadir un departamento nuevo -->
		<h3>Add Department</h3>
		<form method="POST" action="adminDepartments.jsp">
		Department Name: <input type="text" name="name"><br>
		Building: <input type="text" name="building"><br>
		<input type="submit" name="addDept" value="Add">
		</form>
	<!-- Opcion para modificar un departamento existente -->
		<h3>Modify Department</h3>
		<form method="POST" action="adminDepartments.jsp">
		Department ID: <input type="text" name="dept_id"><br>
		New Department Name: <input type="text" name="newName"><br>
		New Building: <input type="text" name="newBuilding"><br>
		<input type="submit" name="modifyDept" value="Modify">
		</form>
	<!-- Opcion para remover un departamento -->
		<h3>Remove Department</h3>
		<form method="POST" action="adminDepartments.jsp">
		Department: <input type="text" name="removeName"><br>
		<input type="submit" name="removeDept" value="Remove">
		</form>
		<a href="welcomeMenu.jsp">Return to Main Menu</a>
	</body>
</html>