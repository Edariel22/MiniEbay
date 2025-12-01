<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Place a Bid</title>
	</head>
	<body>

<%
 	// La página anterior real antes de llegar aquí es displayItem.jsp,
	// según la tabla webpageprevious. Usar ese valor o se rompe la autenticación.
	session.setAttribute("previousPage", "displayItem.jsp");
	session.setAttribute("currentPage", "bidProduct.jsp");

	// Intenta conectar con la base de datos.
	try{
			//Check the authentication process
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // send the User back to the login page
			}
			else{
				String productId = request.getParameter("productId");
				String currentPage="bidProduct.jsp";
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

					// Recoje la informacion del producto (nombre y oferta).
							ResultSet prod = dbm.getProductById(Integer.parseInt(productId));
							double startBid = 0;
							String productName = "";
							if (prod.next()) {
								startBid = prod.getDouble("start_bid");
								productName = prod.getString("name");
							}
							prod.close();

					// Recoje la oferta mas alta del producto.
						ResultSet prodHB = dbm.getHighestBid(Integer.parseInt(productId));
						double high = 0;
						if (prodHB.next() && prodHB.getString("highest_bid") != null) {
							high = prodHB.getDouble("highest_bid");
						}
						prodHB.close();

					// Si el usuario quiso poner su propia oferta (tiene que ser mas alta que la que ya estaba para que cuente).
					if (request.getParameter("placeBid") != null) {
						double amount = Double.parseDouble(request.getParameter("amount"));
						// Asegura que el usuario decidio usar un valor mas alto que el que ya estaba
						if (amount <= startBid || amount <= high) {
							out.println("Bid too low, must be higher than " + Math.max(startBid, high));
						} else {
							dbm.placeBid(Integer.parseInt(productId), userName, "" + amount);
							out.println("Bid placed: $" + amount);
						}
				

				out.println("<br><a href='displayItem.jsp?productId=" + productId + "'>Back</a>");
						} else {
			%>
				<!-- Parte html para que el usuario pueda ponerle una mejor oferta al producto.-->
							<h2>Place a Bid on: <%=productName%></h2>
							Start Bid: $<%=startBid%><br>
							Highest Bid: $<%=high%><br><br>
							<form method="post" action="bidProduct.jsp?productId=<%=productId%>">
								Amount: <input type="text" name="amount">
								<input type="submit" name="placeBid" value="Bid">
							</form>
							<a href="displayItem.jsp?productId=<%=productId%>">Back</a>
								<%
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
	</body>
</html>
