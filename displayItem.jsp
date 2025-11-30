<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Product Details</title>
	</head>
	<body>

<%
			session.setAttribute("previousPage", "findProduct.jsp");
		// "Setea" el attributo currentPage.
			session.setAttribute("currentPage", "displayItem.jsp");

		// Intenta conectar con la base de datos.
		try{
					//Revisa el proceso de autenticacion.
				if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					response.sendRedirect("loginHashing.html");
					
				}else{
					String productId = request.getParameter("productId");
					
					String currentPage = "displayItem.jsp";
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
					ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

					// Revisa si el usuario fue autenticado bien.
					if (rsUser.next()){
						String sessionName = rsUser.getString(3);

						// Crea el attributo currentPage.
						session.setAttribute("currentPage", currentPage);

						// Crea una variable de sesion con el nombre del usuario.
						if (session.getAttribute("userName") == null) {
							session.setAttribute("userName", userName);
						}else{
								// O actualizala.
							session.setAttribute("userName", userName);
						}

						//Recoje los detalles del objeto por el ID
						ResultSet rs = dbm.getProductById(Integer.parseInt(productId));

						if (rs.next()) {
						// Enseña los detalles de cada producto.
						%>

						<form action="findProduct.jsp" method="GET">
							<input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
							<input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
							<input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
							<button type="submit" name="findProduct" value="findProduct">Return to the list of products</button>
						</form> <br>
								<br> 

						<form action="welcomeMenu.jsp" method="GET">
							<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
						</form> <br> <br>

						<h2>Product Details</h2>
						<!-- Enseña el ID, la descripcion, y la foto de forma mas grande. -->
						<p>ID: <%= rs.getString(1) %></p> <!--Lo primero en la tabla es el ID -->
						<p>Name: <%= rs.getString(2) %></p> <!--Luego el nombre -->
						<p>Description: <%= rs.getString(3) %></p> <!--Luego la descripcion -->
						<p>Department: <%= rs.getString(4) %></p> <!--Luego el departamento donde esta -->
						<p>Original Bid $<%= rs.getString(5) %></p> <!--Luego, cuanto es la oferta puesta al principio -->
						<p>Due Date: <%= rs.getString(6) %></p> <!--Pero... pa cuando? -->
						<img src="/MiniEbay/images/<%= rs.getString("picture_path") %>" alt="<%= rs.getString("name")%>"
						style="width: 400px; height: auto;">
						<p>Date Added: <%=rs.getString(8)%></p> <!--Luego, cuando fue añadido -->
						<p>Seller: <%=rs.getString(9)%></p> <!--Al final, quien lo esta vendiendo -->

						<form action="bidProduct.jsp" method="POST">
							<input type="hidden" name="productId" value="<%= request.getParameter("productId") %>">
							<input type="hidden" name="productName" value="<%= request.getParameter("productName") %>">
							<input type="hidden" name="dept_name" value="<%= request.getParameter("dept_name") %>">
							<!-- Necesario para poder añadir una mejor oferta :) -->
							<button type="submit">Place Bid</button>
						</form>
						<%
					}else{
						// Si no encuentra un producto con ese ID
						%>
						<p>Unfortunately, no product was found with ID: <%= productId %></p>
						<%
					}
				}else{
					//Close any session associated with the user
					session.setAttribute("userName", null);

					//return to the login page
					response.sendRedirect("loginHashing.html");
				}

				// Close the connection to the database
				dba.close();
				dbm.close();
			} 
		}catch(Exception e) {
		//If an exception occurs, print the stack trace
		e.printStackTrace();
		response.sendRedirect("loginHashing.html");
	}finally{
		System.out.println("Finallly");
	}
	%>
	</body>
</html>