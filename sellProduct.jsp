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
			
					// para poderlos subir al miniebay
			if (request.getParameter("addProduct") != null) {
					String name = request.getParameter("name");
					String desc = request.getParameter("description");
					String dept = request.getParameter("dept_name");
					String startBid = request.getParameter("startBid");
					String dueDate = request.getParameter("dueDate");

					// The browser may not send a usable file path here; keep it optional and avoid NullPointerExceptions.
					String picture = request.getParameter("picture_name");
					if (picture == null) {
						picture = "";
					}
					
					if (name == null || name.isEmpty() ||
						desc == null || desc.isEmpty() ||
						startBid == null || startBid.isEmpty() ||
						dueDate == null || dueDate.isEmpty()) {
						out.println("<p>Please fill out all required fields.</p>");
									
					} else {
						boolean ok = dbm.addProduct(name, desc, dept, startBid, dueDate, picture, userName);
						if (ok) {
							out.println("<p>Product listed successfully!</p>");
							response.sendRedirect("upload.jsp"); // para hacerme la vida mas facil, sube la foto 2 veces
						} else {
							out.println("<p>Failed to list product. Please check your inputs (especially date/price format).</p>");
						}
					}
			}
				%>

					<h2>Sell a Product</h2>

					<form action="sellProduct.jsp" method="POST">
						Name: <input type="text" name="name" required><br>
						Description: <input type="text" name="description" required><br>
						Starting Bid $: <input type="text" name="startBid" required><br>
						Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
					<!--use the picture for the name-->
						Picture: <input type="file" name="picture_name" size="50" required/><br>
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

				// After authentication and DB cleanup, perform any pending redirect
				if ("true".equals(session.getAttribute("redirectToUpload"))) {
					session.removeAttribute("redirectToUpload");
					response.sendRedirect("upload.jsp");
					return;
				}
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
