<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.io.*,java.util.*, jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet5.*" %>
<%@ page import="org.apache.commons.fileupload2.core.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Guru File Upload</title>
</head>
<body>
<%
	session.setAttribute("previousPage", "sellProduct.jsp");
	session.setAttribute("currentPage", "upload_action.jsp");

	//Try to connect the database using the classes applicationDBManager & applicationDBAuthenticationGoodComplete
	try{
			//Check the authentication process
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // send the User back to the login page
			}
			else{
				String currentPage="upload_action.jsp";
				String userName = session.getAttribute("userName").toString();
				String previousPage = session.getAttribute("previousPage").toString();
		
			//Create the dba object
				applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(dba.toString());

			//Create the dbm object
				applicationDBManager dbm = new applicationDBManager();
				System.out.println("Connecting...");
				System.out.println(dbm.toString());
				
			//Call the verifyUser method
				ResultSet rs=dba.verifyUser(userName, currentPage, previousPage);
			
			//Check if the user has been authenticated
			if (rs.next()){
				String userActualName=rs.getString(3);
					
				//Create the current page attribute
				session.setAttribute("currentPage", currentPage);
					
				//Create a session variable
				if (session.getAttribute("userName")==null ){
					//create the session variable
					session.setAttribute("userName", userName);
				}else{
					//Update the session variable
					session.setAttribute("userName", userName);
				}
				   File file ;
				   int maxFileSize = 5000 * 1024;
				   int maxMemSize = 5000 * 1024;
				   String filePath = "C:\\Users\\Angel\\Downloads\\apache-tomcat-11.0.10\\webapps\\MiniEbay\\images\\";
						String name = request.getParameter("name");
						String desc = request.getParameter("description");
						String dept = request.getParameter("dept_name");
						String startBid = request.getParameter("startBid");
						String dueDate = request.getParameter("dueDate");
						String picture_path = "images\\"+ request.getParameter("picture_name");
				 
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
							if ( !fi.isFormField () )  {
								String fieldName = fi.getFieldName();
										String fileName = fi.getName();
										boolean isInMemory = fi.isInMemory();
										long sizeInBytes = fi.getSize();
										file = new File( filePath + fileName) ;
										Path path = FileSystems.getDefault().getPath(filePath + fileName);
										fi.write( path ) ;
										picture_path = "images\\" + fileName;
									}
								 
								}
								if (name.isEmpty() || desc.isEmpty() || startBid.isEmpty() || dueDate.isEmpty() || picture_path.isEmpty()) {
									out.println("<p>Please fill out all fields.</p>");
									
								} else {
										dbm.addProduct(name, desc, dept, startBid, dueDate, picture_path, userName);
										out.println("<p>Product listed successfully!</p>");

								}

							} catch (Exception ex) {
								ex.printStackTrace();
								out.println("<p>Error occurred: " + ex.getMessage() + "</p>");
							}

					} else {
						out.println("<p>No file uploaded</p>");
					}
				}else{
					//Close any session associated with the user
					session.setAttribute("userName", null);
					
					//return to the login page
					response.sendRedirect("loginHashing.html");
				}
				//rs.close();

				//Close the connection to the database
				dba.close();
				dbm.close();
			}
		}catch(Exception e){
			%>Nothing to show!<%
			e.printStackTrace();
			response.sendRedirect("loginHashing.html");
		}finally{
			System.out.println("Finally");
		}
		%>			
	</body>
</html>
