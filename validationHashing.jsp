<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Validate the login attempt.</title>
	</head>
	<body>

<%
	// Recoje las variables del html de login.
	String userName = request.getParameter("userName");
	String userPass = request.getParameter("userPass");
	
	
	// Intenta conectar con la base de datos.
	try{
			// Crea el objeto dba, (database authentication) para poder autenticar al usuario.
			applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(dba.toString());
			
			// Llama el metodo de autenticacion, para ver si el set de resultados es valido
			ResultSet rs=dba.authenticate(userName, userPass);%>
		
			
			
			<%// Revisa si el usuario fue autenticado bien.
			if (rs.next()){
				
				
				// "Setea" el attributo currentPage.
				session.setAttribute("currentPage", "validationHashing.jsp");
				
				// Crea una variable de sesion con el nombre del usuario.	
				if (session.getAttribute("userName")==null ){
					session.setAttribute("userName", userName);
				} else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}
				
				// Ve a la pagina del menu principal
				response.sendRedirect("welcomeMenu.jsp");
				
			}else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
				session.setAttribute("userName", null);
				
				// y regresa al usuario a la pagina de login
				response.sendRedirect("loginHashing.html");
				}
				// Cierra el ResultSet y la conexion a la base de datos para mantener las cosas limpias.
				rs.close();
				dba.close();
			
			} catch(Exception e)
			{%>
				Nothing to show!
			<% 	// En caso de que haya un error.
				e.printStackTrace();
				response.sendRedirect("loginHashing.html");
			}finally{
				System.out.println("Finally");
			}
			%>		
		sessionName=<%=session.getAttribute("userName")%>
		
		
	</body>
</html>
