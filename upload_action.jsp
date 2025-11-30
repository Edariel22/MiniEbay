<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%// Importa el paquete java.sql para poder usar la clase de ResultSet %>
<%@ page import="java.sql.*"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Upload the image</title>
	</head>
<body>
<%
	session.setAttribute("previousPage", "upload.jsp");
	session.setAttribute("currentPage", "upload_action.jsp");

		// Intenta conectar con la base de datos.
	try{
			//Revisa el proceso de autenticacion.
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // Manda al usuario de vuelta al login.
			}
			else{
				String currentPage="upload_action.jsp";
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
				String userActualName=rs.getString(3);
					
			// Crea el attributo currentPage.
				session.setAttribute("currentPage", currentPage);
					
				// Crea una variable de sesion con el nombre del usuario.	
				if (session.getAttribute("userName")==null ){
					//create the session variable
					session.setAttribute("userName", userName);
				}else{
					// O actualizala.
					session.setAttribute("userName", userName);
				}

					// Ruta donde se guardarán las imágenes dentro de la aplicación
					String uploadDir = application.getRealPath("/") + "images" + File.separator;
					File imagesDir = new File(uploadDir);
					if (!imagesDir.exists()) {
						imagesDir.mkdirs();
					}

					// Asegúrate de que la petición sea multipart/form-data
					String contentType = request.getContentType();
					if (contentType != null && contentType.indexOf("multipart/form-data") >= 0) {
						try {
							// Usa la API estándar de Servlet para obtener el archivo
							Part filePart = request.getPart("picture_name");
							if (filePart != null && filePart.getSize() > 0) {
								String submittedFileName = filePart.getSubmittedFileName();
								if (submittedFileName != null && !submittedFileName.isEmpty()) {
									// Elimina cualquier ruta que envíe el navegador y quédate solo con el nombre
									Path fileNamePath = Paths.get(submittedFileName).getFileName();
									String fileName = fileNamePath.toString();

									File targetFile = new File(imagesDir, fileName);
									try (InputStream in = filePart.getInputStream()) {
										Files.copy(in, targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
									}

									String picture_path = "images\\" + fileName;
									// En este JSP solo guardamos el archivo físico; el path ya está en la BD desde upload.jsp
								} else {
									out.println("<p>No file uploaded (empty filename).</p>");
								}
							} else {
								out.println("<p>No file uploaded.</p>");
							}

							// Si todo va bien, regresa al menú principal
							response.sendRedirect("welcomeMenu.jsp");

						} catch (Exception ex) {
							ex.printStackTrace();
							out.println("<p>Error occurred: " + ex.getMessage() + "</p>");
						}
					} else {
						out.println("<p>No file uploaded (request is not multipart/form-data).</p>");
					}

				}else{

					// Si falla, cierra la sesion con el usuario poniendolo en null.
					session.setAttribute("userName", null);
					
					// Retorna al usuario a la pagina de login.
					response.sendRedirect("loginHashing.html");
				}
				//rs.close();

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
