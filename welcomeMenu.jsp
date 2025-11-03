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
 	
	session.setAttribute("previousPage", "validationHashing.jsp");
	session.setAttribute("currentPage", "welcomeMenu.jsp");

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
				Welcome! <%=userActualName%>
				
				<!-- Plz find me-->
				<form action="findProduct.jsp" method="GET">
					<label for="search">Search:</label>
					<input type="text" id="productName" name="productName" placeholder="Enter product name">
					<button type="submit">Search</button>
					

					<%
					ResultSet rsDept=dbm.listAllDepartment();
					%>
					<!-- List the departments -->
					<form action="findProduct.jsp" method="GET">
						<table border="0">
							<tr>
								<td> Department </td>
								<td>
									<select id="dept_name" name="dept_name" style="width: 200px; font-size: 16px;">
									<option value="All Departments">All Departments</option>
									<%
										while (rsDept.next()) {
											String deptId = rsDept.getString("dept_id");
											String deptName = rsDept.getString("name");
									%>
											<option value="<%= deptId %>"><%= deptName %></option>
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
					//Menu moment
					ResultSet rsMenu = dba.menuElements(userName);
					String setMenu="";

					while(rsMenu.next()){

						//Check to create (if not empty) a new menu element
						if (setMenu.compareTo(rsMenu.getString(2))!=0){ 
							//set the Menu to a new element
						    setMenu = rsMenu.getString(2);
							%><tr><td><%=setMenu%> <td></tr><%
						}

						//show the page title and set a hyperlink
					%><tr><td>-</td><td><a href="<%=rsMenu.getString(1)%>?userName=<%=userName%>&roleId=<%=session.getAttribute("roleId")%>"><%=rsMenu.getString(3)%></a><%
					
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
