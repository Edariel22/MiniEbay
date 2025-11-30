<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Upload a Picture</title>
	</head>
	<body>
<%
	// Primero, recoje las variables sacadas del submit de sellProduct.
		String name = request.getParameter("name");
		String desc = request.getParameter("description");
		String dept = request.getParameter("dept_name"); // en realidad es el dept_id para facilidad de guardarlo
		String startBid = request.getParameter("startBid");
		String dueDate = request.getParameter("dueDate");
		String picture_path = ""; // comienza vacio, pero se le hace update cuando se sube la foto
			session.setAttribute("previousPage", "sellProduct.jsp");
			// "Setea" el attributo currentPage.
			session.setAttribute("currentPage", "upload.jsp");

	// Intenta conectar con la base de datos.
	try{
			//Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); //Manda al usuario de vuelta al login.
			}
			else{
				String userName = session.getAttribute("userName").toString();
			// Crea el objeto dbm, (database manager)
			applicationDBManager dbm = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(dbm.toString());

			// Primero, revisa si el usuario completo la informacion antes de añadirlo.
			if (name ==  null || desc == "" || dept=="" || startBid == "" || dueDate == ""){
				response.sendRedirect("sellProduct.jsp"); // Manda al usuario de vuelta
				dbm.close();
			}
				
			/* Llama la funcion addProduct, para poder llenar sus partes en la tabla de la base de datos,
			 * Si hay un error por algun caso, esta en booleano para que retorne falso si ese es el caso.
			 */
			boolean rsProd=	dbm.addProduct(name, desc, dept, startBid, dueDate, picture_path, userName);

			// Revisa si el producto fue añadido bien.
			if (rsProd){
				out.println("<p>Product listed successfully!</p>");

				// Crea una variable de sesion con el nombre del usuario.
				if (session.getAttribute("userName")==null ){
					session.setAttribute("userName", userName);

				} else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}

						%>
					<!-- Tuve que hacer lo de la foto de forma separada, ya que lo de multipart hace que las otras partes del upload sean null-->
						<a>Taken from Guru File Upload:<br/></a>
						Select file: <br />
						<form action="upload_action.jsp" method="post"
												enctype="multipart/form-data">
						<input type="file" name="picture_name" size="50" />
						<br />
						<input type="submit" value="Upload the picture" />
						</form>		
						<%

				} else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				%>
				Cannot be added <br>
			<%}
					
				// Cierra la conexion a la base de datos para mantener las cosas limpias.
				dbm.close();
			}

		} catch(Exception e){
			// En caso de que haya un error.
			%>Nothing to show!<%
			e.printStackTrace();
			response.sendRedirect("loginHashing.html");

		}finally{
			System.out.println("Finally");
		}
				%>		
		sessionName=<%=session.getAttribute("userName")%>
			

	</body>
</html>