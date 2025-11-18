<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
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
				%>
				<a>Guru File Upload:</a>
				Select file: <br />
				<form action="upload_action.jsp" method="post"
										enctype="multipart/form-data">
				<input type="file" name="picture_name" size="50" />
				<br />
				<input type="submit" value="Upload the picture again" />
				</form>		
				<%
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