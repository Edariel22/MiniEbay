<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Modify Products as an Admin.</title>
	</head>
	<body>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));
if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));

session.setAttribute("previousPage", "welcomeMenu.jsp");
session.setAttribute("currentPage", "adminProducts.jsp");

try {

    //Authenticate if the user is logged in, if not redirect the user to login hashing
    if (session.getAttribute("userName") == null) {
        response.sendRedirect("loginHashing.html");
    } else {
        String currentPage = "adminProducts.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("previousPage").toString();

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
            session.setAttribute("currentPage", currentPage);

            // Add product
            if (request.getParameter("addProduct") != null) {
                String name = request.getParameter("name");
                String deptId = request.getParameter("deptId");
                String startBid = request.getParameter("startBid");
                String dueDate = request.getParameter("dueDate");
                // Use admin helper for adding products
                dbm.addProductAdmin(name, deptId, startBid, dueDate);
            }

            // Modify product
            if (request.getParameter("modifyProduct") != null) {
                int productId = Integer.parseInt(request.getParameter("removeProductId"));
                String name = request.getParameter("name");
                String deptId = request.getParameter("deptId");
                String startBid = request.getParameter("startBid");
                String dueDate = request.getParameter("dueDate");

                boolean res = dbm.updateProductAdmin(productId, name, deptId, startBid, dueDate);

                if (res) {
                    out.println("<p>Product modified successfully.</p>");
                } else {
                    out.println("<p>Failed to modify product.</p>");
                }
            }

            // Remove product
            if (request.getParameter("removeProduct") != null) {
                int productId = Integer.parseInt(request.getParameter("removeProductId"));
                // Use admin helper for removing products
                dbm.removeProductAdmin(productId);
            }

            // List products using admin helper
            ResultSet rs = dbm.listProductsAdmin();
%>

<h2>Admin - Product Management</h2>

<table border="1">
<tr><td>ID</td><td>Name</td><td>Dept ID</td><td>Start Bid</td><td>Due Date</td></tr>
<%
while(rs.next()){
	out.print("<tr>");
	out.print("<td>"+rs.getString("product_id")+"</td>");
	out.print("<td>"+rs.getString("name")+"</td>");
	out.print("<td>"+rs.getString("dept_id")+"</td>");
	out.print("<td>"+rs.getString("start_bid")+"</td>");
	out.print("<td>"+rs.getString("due_date")+"</td>");
	out.print("</tr>");
}
rs.close();
// Close the connection to the database
dba.close();
dbm.close();
        }
    }

} catch (Exception e) {
    //If an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
} finally {
    System.out.println("Finallly");
}
%>
	</table>

		<h3>Add Product</h3>
		<form method="POST" action="adminProducts.jsp">
		Name: <input type="text" name="name"><br>
		Dept ID: <input type="text" name="deptId"><br>
		Start Bid: <input type="text" name="startBid"><br>
		Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate"><br>
		<input type="submit" name="addProduct" value="Add">
		</form>

		<h3>Modify Product</h3>
		<form method="POST" action="adminProducts.jsp">
		Product ID: <input type="text" name="removeProductId"><br>
		Name: <input type="text" name="name"><br>
		Dept ID: <input type="text" name="deptId"><br>
		Start Bid: <input type="text" name="startBid"><br>
		Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate"><br>
		<input type="submit" name="modifyProduct" value="Modify">
		</form>

		<h3>Remove Product</h3>
		<form method="POST" action="adminProducts.jsp">
		Product ID: <input type="text" name="removeProductId"><br>
		<input type="submit" name="removeProduct" value="Remove">
		</form>
		<a href="welcomeMenu.jsp">Return to Main Menu</a>
	</body>
</html>
