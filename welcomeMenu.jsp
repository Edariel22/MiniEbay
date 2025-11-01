<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Home page for Mini Ebay!</title>
	</head>
	<body>
	<%
 	//Try to connect the database using the classes applicationDBManager & applicationDBAuthenticationGoodComplete
	try{
			//Check the authentication process
			if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("loginHashing.html"); // send the User back to the login page
			}
			else{
			String currentPage="welcomeMenu.jsp";
			String userName = session.getAttribute("userName").toString();
			String previousPage = session.getAttribute("currentPage").toString();
		
			//Create the appDBAuth object
			applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());

			//Create the appDBMnger object
			applicationDBManager appDBMnger = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMnger.toString());
				
			//Call the verifyUser method
			ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
			
			//Check if the user has been authenticated
			if (res.next()){
				String userActualName=res.getString(3);
					
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
				Welcome! <%=userActualName%>
				
				<!-- Search Form-->
				<form action="findProduct.jsp" method="GET">
					<label for="search">Search:</label>
					<input type="text" id="productName" name="productName" placeholder="Enter product name">
					<button type="submit">Search</button>
					

					<%ResultSet resDept=appDBMnger.listAllDepartments();%>
					<!-- Department Dropdown List -->
					<form action="findProduct.jsp" method="GET">
						<table border="0">
							<tr>
								<td> Department </td>
								<td>
									<select id="dept_name" name="dept_name" style="width: 200px; font-size: 14px;">
										<option value="All Departments"> All Departments</option>
										<%
											while (resDept.next()) {
												%>
												<option value="<%= resDept.getString(1) %>"><%= resDept.getString(1) %></option>
												<%
											}
										%>
									</select>
								</td>
							</tr>
						</table>
						<input type="reset" id="Submit" value="reset" />
						<a href="signout.jsp">
								<button type="button">Sign Out</button>
							</a>
					</form>
					<table>
					<%
					//draw the menu
					ResultSet resMenu = appDBAuth.menuElements(userName);
					String currentMenu="";

					while(resMenu.next()){

						//Check to create a new menu element
						if (currentMenu.compareTo(resMenu.getString(2))!=0){ 

							//A new element
						    currentMenu = resMenu.getString(2);
							%><tr><td><%=currentMenu%> <td></tr><%
						}

						//print the page title and establish a hyperlink
						%><tr><td>-</td><td><a href="<%=resMenu.getString(1)%>"><%=resMenu.getString(3)%></a><%
					} 
					//Close the table 
					%>
					</table>
					<%
					
				}else{
					//Close any session associated with the user
					session.setAttribute("userName", null);
					
					//return to the login page
					response.sendRedirect("loginHashing.html");
				}
				//res.close();

				//Close the connection to the database
				appDBAuth.close();
				appDBMnger.close();
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
