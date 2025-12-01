<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>

<html>
	<head>
		<title>Sell a Product</title>
	</head>
	<body>

<%
	session.setAttribute("previousPage", "welcomeMenu.jsp");
	session.setAttribute("currentPage", "sellProduct.jsp");

	// Intenta conectar con la base de datos.
	try{
			// Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // Manda al usuario de vuelta al login.
			}
			else{
				String currentPage="sellProduct.jsp";
				String userName = session.getAttribute("userName").toString();
				String previousPage = session.getAttribute("previousPage").toString();
		
			// Crea el objeto dba, (database authentication) para poder autenticar al usuario.
				applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(dba.toString());

			// Crea el objeto dbm, (database manager) para poder manejar la base de datos.
				applicationDBManager dbm = new applicationDBManager();
				System.out.println("Connecting...");
				System.out.println(dbm.toString());
				
			// Usando ResultSet, intenta verificar al usuario.
				ResultSet rs=dba.verifyUser(userName, currentPage, previousPage);
			
			// Revisa si el usuario fue autenticado bien.
			if (rs.next()){
				String userActualName=rs.getString("name");
					
				// Crea el attributo currentPage.
				session.setAttribute("currentPage", currentPage);
					
				// Crea una variable de sesion con el nombre del usuario.	
				if (session.getAttribute("userName")==null ){
					session.setAttribute("userName", userName);
				}else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}
					// Recoje los departamentos, para poder escojer entre ellos.
						ResultSet rsDept = dbm.listAllDepartments();
			
					// para poderlos subir al miniebay
					String name = "";
					String desc = "";
					String dept = "";
					String startBid = "";
					String dueDate = "";
					String picture_path = "";
				%>

					<h2>Sell a Product</h2>
					<!--Forma para los datos del objeto nuevo (no foto ya que ese es lo que va luego).-->
					<form action="upload.jsp" method="POST">
						Name: <input type="text" name="name" required><br>
						Description: <input type="text" name="description" required><br>
						Starting Bid $: <input type="text" name="startBid" required><br>
						Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
						Picture Name: <input type="text" name="picture_path" required><br>  (please use the same name as the picture you will upload, including the type)<br>
						Department:
						<select name="dept_name">
							<%
							while (rsDept.next()) {
							%>
								<option value="<%=rsDept.getString("dept_id")%>">
								<%=rsDept.getString("name")%>
								</option>
							<%
							}
							rsDept.close();
							%>
						</select><br><br>
						<input type="submit" name="addProduct" value="Submit">
						<input type="reset" value="Reset">
					</form>

					<form action="welcomeMenu.jsp" method="POST">
						<button type="submit">Back to main page</button>
					</form>

					<%
				}else{
					// Si falla, cierra la sesion con el usuario poniendolo en null.
					session.setAttribute("userName", null);
					
					// Retorna al usuario a la pagina de login.
					response.sendRedirect("loginHashing.html");
				}

				// Cierra las conexiones a la base de datos para mantener las cosas limpias.
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
	</body>
</html>
