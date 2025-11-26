<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Home page for Mini Ebay!</title>
	</head>
	<body>
	
<%
 	
	session.setAttribute("previousPage", "validationHashing.jsp");
	session.setAttribute("currentPage", "welcomeMenu.jsp");

	// Intenta conectar con la base de datos.
	try{
			//Check the authentication process
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // send the User back to the login page
			}
			else{
				String currentPage="welcomeMenu.jsp";
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
				// Del Resulset, saca el string numero 3 que contiene el verdadero nombre del usuario.
				String userActualName=rs.getString(3);
					
				// Crea el attributo currentPage.
				session.setAttribute("currentPage", currentPage);
					
				// Crea una variable de sesion con el nombre del usuario.	
				if (session.getAttribute("userName")==null ){
					session.setAttribute("userName", userName);

				}else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}
					
				%>
				Welcome! <%=userActualName%>
				
				<!-- Parte html para que me encuentren los productos plz.-->
				<form action="findProduct.jsp" method="GET">
					<label for="search">Search:</label>
					<input type="text" id="productName" name="productName" placeholder="Enter product name">
					<button type="submit">Search</button>
					

					<%
					ResultSet rsDept=dbm.listAllDepartment();
					%>
					<!-- Y parte para que me enseñen de que departamento esta cada cosa. -->
					<form action="findProduct.jsp" method="GET">
						<table border="0">
							<tr>
								<td> Department </td>
								<td>
									<select id="dept_name" name="dept_name" style="width: 200px; font-size: 16px;">
									<option value="All Departments">All Departments</option>
									<%
										while (rsDept.next()) {
											String deptId = rsDept.getString("dept_id");
											String deptName = rsDept.getString("name");
									%>
											<option value="<%= deptId %>"><%= deptName %></option>
									<%
										}
									%>
								</select>

								</td>
							</tr>
						</table>
						<input type="reset" id="Submit" value="reset" />
						<a href="signout.jsp">
								<button type="button">Sign Out</button>
							</a>
					</form>
					<table>
					<%
			/* Parte para escojer si quieres buscar un producto,
			 * o si el usuario quiere vender algun objeto.
					%>
			<form action="findProduct.jsp" method="POST">
			<button type="submit">Find Product</button>
			<br>
			</form>
			<form action="sellProduct.jsp" method="POST">
			<button type="submit">Sell Product</button>
			</form>
					</table>

					<%
					
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
	</body>
</html>
