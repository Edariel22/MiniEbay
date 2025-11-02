<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*" %>
<html>
	<head>
		<title>Product Details</title>
	</head>
	<body>

<%
try {

    //Authenticate if the user is logged in, if not redirect the user to login hashing
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
    	session.setAttribute("currentPage", null);
    	session.setAttribute("userName", null);
   	 	response.sendRedirect("loginHashing.html");
	}else{
		String productId = request.getParameter("productId");

        String currentPage = "displayItem.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();


        //Create dba object
        applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(dba.toString());

        //Create dbm object
        applicationDBManager dbm = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(dbm.toString());


        //Call the verifyUser method to authenticate the user
        ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

        // Verify if the user has been authenticated
        if (rsUser.next()) {
            String userActualName = rsUser.getString(3);

            // Create the current page attribute
            session.setAttribute("currentPage", currentPage);

            // Create a session variable
            if (session.getAttribute("userName") == null) {
                // Create the session variable
                session.setAttribute("userName", userName);
            } else {
                // Update the session variable
                session.setAttribute("userName", userName);
            }
				if (productId == null || productId.isEmpty()) {
					out.println("<h3>No product selected.</h3>");
					ResultSet rs = dbm.getProductById(Integer.parseInt(productId));

					if (rs.next()) {
						%>
							<h2><%=rs.getString("name")%></h2>
							<p><b>Description:</b> <%=rs.getString("description")%></p>
							<p><b>Department:</b> <%=rs.getString("dept_id")%></p>
							<p><b>Start Bid:</b> $<%=rs.getString("start_bid")%></p>
							<p><b>Due Date:</b> <%=rs.getString("due_date")%></p>
						<%
							ResultSet highest = dbm.getHighestBid(Integer.parseInt(productId));
								if (highest.next() && highest.getString("highest_bid") != null) {
									out.println("<p><b>Current Highest Bid:</b> $" + highest.getString("highest_bid") + "</p>");
								} else {
									out.println("<p><b>No bids yet.</b></p>");
								}
							highest.close();
						%>

						<a href="bidProduct.jsp?productId=<%=productId%>">Place a Bid</a>

						<img src="/MiniEbay<%=rs.getString("picture_path")%>" width="200" height="200">
						<%
					} else {
				out.println("<h3>Product not found.</h3>");
					}
					rs.close();
				}
			}else{
            //Close any session associated with the user
		    session.setAttribute("userName", null);

            //return to the login page
		    response.sendRedirect("loginHashing.html");
			}

		
		// Close the connection to the database
		dba.close();
		dbm.close();
		} 
}catch(Exception e) {
    //If an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
}finally{
    System.out.println("Finallly");
}
%>
<br><a href="findProduct.jsp">← Return to Product Search</a>
</body>
</html>
