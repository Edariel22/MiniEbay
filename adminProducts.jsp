<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Products</title>
	</head>
	<body>

<%
	session.setAttribute("previousPage", "welcomeMenu.jsp");
	session.setAttribute("currentPage", "adminProducts.jsp");

    // Intenta conectar con la base de datos, si no, manda al usuario al login hashing.
	try{
			//Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // Manda al usuario de vuelta al login.
			}
			else{
				String currentPage="adminProducts.jsp";
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

			// Modifica a un producto existente.
			if (request.getParameter("modifyProduct") != null) {
				String prodId = request.getParameter("prod_id"); // ID para poder encontrar al producto
				String newN = request.getParameter("newName"); // Nuevo nombre del producto
				String newDesc = request.getParameter("newDecription"); // Nueva descripcion del producto
				String newDeptId = request.getParameter("newDept_id"); // Nuevo departamento del producto (por ID)
				String newStartB = request.getParameter("newStartBid"); // Nueva oferta del principio del producto
				String newDueD = request.getParameter("newDueDate"); // Nueva fecha limite del producto
				String newPicP = request.getParameter("newPictureName"); // Nuevo nombre de la foto
				String newCreD = request.getParameter("newCreationDate"); // Nueva fecha de creacion del producto
				String newSellerN = request.getParameter("newUserName"); // nuevo usuario que "subio" el producto
				

				// Modifica el producto existente.
				boolean rsProd = dbm.updateProduct(Integer.parseInt(prodId), newN, newDesc, Integer.parseInt(newDeptId), newStartB, newDueD, newPicP, newCreD, newSellerN);

				if (rsProd){
					out.println("<p>Product modified successfully.</p>");
				} else {
					out.println("<p>Failed to modify product.</p>");
				}
			}


			//Remueve al producto de la base de datos.
				if(request.getParameter("removeProduct")!=null){
				String rP = request.getParameter("removeName");
				dbm.removeProduct(Integer.parseInt(rP));
				out.println("<p>Product removed.</p>");
			}

			//Crea un ResultSet para enseñar los productos intencionalmente null para buscarlos todos.
			ResultSet rsListP = dbm.listProducts(null);
			%>
				<!-- Para que el admin pueda ver los productos existentes -->
					<h2>Admin - Product List</h2>
					<table border="1">
					<tr>
					<td>Product ID</td>
					<td>Product Name</td>
					<td>Description</td>
					<td>Department ID</td>
					<td>Start Bid</td>
					<td>Due Date</td>
					<td>Picture Name</td>
					<td>Creation Date</td>
					<td>Seller</td>
					<%
					while(rsListP.next()){
						out.print("<tr>");
						out.print("<td>"+rsListP.getString("product_id")+"</td>");
						out.print("<td>"+rsListP.getString("name")+"</td>");
						out.print("<td>"+rsListP.getString("description")+"</td>");
						out.print("<td>"+rsListP.getString("dept_id")+"</td>");
						out.print("<td>"+rsListP.getString("start_bid")+"</td>");
						out.print("<td>"+rsListP.getString("due_date")+"</td>");
						out.print("<td>"+rsListP.getString("picture_path")+"</td>");
						out.print("<td>"+rsListP.getString("created_at")+"</td>");
						out.print("<td>"+rsListP.getString("userName")+"</td>");
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
	<!-- Opcion para añadir un producto nuevo -->
		<h3>Go To Sell Product</h3>
		<form method="POST" action="sellProduct.jsp">
		<input type="submit" name="submit" value="Sell Product">
		</form>
	<!-- Opcion para modificar un producto existente -->
		<h3>Modify Product</h3>
		<form method="POST" action="adminProducts.jsp">
		Product ID: <input type="text" name="prod_id"><br>
		New Product Name: <input type="text" name="newName"><br>
		New Description: <input type="text" name="newDescription"><br>
		New Department ID: <input type="text" name="newDept_id"><br>
		New Starting Bid: <input type="text" name="newStartBid"><br>
		New Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="newDueDate"><br>
		New Picture Name: <input type="text" name="newPictureName"><br>
		New Creation Date: <input type="text" name="newCreationDate"><br>
		New Seller: <input type="text" name="newUserName"><br>
		<input type="submit" name="modifyProduct" value="Modify">
		</form>
	<!-- Opcion para remover un producto -->
		<h3>Remove Product</h3>
		<form method="POST" action="adminProducts.jsp">
		User: <input type="text" name="removeName"><br>
		<input type="submit" name="removeProduct" value="Remove">
		</form>
		<a href="welcomeMenu.jsp">Return to Main Menu</a>
	</body>
</html>