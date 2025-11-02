<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
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
				
				//Create the appDBAuth object
                applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
                System.out.println("Connecting...");
                System.out.println(appDBAuth.toString());
                
				//Create the appDBMnger object
				applicationDBManager appDBMnger = new applicationDBManager();
                System.out.println("Connecting...");
				System.out.println(appDBMnger.toString());

                //Call the verifyUser method to authenticate the user
                ResultSet resUser = appDBAuth.verifyUser(userName, currentPage, previousPage);

                // Verify if the user has been authenticated
                if (resUser.next()){
                    String sessionName = resUser.getString(3);

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
                    ResultSet resProd = null;

                    resProd = appDBMnger.listProducts(productName, deptName);

                    // Iterate over the ResultSet
                    int count = 0;

                    while (resProd.next()) {
                        // Count each retrieved record from the query
                        count++;
                        %>
                        <tr>
                            <!-- ID: <%=resProd.getString(1)%>, <br> -->
                            NAME: <%=resProd.getString(2)%> <br>
                            <!-- DESCRIPTION: <%=resProd.getString(3)%>, <br> -->
                            DEPARTMENT: <%=resProd.getString(4)%> <br>
                            BID $<%=resProd.getString(5)%> <br>
                            DUE DATE: <%=resProd.getString(6)%> <br>
                            <!-- SELLER: <%=resProd.getString(7)%>, <br> -->
                            <img src="../images/<%=resProd.getString(8)%>" alt="<%=resProd.getString(2)%>" style="width: 200px; height: auto;">  <br> <br>
                             <form action="displayItem.jsp" method="GET">
                                <!-- Include a hidden input field to store the ID -->
                                <input type="hidden" name="productId" value="<%=resProd.getString(1)%>">
                                <input type="hidden" name="productName" value="<%=productName %>">
                                <input type="hidden" name="dept_name" value="<%=deptName %>">
                                <input type="submit" value="View Item"> <br> <br>
                            </form>
                        </tr>
                    <%}

                    %>
                    </table>

					<form action="welcomeMenu.jsp" method="POST">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
                    </form>
                    <%
                }else{
                    //Close any session associated with the user
					session.setAttribute("userName", null);

					//return to the login page
					response.sendRedirect("loginHashing.html");
                }
                //Close the connection to the database
				appDBAuth.close();
				appDBMnger.close();
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




