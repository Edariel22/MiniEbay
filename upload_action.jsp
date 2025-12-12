<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.io.*,java.util.*, jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet5.*" %>
<%@ page import="org.apache.commons.fileupload2.core.*" %>
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
	session.setAttribute("previousPage", "sellProduct.jsp");
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
				String userActualName=rs.getString("name");
					
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
					File file ;
					int maxFileSize = 5000 * 1024;
					int maxMemSize = 5000 * 1024;
					String filePath = "C:\\Users\\Angel\\Downloads\\apache-tomcat-11.0.10\\webapps\\MiniEbay\\images\\"; // Depende de la computadora que se este usando.
					String picture_path = "";
				// Primero, recoje las variables sacadas del submit de sellProduct.
					String name = "";
					String desc = "";
					String dept = ""; // en realidad es el dept_id para facilidad de guardarlo.
					String startBid = ""; 
					String dueDate = "";
					String fileName = "";
					String createdDate =  "";
					boolean rsProd = false;
				   String contentType = request.getContentType();
				   if ((contentType.indexOf("multipart/form-data") >= 0)) {
				 
					 
					  DiskFileItemFactory factory = DiskFileItemFactory.builder()
						.setPath(filePath)
						.get();      
					  
					  
					 
					  JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
					  upload.setSizeMax( maxFileSize );
					  try{ 
						 List fileItems = upload.parseRequest(request);
						 Iterator i = fileItems.iterator();
						 while ( i.hasNext () ) 
						 {
							FileItem fi = (FileItem)i.next();
								if (fi.isFormField () )  {
								// Si es un valor (en este caso texto, en vez de un file).
									String fieldName = fi.getFieldName();
										String fieldValue = fi.getString();  // Valor del field.
											
										// Aqui es que se procesan los valores que no son files.
										if ("name".equals(fieldName)) {
											name = fieldValue;  // Nombre del producto.
										} else if ("description".equals(fieldName)) {
											desc = fieldValue;  // Descripcion del producto.
										} else if ("dept_name".equals(fieldName)) {
											dept = fieldValue;  // Id del departamento (para guardarlo en el producto).
										} else if ("startBid".equals(fieldName)) {
											startBid = fieldValue;  // Valor que comienza la oferta.
										} else if ("dueDate".equals(fieldName)) {
											dueDate = fieldValue;  // Fecha que termina la oferta.
										} else if ("createdDate".equals(fieldName)) {
											createdDate = fieldValue;  // Fecha en que fue creada la oferta
										}
							} else { // Aqui va el file (en este caso, la foto).
									String fieldName = fi.getFieldName();
											fileName = fi.getName();
											boolean isInMemory = fi.isInMemory();
											long sizeInBytes = fi.getSize();
											file = new File( filePath + fileName) ;
											Path path = FileSystems.getDefault().getPath(filePath + fileName);
											fi.write( path ) ;
											picture_path = "images\\" + fileName;
										}
									 
									}
									// Primero, revisa si el usuario completo la informacion antes de añadirlo.
									if (name ==  "" || desc == "" || dept=="" || startBid == "" || dueDate == "" || createdDate ==  "" || fileName == ""){
										response.sendRedirect("sellProduct.jsp"); // Manda al usuario de vuelta
										dbm.close();
									}
												
									/* Llama la funcion addProduct, para poder llenar sus partes en la tabla de la base de datos,
									 * Si hay un error por algun caso, esta en booleano para que retorne falso si ese es el caso.
									 */
									rsProd=	dbm.addProduct(name, desc, dept, startBid, dueDate, fileName, createdDate, userName);

									// Revisa si el producto fue añadido bien.
									if (rsProd){
										System.out.println("<p>Product listed successfully!</p>");
										response.sendRedirect("welcomeMenu.jsp");
									}
							} catch (Exception ex) {
								ex.printStackTrace();
								System.out.println("<p>Error occurred: " + ex.getMessage() + "</p>");
								response.sendRedirect("sellProduct.jsp");
							}

					} else {
						System.out.println("<p>No file uploaded</p>");
						response.sendRedirect("sellProduct.jsp");
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
