<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Mini Ebay: Find Products</title>
	</head>
    <body>
		
<%
	// Try to connect the database using the applicationDBManager class
    try{
            //Authenticate if the user is logged in, if not send the user back to the login page
            if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
    			session.setAttribute("currentPage", null);
    			session.setAttribute("userName", null);
   	 			response.sendRedirect("loginHashing.html");
				
			}else{
					String currentPage = "findProduct.jsp";
					String userName = session.getAttribute("userName").toString();
					String previousPage = session.getAttribute("currentPage").toString();
				
				//Create the dba object (database authenticator)
                applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
                System.out.println("Connecting...");
                System.out.println(dba.toString());
                
				//Create the dbm object (database manager)
				applicationDBManager dbm = new applicationDBManager();
                System.out.println("Connecting...");
				System.out.println(dbm.toString());

                //Call the verifyUser method to authenticate the user
                ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

                // Verify if the user has been authenticated
                if (rsUser.next()){
                    String sessionName = rsUser.getString(3);

                    // Create the current page attribute
                    session.setAttribute("currentPage", currentPage);

                    // Create a session variable
                    if (session.getAttribute("userName") == null) {
                        // Create the session variable
                        session.setAttribute("userName", userName);
                    }else{
                        //Update the session variable
                        session.setAttribute("userName", userName);
                    }

                    // Retrieve parameters
                    String productName = request.getParameter("productName");
                    String deptName = request.getParameter("dept_name");

                    // Get the ResultSet based on parameters
                    ResultSet rsProd = null;

                    rsProd = dbm.listProducts(productName, deptName);

                    // Iterate over the ResultSet
                    int n = 0;

                    while (rsProd.next()) {
                        // Count each of the retrieved items from the query
                        n++;
                        %>
                        <tr>
								<%=rsProd.getString(1)%>, <!-- first, get the ID -->
                            NAME:	<%=rsProd.getString(2)%> <br> <!-- then, get the name -->
								<%=rsProd.getString(3)%>, <!-- finally, get the description to complete the product stuff -->
                            DEPARTMENT: <%=rsProd.getString(4)%> <br> <!-- then, get the department it's from -->
                            BID $<%=rsProd.getString(5)%> <br> <!-- then, get the BID value -->
                            DUE DATE: <%=rsProd.getString(6)%> <br> <!-- then, get the Due date for the bid -->
								<%=rsProd.getString(7)%>	<!-- then, get the seller's name -->
                          <img src="/MiniEbay<%= rsProd.getString("picture_path") %>"
     alt="<%= rsProd.getString("name") %>"
     style="width:200px; height:auto;">

                             <form action="displayItem.jsp" method="GET">
                                <!-- Include a hidden input field to store the ID -->
                                <input type="hidden" name="productId" value="<%=rsProd.getString(1)%>">
                                <input type="hidden" name="productName" value="<%=productName %>">
                                <input type="hidden" name="dept_name" value="<%=deptName %>">
                                <input type="submit" value="View Item"> <br> <br>
                            </form>
                        </tr>
                    <%}

                    %>
                    </table>

					<form action="welcomeMenu.jsp" method="POST">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Return to the main page</button>
                    </form>
                    <%
                }else{
                    //Close any session that is associated with the user
					session.setAttribute("userName", null);

					//send them back to the login page
					response.sendRedirect("loginHashing.html");
                }
                //Close the connection to the database
				dba.close();
				dbm.close();
            }
        }catch(Exception e){
            // Print error message if exception occurs
            e.printStackTrace();
            response.sendRedirect("loginHashing.html");

        }finally{
            System.out.println("Finally");
        }
%>
</body>
</html>




