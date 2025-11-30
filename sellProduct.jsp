<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<html>
	<head>
		<title>Sell a Product</title>
	</head>
	<body>

<%
	session.setAttribute("previousPage", "welcomeMenu.jsp");
	session.setAttribute("currentPage", "sellProduct.jsp");

	//Try to connect the database using the classes applicationDBManager & applicationDBAuthenticationGoodComplete
	try{
			//Check the authentication process
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // send the User back to the login page
			}
			else{
				String currentPage="sellProduct.jsp";
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
					// get departments for dropdown
						ResultSet rsDept = dbm.listAllDepartment();
				%>

					<h2>Sell a Product</h2>

					<!-- Step 1: create the product (no file upload yet) -->
					<form action="upload.jsp" method="POST">
						Name: <input type="text" name="name" required><br>
						Description: <input type="text" name="description" required><br>
						Starting Bid $: <input type="text" name="startBid" required><br>
						Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
						<!-- Picture name is just a text field here; the real file is uploaded on the next page -->
						Picture Name: <input type="text" name="picture_path" required><br>
						(please use the same name as the picture you will upload, including the type)<br>
						Department:
						<select name="dept_name">
							<%
							while (rsDept.next()) {
							%>
								<option value="<%=rsDept.getString("dept_id")%>">
								<%=rsDept.getString("name")%>
								</option>
							<%
							}
							rsDept.close();
							%>
						</select><br><br>
						<input type="submit" name="addProduct" value="Submit">
						<input type="reset" value="Reset">
					</form>

					<form action="welcomeMenu.jsp" method="POST">
						<button type="submit">Back to main page</button>
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
