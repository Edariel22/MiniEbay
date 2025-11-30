<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add a new User.</title>
	</head>
	<body>

<%
	// Primero, recoje las variables sacadas del html de signup (addNewUser).
	String userName = request.getParameter("userName");
	String userPass = request.getParameter("userPass");
	String completeName = request.getParameter("completeName");
	String telephone = request.getParameter("telephone");	


	// Intenta conectar con la base de datos.
	try{
			// Crea el objeto dba, (database authentication) para poder autenticar al usuario.
			applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(dba.toString());

			// Primero, revisa si el usuario completo la informacion antes de añadirlo.
			if (userName ==  null || userName == "" || userPass=="" || completeName == "" || telephone == ""){
				response.sendRedirect("addNewUser.html"); // Manda al usuario de vuelta
				dba.close();
			}
				
			/* Llama la funcion addUser, para poder llenar sus partes en la tabla de la base de datos,
			 * y asignales el rol (en este caso, como es un usuario normal, rol2.
			 * Si hay un error por algun caso, esta en booleano para que retorne falso si ese es el caso.
			 */
			boolean rs=dba.addUser(userName, completeName, userPass, telephone);
			boolean rsRole=dba.setUserRole(userName);

			// Revisa si el usuario fue autenticado bien.
			if (rs && rsRole){%>
				User succesfully added 
				<%
				// "Setea" el attributo currentPage.
				session.setAttribute("currentPage", "addUser.jsp");

				// Crea una variable de sesion con el nombre del usuario.
				if (session.getAttribute("userName")==null ){
					session.setAttribute("userName", userName);

				} else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}

				// Redireciona al menu principal.
				response.sendRedirect("welcomeMenu.jsp"); %>

			<%}else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				%>
				Cannot be added <br>
			<%}
					
				// Cierra la conexion a la base de datos para mantener las cosas limpias.
				dba.close();
				
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
